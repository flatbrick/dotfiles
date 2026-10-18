# Karabiner-Elements 配置

[返回 README](../../README.md)

## 来源与纳管范围

`home/private_dot_config/private_karabiner/private_karabiner.json` 精确导入自用户本机
`~/.config/karabiner/karabiner.json`，不是用 signalridge-dotfiles 版本替换。
只纳管这个主配置文件，不导入 `automatic_backups/`、`assets/` 或其他运行状态。
已有复杂规则完整嵌入主配置，不另行复制规则资源目录。
本配置仅适用于 macOS，非 macOS 由 `home/.chezmoiignore` 排除。

保留完整 `Default profile`、其选中状态、ANSI 虚拟键盘设置及用户规则：

- Caps Lock 映射为左 Ctrl；左 Ctrl 单独按下发送 Escape。
- SpaceFN：Space 配合 I/J/K/L 发送上/左/下/右。
- SpaceFN：Space 配合数字 1–0、连字符、等号发送 F1–F12。
- 完整 SpaceFN 激活及最后一次输入后退出规则，包含原有延迟动作和变量处理。

导入前检查了命令、身份邮箱、用户绝对路径和常见凭据字段，没有发现需阻止原样纳管的
账号 token 或工作身份。配置确实包含 `shell_command`：等待 0.2 秒后读取
`/library/application support/org.pqrs/tmp/karabiner_grabber_manipulator_environment.json`，
条件满足时调用 `/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli`
重置 `_spacefn_mode`。这是本机既有 SpaceFN 行为，不是安装脚本，未执行或改写。
特别保留原命令中小写 `/library` 的拼写；其在区分大小写文件系统上的可用性不能据此保证。
目标机器必须具备相应 Karabiner 路径及运行环境，不能将这些 shell 动作视为纯静态按键替换。

## 权限与部署

本机 Karabiner 目录为 `0700`、主配置为 `0600`，chezmoi 因而使用目录和文件的
`private_` 属性；目标仍是普通路径 `~/.config/karabiner/karabiner.json`。
不要手动去掉源路径的属性前缀。`private_dot_config` 沿用仓库的 `.config` 管理约定。

直接编辑上述仓库文件，部署前查看差异；只部署主文件以避免触发全仓库安装脚本：

```sh
chezmoi diff ~/.config/karabiner/karabiner.json
chezmoi apply ~/.config/karabiner/karabiner.json
```

若通过 Karabiner 设置界面修改本机配置，应再用
`chezmoi add ~/.config/karabiner/karabiner.json` 纳管最新版本。
主配置可能被运行中的 Karabiner 重新读取或改写；请自行选择部署时机，避免与界面编辑并发。
输入监控、辅助功能及驱动等权限由用户根据 macOS 提示授权，本仓库不自动授予权限。

## 检查边界

导入内容与本机文件逐字节一致，通过 JSON 解析及临时目标部署比对；
主配置和目录分别保持 0600、0700 权限。
本机 Karabiner 为 `16.1.0`。将五条内嵌复杂规则提取到临时规则文件，
实际执行 `karabiner_cli --lint-complex-modifications`，结果为 `ok`。
这不等于完整键盘行为测试；没有运行格式化、GUI、切换 profile、设置变量、
实际按键测试或改变本机权限。
