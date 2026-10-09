# AGENTS.md

> **反直觉错误与混淆点 (Counter-Intuitive Traps)**
> 1. **全量重编译必定致盲 (Full Rebuild Hazard)**：`FramePlayer.swf` 与 `CoreDLL.swf` 绝非纯代码工程，而是自包含 58+ 个非 ABC 图元、嵌套 MovieClip 与时间轴的复合二进制；使用编译器全量重编必定使 SWF 沦为无美术无按钮的残缺空壳，且会因缺少 `framework.swc` 触发致命 `VerifyError #1014`。构建一律仅限单类定向差量替换。
> 2. **双 UI 物理绝缘但逻辑镜像 (Physically Disjoint, Logically Mirrored)**：老 UI (`fui=1`, CoreDLL) 走 Fighter 渲染层，新 UI (`fui=2`, FramePlayer) 走自包含 7 大图层与独立时间轴。修改一端不会自动影响另一端，但两者共用相同的精灵皮肤模型 (`fight.swf`) 与视口中心对齐契约。
> 3. **严禁在 UI 侧做任何缩放补丁 (Zero Scale Mutation)**：所有精灵模型均已在 2026-09-27 基线归一化为 1:1 原生比例 (`outputScale: 1`)。全屏大招 Quad 漏白物理成因为站位偏置，必须通过 `globalToLocal(600, 330)` 反向平移对齐舞台中心，严禁引入 1.12x、`scale > 1`、ShapeCover 等任何启发式放大，防止刀光与肢体透视崩坏。

## 核心开发纪律

1. **源码真理源守卫**：
   - 老 UI 逻辑维护于 `old-ui/scripts/`（4,222 个类）；
   - 新 UI 逻辑维护于 `new-ui/scripts/`（320 个类）；
   - 源码直接原位修改，不设临时副本草稿。

2. **秒级差量部署**：
   - 源码修改后，执行 `.\scripts\Build-Hotpatch.ps1 -Target <OldUI|NewUI> -Class <类全名>`；
   - 脚本自动调用内置 FFDec 完成 ABC 字节码原位打入并直达 x32 运行态登录器，全程耗时不超过 5 秒。

3. **前台真机直接验收**：
   - 彻底废除外部脱机模拟壳，部署后直接在运行中的 x32 便携登录器中进对战验证（刷新或重入对战即刻生效）。
