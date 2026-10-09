# Seer2 Dual UI Clean Codebase & Hotpatching Workbench

本项目为赛尔号2（Seer2）双 UI 战斗引擎的 ActionScript 3 源码真理源库与极速差量热修工作台。

## 1. 架构总览

客户端底层包含两条物理隔离但概念对齐的战斗显示引擎链：

```text
seer2-dual-ui/
├── old-ui/                     # 老 UI (CoreDLL, fui=1 默认高频)
│   └── scripts/                # 4,222 个 AS3 源码类 (战斗底层、Fighter、动画调度)
│
├── new-ui/                     # 新 UI (FramePlayer, fui=2 独立引擎)
│   ├── scripts/                # 320 个 AS3 源码类 (独立 7 图层、自包含时间轴渲染引擎)
│   └── symbolClass/            # 符号映射表 (symbols.csv)
│
├── tools/                      # 便携免安装工具链
│   └── ffdec/                  # 内置 FFDec 差量注入器 (ffdec.jar + 依赖库)
│
├── scripts/                    # 自动化构建脚本
│   └── Build-Hotpatch.ps1      # 3~5 秒一键差量注入并直推登录器
│
├── .gitignore                  # 屏蔽所有 *.swf 二进制与构建临时产物
├── AGENTS.md                   # 架构排坑防线与行为准则
└── README.md                   # 本文档
```

## 2. 纯净架构哲学（零二进制包袱）

* **SWF 纯产物定锚**：SWF 本身由登录器或构建流水线提供，不作为代码库的历史包袱沉淀于 Git 中。
* **零编译污染**：彻底废除对整个 SWF 的从零全量重编译，100% 保持原生非 ABC 标签（美术贴图、时间轴帧、按钮、声音）逐字节守恒。
* **最小定向差量**：修改哪一个源码类，仅差量替换该类的 ABC 字节码。

## 3. 一键热修工作流

### 步骤 1：就地修改源码
* 修改老 UI：在 `old-ui/scripts/` 中修改目标 `.as` 文件；
* 修改新 UI：在 `new-ui/scripts/` 中修改目标 `.as` 文件。

### 步骤 2：单行命令差量打入生效

在 PowerShell 中原位执行：

```powershell
# 示例 1: 修改了新 UI 的渲染层 (PetLayer.as)
.\scripts\Build-Hotpatch.ps1 -Target NewUI -Class "animation.layer.PetLayer"

# 示例 2: 修改了老 UI 的动画调度 (FighterAnimation.as)
.\scripts\Build-Hotpatch.ps1 -Target OldUI -Class "com.taomee.seer2.app.arena.animation.FighterAnimation"
```

*脚本将自动读取当前前台运行的 x32 便携登录器 (`x32-unpacked/local-res/skin-mode/`) 中的 SWF 作为基线，完成定向打入并原子写回，耗时约 3~5 秒。*

### 步骤 3：实机即时验收
在前台登录器中重新进入对战或按 F5 刷新，修改立即生效。
