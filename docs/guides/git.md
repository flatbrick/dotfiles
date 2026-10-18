# Git 配置

[返回 README](../../README.md)

## 配置位置

`~/.gitconfig` 仅保留说明，全部 Git 设置位于 `~/.config/git/config`。

| 仓库文件 | 部署目标 | 用途 |
|---|---|---|
| `home/dot_gitconfig` | `~/.gitconfig` | 配置位置说明 |
| `home/private_dot_config/git/config.tmpl` | `~/.config/git/config` | 身份、别名、工具与 Git 行为 |
| `home/private_dot_config/git/ignore` | `~/.config/git/ignore` | 全局忽略规则 |
| `home/private_dot_config/git/message` | `~/.config/git/message` | 提交消息模板 |
| `home/private_dot_config/delta/config` | `~/.config/delta/config` | Git 与 chezmoi 共用的差异展示样式 |

## 身份数据

默认身份（所有仓库）由仓库内 `home/.chezmoidata/git.yaml` 提供：

| 键 | 当前值 |
|---|---|
| `gitUsername` | `flatbrick` |
| `gitEmail` | `8930612@qq.com` |

其他身份按目录切换，数量不限，全部只存在于本机，不进入仓库，也不由 chezmoi 管理。
工具源文件为 `home/dot_local/bin/executable_git-identity`，由 chezmoi 部署为
`~/.local/bin/git-identity`，不随 apply 自动执行。仅部署工具：

```sh
mkdir -p ~/.local/bin
chezmoi apply ~/.local/bin/git-identity
```

确保 `~/.local/bin` 位于 `PATH` 后，使用 `git-identity` 维护：

```sh
git-identity add ~/work "Work User" work@example.com
git-identity add ~/clients/acme "Acme Dev" dev@acme.example
git-identity list
git-identity remove ~/clients/acme
```

脚本在本机维护三个文件：

| 路径 | 作用 |
|---|---|
| `~/.config/git/identities.map` | 目录与标识的对应关系 |
| `~/.config/git/identities/<标识>.config` | 该目录使用的 `[user]` |
| `~/.config/git/identities.config` | 由脚本重新生成的 `includeIf` 列表 |

仓库部署的全局配置固定包含：

```ini
[include]
	path = ~/.config/git/identities.config
```

该文件不存在时 Git 忽略这条 include，因此新机器未配置任何身份也能正常工作。
已在临时 HOME 的规范、互不嵌套目录中验证添加、列出、刷新、删除及默认身份回退；
重复部署工具不会覆盖这些本机身份文件。
全局配置由 chezmoi 管理，`identities.*` 不会出现在 `chezmoi managed` 中。
换电脑或重装后需重新运行 `add`，仓库中不保留任何工作身份信息。
旧的 `~/.config/git/work.config` 不再由本仓库生成，也不自动删除；
如本机仍有该文件，应先确认身份数据和引用已迁移，再自行决定是否清理。

注意：脚本不自动规范化输入路径，建议使用仓库所在目录的真实、规范路径。
仓库级身份设置可覆盖以上所有身份；修改身份不会改变已有提交。

当前限制：本次仅迁移命令入口，未修改匹配逻辑。
路径生成的标识仍可能碰撞；嵌套目录优先级取决于条目顺序；
非默认 `XDG_CONFIG_HOME` 与固定 include 路径不一致。
不要依赖存在这些情况的身份规则；目录应使用规范的真实路径，符号链接路径可能不匹配。

## 修改与部署

修改仓库中的对应文件后，仅部署 Git 配置：

```sh
chezmoi apply ~/.gitconfig ~/.config/git/config ~/.config/git/ignore ~/.config/git/message
git whoami
git -C ~/work/example config user.email
```

查看部署差异：

```sh
chezmoi diff ~/.gitconfig ~/.config/git/config ~/.config/git/ignore ~/.config/git/message
```

不要通过 `git config --global` 持久维护身份：它可能向 `~/.gitconfig` 写入覆盖值，
且后续 apply 会恢复仓库版本。其他设置直接修改 `home/private_dot_config/git/config.tmpl`。

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
完整 apply 会通过 Homebrew 管线安装清单中的软件。
`~/.config/delta/config` 已纳管，使用参考项目的 Dracula 暗色配置；
Git 与 chezmoi 共用它，编辑后可单独执行 `chezmoi apply ~/.config/delta/config`。
清单的维护见 [Homebrew](homebrew.md)。

GitHub HTTPS 认证使用 `gh auth git-credential` helper，这是 `gh` 自带的子命令。
本仓库不纳管登录令牌或凭据，部署 Git 配置不等于完成 GitHub 登录。
