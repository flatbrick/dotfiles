# 命令行工具配置

[返回 README](../../README.md)

## 来源与范围

以下三份配置原样引入自 [signalridge/dotfiles](https://github.com/signalridge/dotfiles)，当前已对齐参考版本 [`a978087`](https://github.com/signalridge/dotfiles/commit/a978087)，不自动同步上游。首次基线为 `b1c0ea4`，两版间这三份配置没有变化。Brewfile 已包含这些软件，本次不增加安装项。

| 仓库文件 | 部署目标 | 设置 |
|---|---|---|
| `home/private_dot_config/bat/config` | `~/.config/bat/config` | Dracula、行号与 Git 修改标识、语法映射、折行 |
| `home/private_dot_config/btop/btop.conf` | `~/.config/btop/btop.conf` | Dracula、1000 毫秒刷新 |
| `home/private_dot_config/gh/private_config.yml` | `~/.config/gh/config.yml` | HTTPS、交互提示、`gh co` 检出 PR |

基线文件：[bat](https://github.com/signalridge/dotfiles/blob/a978087/private_dot_config/bat/config)、[btop](https://github.com/signalridge/dotfiles/blob/a978087/private_dot_config/btop/btop.conf)、[gh](https://github.com/signalridge/dotfiles/blob/a978087/private_dot_config/gh/private_config.yml)。

gh 仅纳管偏好文件，目标权限为 0600。不引入 `hosts.yml`、账号选择、登录令牌或凭据，不执行登录。编辑器和 pager 保留参考配置中的空值，使用工具自身的环境回退逻辑。

## 部署

本次没有覆盖真实本机配置。首次部署先预览差异，确认是否替换已有偏好：

```sh
mkdir -p ~/.config/bat ~/.config/btop ~/.config/gh
chezmoi diff ~/.config/bat/config ~/.config/btop/btop.conf ~/.config/gh/config.yml
chezmoi apply ~/.config/bat/config ~/.config/btop/btop.conf ~/.config/gh/config.yml
```

仅部署这些目标不会触发 Homebrew 生命周期脚本，也不会接管 gh 的认证文件。
完整 apply 同样会部署这些配置。

## 验证范围

已在临时 HOME 中部署三份配置，核对与参考文件逐字节一致；使用实际 bat 展示样例文件，使用 gh 读取 HTTPS 配置与 PR 检出别名；启动实际 btop 终端界面并正常退出。本机 Homebrew 提供 `dracula.theme`。

没有访问远程仓库、登录账号或操作 PR，也未覆盖真实本机配置。
