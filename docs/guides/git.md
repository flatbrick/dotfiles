# Git 配置

[返回 README](../../README.md)

## 配置位置

`~/.gitconfig` 仅保留说明，全部 Git 设置位于 `~/.config/git/config`。

| 仓库文件 | 部署目标 | 用途 |
|---|---|---|
| `dot_gitconfig` | `~/.gitconfig` | 配置位置说明 |
| `private_dot_config/git/config.tmpl` | `~/.config/git/config` | 身份、别名、工具与 Git 行为 |
| `private_dot_config/git/ignore` | `~/.config/git/ignore` | 全局忽略规则 |
| `private_dot_config/git/message` | `~/.config/git/message` | 提交消息模板 |

## 身份数据

身份由 `.chezmoidata.yaml` 中的 `gitUsername`、`gitEmail` 提供。
修改身份应编辑该数据文件，不使用初始化模板中的 `name`、`email`。
本机 chezmoi 配置中的同名数据优先级更高，应避免重复定义。
仓库级 Git 身份设置仍可覆盖全局身份；修改身份不会自动改变已有提交。

## 修改与部署

修改仓库中的对应文件后，仅部署 Git 配置：

```sh
chezmoi apply ~/.gitconfig ~/.config/git/config ~/.config/git/ignore ~/.config/git/message
git whoami
```

查看部署差异：

```sh
chezmoi diff ~/.gitconfig ~/.config/git/config ~/.config/git/ignore ~/.config/git/message
```

不要通过 `git config --global` 持久维护身份：它可能向 `~/.gitconfig` 写入覆盖值，
且后续 apply 会恢复仓库版本。其他设置直接修改 `private_dot_config/git/config.tmpl`。

## 工具依赖与认证

| 命令 | Homebrew 包名 | 用途 |
|---|---|---|
| `git-lfs` | `git-lfs` | Git LFS 文件过滤器 |
| `nvim` | `neovim` | 提交等操作使用的编辑器 |
| `delta` | `git-delta` | 差异展示与交互式差异过滤 |
| `difft` | `difftastic` | 结构化差异比较 |
| `gh` | `gh` | GitHub HTTPS 凭据 helper |
| `lazygit` | `lazygit` | 可选的 `git ui` 别名 |

当前工作机上的这些工具均由 Homebrew 安装，已纳管的 Brewfile 包含上述全部工具。
仓库不自动安装软件，也未纳管 `~/.config/delta/config`。
清单的维护见 [Homebrew](homebrew.md)。

GitHub HTTPS 认证使用 `gh auth git-credential` helper，这是 `gh` 自带的子命令。
本仓库不纳管登录令牌或凭据，部署 Git 配置不等于完成 GitHub 登录。
