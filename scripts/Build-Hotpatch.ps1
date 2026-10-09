<#
.SYNOPSIS
    一键差量热修构建脚本 (无需全量重编，3~5 秒直达登录器)

.DESCRIPTION
    以登录器运行态 SWF 为基底，利用内置 FFDec 将修改后的 AS3 源码类差量替换注入，
    自动处理 CoreDLL 7 字节前缀封包，直接热生效到 x32 便携登录器。

.PARAMETER Target
    目标 UI 系统: 'OldUI' (CoreDLL, fui=1) 或 'NewUI' (FramePlayer, fui=2)

.PARAMETER Class
    完整类名，例如 'animation.layer.PetLayer' 或 'com.taomee.seer2.core.animation.FramePlayer'

.PARAMETER SourceFile
    可选。改动后的 .as 文件路径。若不指定，将自动在对应的 old-ui/scripts 或 new-ui/scripts 中查找。

.EXAMPLE
    .\Build-Hotpatch.ps1 -Target NewUI -Class "animation.layer.PetLayer"
    .\Build-Hotpatch.ps1 -Target OldUI -Class "com.taomee.seer2.app.arena.animation.FighterAnimation"
#>

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Class,

    [Parameter(Mandatory = $false)]
    [ValidateSet('OldUI', 'NewUI', 'Auto')]
    [string]$Target = 'Auto',

    [Parameter(Mandatory = $false)]
    [string]$SourceFile,

    [Parameter(Mandatory = $false)]
    [string]$LauncherSkinDir = "D:\seer2-chunshu-launcher\output\no-obfuscate\packages\x32-unpacked\local-res\skin-mode",

    [Parameter(Mandatory = $false)]
    [string]$DevSourceSkinDir = "D:\seer2-chunshu-launcher\src\common\local-res\skin-mode"
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$repoRoot = Split-Path -Parent $PSScriptRoot
$ffdecJar = Join-Path $repoRoot "tools\ffdec\ffdec.jar"
$codecPy = Join-Path $repoRoot "scripts\coredll_codec.py"

# 1. 解析 Java 路径
$javaCmd = "java"
if (-not (Get-Command $javaCmd -ErrorAction SilentlyContinue)) {
    $fallbackJava = @(Get-Item "C:\Program Files\Eclipse Adoptium\jdk-11*\bin\java.exe" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
    if ($fallbackJava.Count -gt 0) {
        $javaCmd = $fallbackJava[0]
    } else {
        throw "未找到可用 Java 环境，请确保 Java 已加入 PATH 或安装于标准目录。"
    }
}

# 2. 基础路径校验
if (-not (Test-Path -LiteralPath $ffdecJar)) {
    throw "FFDec 工具缺失: $ffdecJar"
}
if (-not (Test-Path -LiteralPath $LauncherSkinDir)) {
    throw "登录器 skin-mode 目录不存在: $LauncherSkinDir"
}

# 3. 自动解析 Target 与源码路径
$relPath = ($Class -replace '\.', '\') + ".as"
$oldFile = Join-Path $repoRoot "old-ui\scripts\$relPath"
$newFile = Join-Path $repoRoot "new-ui\scripts\$relPath"

if ($Target -eq 'Auto') {
    if (Test-Path -LiteralPath $newFile) {
        $Target = 'NewUI'
        if (-not $SourceFile) { $SourceFile = $newFile }
    } elseif (Test-Path -LiteralPath $oldFile) {
        $Target = 'OldUI'
        if (-not $SourceFile) { $SourceFile = $oldFile }
    } else {
        throw "无法在 old-ui 或 new-ui 中自动定位类: $Class。请检查类名或显式传递 -SourceFile。"
    }
} else {
    if (-not $SourceFile) {
        $SourceFile = if ($Target -eq 'OldUI') { $oldFile } else { $newFile }
    }
}

if (-not (Test-Path -LiteralPath $SourceFile)) {
    throw "源码文件不存在: $SourceFile"
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Seer2 双 UI 差量热修构建引擎" -ForegroundColor Cyan
Write-Host "  目标架构: $Target" -ForegroundColor Yellow
Write-Host "  修改类名: $Class" -ForegroundColor Yellow
Write-Host "  源码文件: $SourceFile" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$sw = [System.Diagnostics.Stopwatch]::StartNew()
$tempDir = Join-Path $repoRoot ".codex-tmp"
if (-not (Test-Path $tempDir)) { New-Item -ItemType Directory -Path $tempDir | Out-Null }

try {
    if ($Target -eq 'NewUI') {
        # ========================================================
        # 新 UI (FramePlayer) 差量热修
        # ========================================================
        $targetSwf = Join-Path $LauncherSkinDir "FramePlayer.swf"
        if (-not (Test-Path -LiteralPath $targetSwf)) {
            throw "登录器 FramePlayer.swf 缺失: $targetSwf"
        }

        $tempOut = Join-Path $tempDir "FramePlayer.hotpatch.tmp.swf"
        Write-Host "[1/2] 正在调用内置 FFDec 将类差量注入 FramePlayer.swf..." -ForegroundColor Cyan

        & "$javaCmd" -Xmx8g -jar "$ffdecJar" -replace "$targetSwf" "$tempOut" "$Class" "$SourceFile"
        if ($LASTEXITCODE -ne 0) { throw "FFDec 替换失败, 退出码: $LASTEXITCODE" }

        # 原子覆写登录器运行包
        Move-Item -LiteralPath $tempOut -Destination $targetSwf -Force
        Write-Host "[2/2] 已覆盖便携登录器: $targetSwf ($((Get-Item $targetSwf).Length) 字节)" -ForegroundColor Green

        # 同步推送到源码开发目录（若存在）
        if (Test-Path -LiteralPath $DevSourceSkinDir) {
            Copy-Item -LiteralPath $targetSwf -Destination (Join-Path $DevSourceSkinDir "FramePlayer.swf") -Force
            Write-Host "      已同步源码仓库: $DevSourceSkinDir\FramePlayer.swf" -ForegroundColor DarkGray
        }
    }
    else {
        # ========================================================
        # 老 UI (CoreDLL) 差量热修
        # ========================================================
        $targetSwf = Join-Path $LauncherSkinDir "CoreDLL.swf"
        if (-not (Test-Path -LiteralPath $targetSwf)) {
            throw "登录器 CoreDLL.swf 缺失: $targetSwf"
        }

        $tempPlain = Join-Path $tempDir "CoreDLL.plain.tmp.swf"
        $tempOut = Join-Path $tempDir "CoreDLL.hotpatch.tmp.swf"

        # 步骤 1: 内存流解包（7 字节 null + zlib -> Plain SWF）
        Write-Host "[1/3] 正在解密 CoreDLL 包装容器..." -ForegroundColor Cyan
        python "$codecPy" unpack "$targetSwf" "$tempPlain"
        if ($LASTEXITCODE -ne 0) { throw "CoreDLL 解包失败" }

        # 步骤 2: FFDec 差量替换
        Write-Host "[2/3] 正在调用内置 FFDec 差量注入纯净 SWF..." -ForegroundColor Cyan
        & "$javaCmd" -Xmx8g -jar "$ffdecJar" -replace "$tempPlain" "$tempOut" "$Class" "$SourceFile"
        if ($LASTEXITCODE -ne 0) { throw "FFDec 替换失败, 退出码: $LASTEXITCODE" }

        # 步骤 3: 重新封包（7×0x00 + zlib level 9 + 双向回环验证）
        Write-Host "[3/3] 正在重新封包并执行双向回环哈希校验..." -ForegroundColor Cyan
        python "$codecPy" pack "$tempOut" "$targetSwf"
        if ($LASTEXITCODE -ne 0) { throw "CoreDLL 重新封包失败" }

        # 清理临时文件
        Remove-Item -Force $tempPlain, $tempOut -ErrorAction SilentlyContinue
        Write-Host "      已覆盖便携登录器: $targetSwf ($((Get-Item $targetSwf).Length) 字节)" -ForegroundColor Green

        # 同步推送到源码开发目录（若存在）
        if (Test-Path -LiteralPath $DevSourceSkinDir) {
            Copy-Item -LiteralPath $targetSwf -Destination (Join-Path $DevSourceSkinDir "CoreDLL.swf") -Force
            Write-Host "      已同步源码仓库: $DevSourceSkinDir\CoreDLL.swf" -ForegroundColor DarkGray
        }
    }

    $sw.Stop()
    Write-Host "----------------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host "[SUCCESS] 热修构建完成，总耗时: $([math]::Round($sw.Elapsed.TotalSeconds, 2)) 秒" -ForegroundColor Green

    # 登录器状态提示
    $launcherProc = Get-Process -Name "*春树*" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($launcherProc) {
        Write-Host "[提示] 登录器运行中 (PID: $($launcherProc.Id))，重新进入对战或按 F5 刷新即刻生效！" -ForegroundColor Yellow
    } else {
        Write-Host "[提示] 登录器未运行，可在便携包目录下直接启动验证。" -ForegroundColor DarkGray
    }
}
catch {
    Write-Error "构建部署异常: $_"
    throw
}
