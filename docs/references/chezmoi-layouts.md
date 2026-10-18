# chezmoi 仓库目录结构调研

[返回 README](../../README.md)

## 范围与结论

本报告记录本仓库引入 `home/` 前的目录调研。核对了公开仓库目录、关键配置与 chezmoi 官方文档；没有执行参考项目的安装程序。上游分支链接可能随时间变化，不代表自动跟踪上游。

采用：仓库根目录维护工程，`home/` 保存用户主目录的部署源，通过 `.chezmoiroot` 指定。借鉴目录职责，不整体移植参考仓库的安装体系。

## 参考项目与采用情况

| 项目与核查基准 | 实际结构 | 本仓库采用 | 未采用 |
|---|---|---|---|
| [signalridge/dotfiles](https://github.com/signalridge/dotfiles)，本地快照 `b1c0ea4`，并核对在线结构 | 根目录直接作为部署源；`.chezmoidata/` 按领域拆分；生命周期脚本与 `dot_local/bin/` 日常命令分开 | 数据分文件、安装管线职责、初始化交互策略；Git 与 delta 配置 | 根目录混排布局、整机 work/private 分类、Nix/aqua/mise 多套安装链、密钥恢复体系 |
| [twpayne/dotfiles](https://github.com/twpayne/dotfiles/tree/master)，核查 `master` | `.chezmoiroot` 指向 `home`；外层放 README、安装入口、assets；平台脚本在 `home/.chezmoiscripts/` 分类 | `home/` 隔离布局；最低版本文件留在仓库根目录 | 全部平台配置、现阶段的平台脚本子目录 |
| [felipecrs/dotfiles](https://github.com/felipecrs/dotfiles/tree/master)，调研树 SHA `54cd0a2be663b5d0d2292b0afce95fd9438588ba` | `home/` 为用户部署源；外层 `scripts/` 放仓库工具；另有系统级 `root/` | 仓库工具／apply 生命周期／日常命令三分；初始化保存 working tree 路径 | 系统级部署、多发行版矩阵、带 hard reset 和 clean 的远程引导行为 |
| [dngray/dotfiles](https://github.com/dngray/dotfiles/tree/main)，调研树 SHA `265bb44562e72b74b03b80dd8a54de1632646adf` | `.chezmoiroot` 指向 `home`，外层很薄；日常命令与安装脚本分开 | 轻量分层思路，不因采用 home 就预建庞大框架 | Vault、主机 profile、个人 Linux 安装逻辑 |

上表保留目录调研时的快照记录。已引入配置后来核对至 signalridge
[`a978087`](https://github.com/signalridge/dotfiles/commit/a978087)：
Git、delta、bat、btop、gh 对应的八份上游文件相对 `b1c0ea4` 没有变化。
本仓库仅在 Git 配置中保留本机目录身份 include；其余七份与新基线一致。
这次对齐不代表重新审计或引入参考项目的其他功能。

后续按同一 `a978087` 基线精选移植 Lazygit 与 Yazi 配置，不按原样复制计数。
Lazygit 禁用自动 fetch 和自动暂存冲突解决结果，只保留明确需要的自定义命令；
Yazi 按当前版本适配配置与内置插件，不引入缺少配套的压缩插件。
具体来源、偏离和生效路径见 [Lazygit 指南](../guides/lazygit.md)与
[Yazi 指南](../guides/yazi.md)。

再一批配置中，Herdr 与 mise 按 `a978087` 原样引入；
AeroSpace 使用参考模板配合本机应用数据清单（不引入整机 work/private 分类），Karabiner 保留用户配置。
tmux 明确暂不纳管。配置来源与运行边界分别见
[Herdr](../guides/herdr.md)、[mise](../guides/mise.md)、
[AeroSpace](../guides/aerospace.md)、[Karabiner](../guides/karabiner.md)。
未引入 Herdr 状态和插件安装流程，也未新增 mise 安装或升级脚本；
mise 本身的 `auto_install = true` 按原版保留，不能等同于禁止未来自动安装。

这里的树 SHA 用于标识调研快照，不是本仓库依赖锁，也不表示复制了对应仓库代码。

具体证据：

- twpayne：[源目录选择](https://github.com/twpayne/dotfiles/blob/master/.chezmoiroot)、[home 源文件](https://github.com/twpayne/dotfiles/tree/master/home)、[平台脚本](https://github.com/twpayne/dotfiles/tree/master/home/.chezmoiscripts)。
- felipecrs：[源目录选择](https://github.com/felipecrs/dotfiles/blob/master/.chezmoiroot)、[初始化与 sourceDir 保存](https://github.com/felipecrs/dotfiles/blob/master/home/.chezmoi.yaml.tmpl)、[仓库脚本](https://github.com/felipecrs/dotfiles/tree/master/scripts)、[日常命令](https://github.com/felipecrs/dotfiles/tree/master/home/dot_local/bin)。
- dngray：[源目录选择](https://github.com/dngray/dotfiles/blob/main/.chezmoiroot)、[home 源文件](https://github.com/dngray/dotfiles/tree/main/home)。
- signalridge 的具体能力与风险见[专题报告](signalridge-dotfiles.md)。

## 本仓库的目录边界

- 仓库根目录：安装入口、文档、CI、仓库检查工具；不作为目标主目录的镜像。
- `home/`：按最终目标路径组织部署内容，不再增加一套自定义 modules 映射体系。
- `home/.chezmoidata/`：可入库的静态模板数据。文件名不自动形成命名空间，内容合并到同一数据字典。
- `home/.chezmoi.toml.tmpl`：生成本机 chezmoi 配置，保存初始化选项与仓库路径；不是直接部署的应用配置。
- `home/.chezmoiscripts/`：apply 生命周期动作，目前两个 Homebrew 脚本保持平铺。
- `scripts/`：仓库内人工或 CI 调用的脚本。
- `docs/guides/`：本仓库实际配置的使用维护方法；`docs/references/`：外部来源、比较与取舍。

日常 Git 身份工具已迁入 `home/dot_local/bin/executable_git-identity`，
部署目标为 `~/.local/bin/git-identity`，旧仓库脚本入口已删除。
本次仅迁移入口并更新说明，不修改本机数据格式或身份匹配逻辑；
已知路径标识冲突、嵌套目录优先级和自定义 XDG 路径问题尚未修复，限制见
[Git 指南](../guides/git.md)。

工作等额外 Git 身份仅保存在本机，不因目录重组进入仓库。`private_` 是 chezmoi 权限属性，不表示加密或仅适用于私人机器。

暂不创建没有消费者的共享模板目录、external 配置、平台子目录或测试框架。Brewfile 继续作为软件清单，不另外维护一份重复的包数据。

## 官方约束

- [`.chezmoiroot`](https://www.chezmoi.io/reference/special-files/chezmoiroot/)：在仓库根指定部署源子目录；初始化模板等源状态文件随部署内容迁入 `home/`。
- [`.chezmoiversion`](https://www.chezmoi.io/reference/special-files/chezmoiversion/)：可以位于源目录内任意位置，本仓库留在外层。
- [数据目录](https://www.chezmoi.io/reference/special-directories/chezmoidata/)：数据按字典合并，文件名不创建命名空间；动态本机数据应由初始化模板生成。
- [`include`](https://www.chezmoi.io/reference/templates/functions/include/)：相对路径基于有效源目录，迁移后 Brewfile 的 include 不应再添加 home 前缀。

本仓库使用 `sourceDir = {{ .chezmoi.workingTree | quote }}` 保存仓库根路径，由 `.chezmoiroot` 解析实际源目录。目录迁移保留原安装入口，不把身份配置耦合进去。

## 已做验证与边界

迁移前后对照了托管目标、Git 与 Homebrew 脚本渲染结果；纯移动文件内容与原权限保持一致。在临时 HOME 中完成初始化、源路径持久化、排除生命周期脚本的配置部署及有效 Git 身份读取。README 结构树和 CI 源路径断言通过。

这些验证不等于全新机器完整安装成功；未执行真实 Homebrew 安装，也未运行其他参考仓库的配置。上游代码许可需要独立核对，注明参考来源不能替代再分发授权。
