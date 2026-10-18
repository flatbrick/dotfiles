# Herdr 配置

[返回 README](../../README.md)

## 来源与纳管范围

`home/private_dot_config/herdr/config.toml` 原样引入自
[signalridge/dotfiles](https://github.com/signalridge/dotfiles) 提交
`a978087ba7393d87f5264f2c06562adbb70b71ad` 的
`private_dot_config/herdr/config.toml`，保留全部设置及注释，不自动跟踪参考仓库更新。

只纳管配置文件，不引入日志、session、插件目录、插件锁文件或参考仓库的插件安装脚本。
本次只新增仓库来源，没有部署到真实 home、重启 Herdr、安装插件或修改系统权限。
配置中的 tmux 对照是参考原文，不表示本仓库同时纳管 tmux。

参考文件中“version is pinned by aqua”以及“插件保持安装”等注释描述的是上游环境，
**不代表本仓库已采用 aqua 管理 Herdr 或已经安装这些插件**。
本仓库实际软件管理仍使用 Homebrew，Brewfile 已声明 `herdr`、`lazygit`；
升级应由统一的 Brew 工作流安排，不使用 `herdr update` 混用安装来源。

## 依赖与行为

- Dracula 主题，登录 shell，新 pane/tab 跟随当前工作目录；关闭 onboarding 和新 tab 命名提示。
- `Ctrl+B` 前缀，保留参考文件中 workspace、agent、pane 切换及所有插件快捷键。
- `prefix+alt+g` 需要 PATH 中存在 `lazygit`。
- `prefix+f`、`prefix+shift+f` 需要 `sessionizer` 插件；`prefix+u` 需要
  `rmarganti.herdr-pluck`；`prefix+alt+p`、`prefix+alt+a` 需要
  `cloudmanic.herdr-plus`。仅部署配置不会安装它们，插件缺失时对应快捷键不可用。
  参考文件最后提及的 `vim-herdr-navigation` 未绑定快捷键，本仓库也不负责安装它。
- 系统通知延迟 5 秒，复制通知和声音开启；claude、codex、pi 声音通知开启，droid 关闭。
  macOS 通知权限仍需用户自行授权；这里只保留配置，不自动授予权限。
- session 恢复时允许恢复 agent 对话；启用 Kitty graphics、嵌套运行及指定 agent 的 CJK IME 支持。
  图形显示还取决于终端能力，配置并不安装 agent 或终端。
- `remote.manage_ssh_config = true` 保留上游行为：使用远程功能时 Herdr 可以管理 SSH keepalive 配置。
  导入仓库不会执行该操作；实际使用远程功能前应审阅本机 SSH 配置。
- 每 pane 滚动缓冲上限 50,000,000 字节。没有启用 `pane_history`，避免主动持久化 pane 屏幕内容；
  这不表示 Herdr 日志、session 或 agent 自身状态不会包含敏感内容。

## 修改与部署

**Herdr 会写回自身配置**，例如界面主题选择器及 `herdr config reset-keys`。
下次 `chezmoi apply` 会以仓库版本覆盖这些变更。希望保留界面修改时，先审阅本机文件，
再用 `chezmoi add ~/.config/herdr/config.toml` 回收；不要导入整个 Herdr 状态目录。

以下为用户决定部署时的精确文件操作，不代表本次已经执行：

```sh
chezmoi diff ~/.config/herdr/config.toml
chezmoi apply ~/.config/herdr/config.toml
```

部署前关闭会写配置的界面操作，先备份有意保留的本机设置。
如需运行中生效，可由用户另行执行 `herdr server reload-config`；这会修改运行态，不属于只读校验。

## 本地只读检查

从仓库根目录指定来源文件，避免误读真实 home 配置：

```sh
HERDR_CONFIG_PATH="$PWD/home/private_dot_config/herdr/config.toml" herdr config check
```

本机 `herdr --help` 确认支持 `HERDR_CONFIG_PATH`，`herdr config check --help`
说明该命令校验配置并打印诊断。它不安装插件，也不能证明插件功能、通知授权或终端图形正常。
已在临时 HOME 中通过上述 `herdr config check`，输出 `config: ok`；
源文件与参考版本逐字节一致。没有启动或重载服务，也未安装或验证插件。
