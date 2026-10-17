# Homebrew 安装清单

[返回 README](../../README.md)

## 当前状态

已通过 `brew bundle dump` 按本机当前安装状态重新导出
`~/.config/homebrew/Brewfile`，并纳管到 `private_dot_config/homebrew/Brewfile`。
清单包含 tap、命令行软件、GUI 应用、Mac App Store 应用、VS Code 扩展，
以及 Homebrew Bundle 检测到的 Go、uv 和 npm 工具。

本机 `XDG_CONFIG_HOME=~/.config`，因此该文件也是 `brew bundle --global` 的默认清单。
`~/Brewfile` 和 `~/.homebrew/Brewfile` 中的其他清单未合并，也未删除。
为避免其他机器的环境变量影响路径，以下命令显式指定文件。

没有自动执行 `brew bundle install` 的部署脚本；chezmoi 只部署清单，不安装软件。
Homebrew 的 `trust.json` 等本机信任状态不纳入仓库。

Brewfile 声明需要安装的软件，不是精确版本锁文件；恢复时通常安装当时可用的版本。
软件的配置文件仍由 chezmoi 管理，安装清单不能替代配置文件或登录认证。

## 修改与部署

直接编辑仓库中的 `private_dot_config/homebrew/Brewfile`，然后部署：

```sh
chezmoi apply ~/.config/homebrew/Brewfile
chezmoi diff ~/.config/homebrew/Brewfile
```

如果直接修改了本机清单，使用 `chezmoi add ~/.config/homebrew/Brewfile` 同步回仓库，
否则下次 apply 会恢复仓库版本。

## 导出快照与审阅

在用于审阅的目录中执行：

```sh
brew bundle dump --file=./Brewfile
```

仅在确定要覆盖现有文件时追加 `--force`：

```sh
brew bundle dump --file=./Brewfile --force
```

导出的内容是本机已安装软件的快照。合入现有清单前应删除临时软件和不再需要的条目，
并检查是否包含不希望公开的应用、扩展或私有 tap 地址。
不要用本机的完整快照无条件覆盖已经人工维护的清单。

Git 相关工具的命令与 Homebrew 包名对应关系见 [Git 配置](git.md#工具依赖与认证)。

## 检查与安装

对部署后的清单手动执行：

```sh
brew bundle check --file="$HOME/.config/homebrew/Brewfile"
brew bundle install --file="$HOME/.config/homebrew/Brewfile"
```

`check` 检查清单中的依赖是否满足；`install` 会安装依赖，默认也会升级。
这些命令不会将 Brewfile 自动加入 chezmoi。

不要把 `brew bundle cleanup` 当作常规同步步骤：它会针对清单之外的软件进行清理，
尤其不能用只包含部分软件的清单清理整台机器。

## 后续维护约定

新增或移除软件时同步维护仓库内的 Brewfile，不通过完整导出覆盖人工维护的清单。
安装清单只记录软件依赖；各软件的配置、使用方式和认证边界分别写入
`docs/guides/<软件名>.md`，由 README 提供入口，避免重复维护相同说明。
