# Homebrew 安装清单

[返回 README](../../README.md)

## 当前状态

已通过 `brew bundle dump` 按本机当前安装状态重新导出
`~/.config/homebrew/Brewfile`，并纳管到 `home/private_dot_config/homebrew/Brewfile`。
清单包含 tap、命令行软件、GUI 应用、Mac App Store 应用、VS Code 扩展，
以及 Homebrew Bundle 检测到的 Go、uv 和 npm 工具。

本机 `XDG_CONFIG_HOME=~/.config`，因此该文件也是 `brew bundle --global` 的默认清单。
`~/Brewfile` 和 `~/.homebrew/Brewfile` 中的其他清单未合并，也未删除。
为避免其他机器的环境变量影响路径，以下命令显式指定文件。

`home/.chezmoiscripts/run_onchange_after_10_brew-bundle.sh.tmpl` 会在 Brewfile 内容或
`installMasApps` 开关变化时执行 `brew bundle install --no-upgrade`。
脚本包含 Brewfile 的 sha256 和开关值，渲染内容未变且上次成功时跳过。
安装失败会中断 apply，不记为成功；处理授权或登录问题后，下一次 apply 会重试。
Homebrew 的 `trust.json` 等本机信任状态不纳入仓库。

Brewfile 声明需要安装的软件，不是精确版本锁文件；恢复时通常安装当时可用的版本。
软件的配置文件仍由 chezmoi 管理，安装清单不能替代配置文件或登录认证。

## 自动化管线

两件事都由 `home/.chezmoiscripts/` 在 apply 时完成，无需手动执行安装命令：

| 脚本 | 触发 | 作用 |
|---|---|---|
| `run_once_before_00_homebrew.sh.tmpl` | 首次 apply，仅 macOS | 缺失时用 `NONINTERACTIVE=1` 安装 Homebrew |
| `run_onchange_after_10_brew-bundle.sh.tmpl` | Brewfile 内容或商店安装开关变化 | `brew bundle install --no-upgrade` |

顺序由文件名保证：`before_00` 先于文件部署，`after_10` 在文件部署之后。
新机器执行 `sh install.sh` 会依次初始化 chezmoi、部署配置并按所选范围安装软件；
需要先满足下述授权与登录条件，不保证无人值守完成。

注意事项：

- Homebrew 安装器不接受交互，`sudo` 未缓存时会失败并中断 apply；
  首次安装前可先执行一次 `sudo -v`（非交互场景由 CI 自行提供 sudo）。
- 同一次 apply 中新装的 brew 可能还不在 `PATH`，第二个脚本会依次尝试
  `brew`、`/opt/homebrew/bin/brew`、`/usr/local/bin/brew`。
- cask 或其他安装项失败会返回非零状态；处理问题后重新执行 `chezmoi apply`。

## Mac App Store 安装选项

macOS 首次交互式 `chezmoi init` 询问 `installMasApps`，答案保存在本机
`~/.config/chezmoi/chezmoi.toml` 的 `[data]` 中，不写入仓库。
已有值优先；无终端且未配置时默认 `false`，避免未登录 Apple ID 时自动尝试安装。

- `false`：脚本从原始 Brewfile 提取 MAS 应用 ID，使用 Homebrew 的
  `HOMEBREW_BUNDLE_MAS_SKIP` 排除这些应用；其他类型照常安装。
- `true`：将 MAS 应用纳入安装范围，需要先完成 App Store 登录。

后续修改本机 `[data].installMasApps`，再执行完整 `chezmoi apply` 即可触发安装管线。
关闭开关不会卸载已有应用。Brewfile 仍保留完整导出快照，不因开关改变。
该选项只控制本仓库的安装脚本；手动执行 `brew bundle install` 不会读取 chezmoi 数据。

## 修改与部署

直接编辑仓库中的 `home/private_dot_config/homebrew/Brewfile`，然后执行完整 apply，
让清单同步并触发安装脚本：

```sh
chezmoi apply
```

只执行 `chezmoi apply ~/.config/homebrew/Brewfile` 只同步文件，不会运行
`run_onchange` 脚本，因此不会安装新加的软件。

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
日常无需手动执行，脚本已在 Brewfile 变化时自动运行；上面的命令用于排障或补装。

不要把 `brew bundle cleanup` 当作常规同步步骤：它会针对清单之外的软件进行清理，
尤其不能用只包含部分软件的清单清理整台机器。

## 后续维护约定

新增或移除软件时同步维护仓库内的 Brewfile，不通过完整导出覆盖人工维护的清单。
安装清单只记录软件依赖；各软件的配置、使用方式和认证边界分别写入
`docs/guides/<软件名>.md`，由 README 提供入口，避免重复维护相同说明。
