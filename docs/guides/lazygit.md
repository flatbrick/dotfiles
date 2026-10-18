# Lazygit 配置

[返回 README](../../README.md)

## 来源与范围

配置参考 [signalridge/dotfiles 的 `a978087` 版本](https://github.com/signalridge/dotfiles/blob/a978087/private_dot_config/lazygit/config.yml)，不是逐字复制或自动同步。仅纳管 `home/private_dot_config/lazygit/config.yml`，部署目标为 `~/.config/lazygit/config.yml`；不包含作者身份、机器绝对路径、账号、认证令牌或运行状态。

当前本机 `lazygit --version` 报告 Homebrew **0.64.1**。按照该版本的[官方配置文档](https://github.com/jesseduffield/lazygit/blob/v0.64.1/docs/Config.md)和[差异渲染文档](https://github.com/jesseduffield/lazygit/blob/v0.64.1/docs/Custom_DiffRenderers.md)，将参考中的旧 `git.pagers`、`pager`、`externalDiffCommand` 改为 `git.diffRenderers`、`command` 和 `type`。只精选需要的偏好，不复制参考中的五百余行默认设置。

保留与调整：

- Dracula 配色、文件树、暂存差异视图折行；文件树可按反引号临时切换。
- 显式保留 amend、丢弃修改、应用/弹出 stash、无暂存文件提交、外部编辑器改写提交信息及切换 worktree 的确认，不跳过危险操作提示。
- `git.autoFetch: false`，禁止后台自动 fetch；这不禁止用户主动使用 Lazygit 自带的 fetch/pull 操作。
- `git.autoStageResolvedConflicts: false`，冲突解决后由用户检查并手动暂存，也不自动询问继续 merge/rebase。
- `git.skipHookPrefix: ""`，清空上游默认的 `WIP` 前缀，防止仅因提交信息前缀自动跳过 hook；没有复制参考的绕过策略。这不移除 Lazygit 本身的手动无 hook 提交功能。
- 不引入创建 PR、自定义 conventional commit 表单、`git fetch --all --prune` 自定义快捷键；不改 Git 身份或认证。
- 不引入参考的 delta 文件超链接选项，避免把未配置的编辑器跳转当成已生效功能；delta 样式仍复用已纳管文件。

## macOS 生效路径

macOS 默认读取 `~/Library/Application Support/lazygit/config.yml`，不是本仓库的 XDG 目标。仅部署文件不会改变这一默认行为。根据 `lazygit --help`，可以明确指定配置目录：

```sh
lazygit --use-config-dir "$HOME/.config/lazygit"
```

也可仅对一次启动设置环境变量，不修改 shell 配置：

```sh
XDG_CONFIG_HOME="$HOME/.config" lazygit
```

或明确指定配置文件：

```sh
lazygit --use-config-file "$HOME/.config/lazygit/config.yml"
```

检查目录选择可使用 `lazygit --print-config-dir`，比较加上 `--use-config-dir "$HOME/.config/lazygit"` 或上述环境变量后的输出；这里给出的是操作方法，不是已运行的检查结果。现有 `git ui` 或直接 `lazygit` 入口若没有这些参数/环境变量，不能假定会加载本仓库的配置。本次不修改 shell、别名或原 macOS 配置。

全局文件还可能被仓库 `.git/lazygit.yml` 或父目录 `.lazygit.yml` 覆盖，排查偏好不一致时也需检查这些文件。配置目录下的运行状态不纳入本仓库。

## 差异工具与快捷键

`git.diffRenderers` 依次配置：

| 顺序 | 类型 | 命令与用途 |
|---|---|---|
| 1 | `extDiff` | `difft --color=always`，结构化差异 |
| 2 | `stdinFilter` | `delta --config ~/.config/delta/config --paging=never`，复用已纳管的 Dracula 样式 |
| 3 | `stdinFilter` | `less -FRX`，查看普通 Git 彩色差异 |

按 `|` 正向轮换，反斜杠反向轮换；**这是用户切换列表，不是失败 fallback 链**。初始使用第一项，工具缺失或运行失败时不会自动跳到下一项。Lazygit 负责视图滚动；delta 关闭自己的分页，其配置中的 `navigate` 在 Lazygit 中不提供命令行 delta 的导航功能。`wrapLinesInStagingView` 控制暂存视图折行，不强制改写外部渲染器的所有输出布局。

`lazygit`、`difft`（Homebrew 包 `difftastic`）、`delta`（包 `git-delta`）、`gh` 已列入现有 Brewfile；`less` 由系统提供。`code` 需要 VS Code 的命令行入口可用，本次不安装或修改任何软件。delta 样式文件部署方式见 [Git 配置](git.md)。

| 所在面板 | 按键 | 操作 |
|---|---|---|
| Files | `O` | `code -- {{.SelectedFile.Name \| quote}}`，打开所选文件 |
| Local branches | `Ctrl+O` | `gh pr view --web`，查看当前检出分支关联的 PR，并非光标选中的其他分支 |
| Status | `O` | `gh repo view --web`，打开当前仓库 |

文件路径使用 Lazygit [官方 `quote` 模板函数](https://github.com/jesseduffield/lazygit/blob/v0.64.1/docs/Custom_Command_Keybindings.md#quoting)进行平台适配的转义，再用 `--` 终止 VS Code 参数解析，避免空格、引号和以连字符开头的文件名被当作命令片段或选项。模板属于 Lazygit，不是 chezmoi 模板，因此源文件使用普通 `.yml` 而非 `.tmpl`。

在 Local branches 上，`Ctrl+O` 用于上述自定义命令，覆盖该上下文的通用复制快捷键；其他面板仍使用默认绑定。可按 `?` 查看当前面板命令。两个 gh 命令只查看现有资源并打开浏览器，不创建 PR；实际调用会访问 GitHub，认证沿用用户本机 gh 状态，不纳管凭据。

## 部署与验证范围

本次仅编辑仓库，未覆盖本机配置。首次部署请先检查差异：

```sh
mkdir -p ~/.config/lazygit
chezmoi diff ~/.config/lazygit/config.yml
chezmoi apply ~/.config/lazygit/config.yml
```

这组命令仅部署 Lazygit 配置，不运行 Homebrew 安装脚本；若 delta 配置尚未部署，另行预览并部署 `~/.config/delta/config`。部署后仍需使用上文显式路径或环境变量启动。

已在临时 HOME 和无远程的临时 Git 仓库中实际启动 Lazygit TUI 并正常退出。
通过临时的 `code` 记录程序触发 Files 面板的 `O`，确认包含空格、单引号和 shell
命令片段的文件名仍作为单个参数传递，且 `--` 分隔符存在，没有执行文件名中的命令。
验证没有调用真实 VS Code、gh、PR 或远程仓库，未覆盖本机配置。
