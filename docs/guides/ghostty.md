# Ghostty 配置

[返回 README](../../README.md)

## 配置来源与范围

`home/private_dot_config/ghostty/config` 最初导入自本机 `~/.config/ghostty/config`，
随后将仓库版本恢复为下述参考指南中的 Ghostty 配置，作为后续调整的基线。
当前配置包含 macOS 专用选项，通过 `home/.chezmoiignore` 在非 macOS 系统排除。

参考来源：[lltx 的现代化终端配置指南](https://gist.github.com/lltx/a61f98fdb761c9af7c5fd6cbfe963842)
中的 Ghostty 部分，以此为基线将主题从 `Kanagawa Wave` 调整为 `Dracula`，
与已纳管的 delta、bat、btop 配色保持一致。其余设置保持参考配置，包括
`ssh-terminfo` Shell integration，可在适用的 SSH 调用中自动向远端安装终端能力描述。

这里只引入 Ghostty 配置，不表示已引入指南中的 Yazi、Zoxide 或 Oh-My-Zsh 配置，
也不自动同步 Gist 后续更新。修改仓库文件不自动重载当前终端。

本机另有 `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty`，
导入时为空，因此不纳管、不删除。后续若在该处增加设置，需注意它可能与纳管配置叠加；
建议统一在仓库内维护配置，不另建第二份设置来源。

## 依赖与现有设置

Brewfile 已包含 `ghostty` 和 `font-maple-mono-nf-cn`，不重复增加安装项。
当前使用 Maple Mono NF CN、15 号字体及 Ghostty 自带 Dracula 主题，无需额外下载主题。

主要操作：

| 操作 | 当前快捷键 |
|---|---|
| 新建标签页 | `Cmd+T` |
| 向右／向下分屏 | `Cmd+D`／`Cmd+Shift+D` |
| 快速终端 | `Ctrl+反引号`（全局） |
| 重载配置 | `Cmd+Shift+逗号` |

全局快捷键需要 Ghostty 正常运行及系统允许相应功能；配置纳管不代替系统权限授权。

## 修改与部署

优先编辑仓库中的 `home/private_dot_config/ghostty/config`。完整 `chezmoi apply`
会同步它，也可仅部署此文件，避免触发软件安装脚本：

```sh
mkdir -p ~/.config/ghostty
chezmoi diff ~/.config/ghostty/config
chezmoi apply ~/.config/ghostty/config
```

若先修改了本机文件，可用 `chezmoi add ~/.config/ghostty/config` 更新仓库来源。
部署后按配置中的重载快捷键；部分选项可能需要新建窗口或重启 Ghostty 才能体现。

macOS 可使用安装包自带的命令校验：

```sh
/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config
```

首次纳管已通过实际 Ghostty 配置校验、字体可用性检查和临时目标部署，
导入文件与原文件逐字节一致。没有重启终端或修改本机权限授权。
