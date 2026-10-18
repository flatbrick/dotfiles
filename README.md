# dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理个人配置。

## 仓库结构

以下按当前实际源文件展示配置来源与关键入口，不完整展开每个目录。
各软件的配置文件、部署目标及维护方法见「使用与维护」中的指南。

```text
.
├── .chezmoiroot            # 指定 home/ 为部署源
├── .chezmoiversion         # 最低 chezmoi 版本
├── .gitignore              # 仓库文件的 Git 忽略规则
├── .github/workflows/      # CI 与 README 结构树检查
├── install.sh              # 获取 chezmoi 并进入初始化、部署流程
├── scripts/                # 仓库维护工具（README 结构树对齐）
├── docs/                   # 仓库文档，不部署到主目录
│   ├── guides/             # 各软件的配置、部署与使用指南
│   └── references/         # 外部参考项目、调研与采用范围
└── home/                   # chezmoi 部署源，按目标路径组织
    ├── .chezmoi.toml.tmpl  # 初始化提问、本机数据与 chezmoi 工具设置
    ├── .chezmoidata/
    │   ├── aerospace.yaml  # AeroSpace 浮动应用清单
    │   └── git.yaml        # 默认 Git 身份数据
    ├── .chezmoiignore      # 平台筛选与部署源内的杂项排除
    ├── .chezmoiscripts/    # Homebrew 安装与 Brewfile 应用管线
    ├── dot_gitconfig       # ~/.gitconfig 占位，主配置在 ~/.config/git/
    ├── dot_local/bin/      # 部署到 ~/.local/bin 的本机 Git 身份工具
    └── private_dot_config/ # Git、终端、桌面、CLI 与工具安装清单
```

仓库根目录放安装入口、文档、CI 和维护工具；`home/` 只放部署源。
`.chezmoiroot` 的内容为 `home`，外层文件不会因新增而自动部署到主目录。
源文件移入 `home/` 不改变部署目标，例如 `home/private_dot_config/git/config.tmpl`
仍部署到 `~/.config/git/config`。

结构树中的路径与注释由 `scripts/readme-tree.sh` 统一对齐，不要手工补空格。
增删条目后执行：

```sh
./scripts/readme-tree.sh
```

CI 以 `--check` 校验，未对齐时失败。

## 使用与维护

从仓库根目录初始化本机 chezmoi 配置（不部署文件、不安装软件）：

```sh
chezmoi init --source="$(pwd)" --apply=false
```

首次在终端中询问 hostname；macOS 还询问是否安装 Mac App Store 应用。
已有答案会保留，无终端时使用系统主机名、默认不安装商店应用。
hostname 仅作为模板数据保存，不修改系统主机名。
chezmoi 使用 `code --wait` 编辑配置，差异展示与 Git 共用 `~/.config/delta/config`。
Git 提交编辑器仍为 `nvim`，不受此设置影响。
初始化模板将仓库根路径保存为 `sourceDir`；后续普通 `chezmoi` 命令会通过
`.chezmoiroot` 自动定位 `home/`，无需重复指定 `--source`。

| 文档 | 内容 |
|---|---|
| [命令行工具配置](docs/guides/cli-tools.md) | bat、btop、gh 的偏好与部署 |
| [Ghostty 配置](docs/guides/ghostty.md) | 配置部署、字体主题与重载 |
| [Git 配置](docs/guides/git.md) | 身份数据、配置部署、工具依赖与认证 |
| [Homebrew 安装清单](docs/guides/homebrew.md) | 已纳管清单的部署、审阅与手动安装 |
| [Lazygit 配置](docs/guides/lazygit.md) | 差异工具、界面与命令安全边界 |
| [Yazi 配置](docs/guides/yazi.md) | 文件浏览、打开方式与快捷键 |
| [Herdr 配置](docs/guides/herdr.md) | 参考版界面、按键和配置所有权 |
| [AeroSpace 配置](docs/guides/aerospace.md) | 本机浮动应用、工作区与显示器布局 |
| [Karabiner 配置](docs/guides/karabiner.md) | 用户 SpaceFN 与键位映射 |
| [mise 配置](docs/guides/mise.md) | 最新参考工具声明与安装边界 |

后续软件的配置说明按主题放在 `docs/guides/`，在此添加入口；外部参考项目及分析放在 `docs/references/`。

## 参考项目

目录设计参考 [twpayne/dotfiles](https://github.com/twpayne/dotfiles)、
[felipecrs/dotfiles](https://github.com/felipecrs/dotfiles) 与
[dngray/dotfiles](https://github.com/dngray/dotfiles) 的 `home/` 分层；
配置组织与部分文件参考 [signalridge/dotfiles](https://github.com/signalridge/dotfiles)。
均为按需借鉴，不整体部署参考项目。

以下配置已核对并对齐 signalridge 的 [`a978087`](https://github.com/signalridge/dotfiles/commit/a978087) 版本：

- `home/dot_gitconfig`
- `home/private_dot_config/git/config.tmpl`
- `home/private_dot_config/git/ignore`
- `home/private_dot_config/git/message`
- `home/private_dot_config/delta/config`
- `home/private_dot_config/bat/config`
- `home/private_dot_config/btop/btop.conf`
- `home/private_dot_config/gh/private_config.yml`

从首次引入基线 `b1c0ea4` 到 `a978087`，上述上游配置没有变化，无需重写文件。
除 Git 配置保留本仓库的目录身份 include 外，其余七份文件与最新基线一致。

Lazygit 和 Yazi 同样基于 `a978087`，但按本机版本、依赖和安全边界筛选适配，
不属于上述原样对齐的八份文件。来源与具体差异分别见
[Lazygit 指南](docs/guides/lazygit.md)和 [Yazi 指南](docs/guides/yazi.md)。

Herdr 的 `config.toml` 与 mise 的 `config.toml.tmpl` 另按 `a978087` 原样引入。
AeroSpace 使用参考模板配合本机应用数据清单；Karabiner 使用用户自己的完整配置。
不引入 AeroSpace 的整机 work/private 分类。tmux 暂不纳管。
本次只接管配置文件，不引入参考仓库的运行状态、日志、自动 mise 安装或升级脚本。

Git 文件引入时保持原样，后续增加了本机身份文件入口；默认身份数据由
`home/.chezmoidata/git.yaml` 单独提供。delta 配置按参考版本引入。
初始化模板借鉴了已有值优先、终端提问和 `installMasApps` 开关的设计。
Homebrew 安装管线由本仓库实现；不引入参考项目的 Nix 或密钥管理体系，也不自动同步上游更新。

Ghostty 配置参考 [lltx 的现代化终端配置指南](https://gist.github.com/lltx/a61f98fdb761c9af7c5fd6cbfe963842)
中的 Ghostty 部分；本机调整与纳管范围见 [Ghostty 配置](docs/guides/ghostty.md)。

完整项目对比、目录职责、采用与未采用范围见
[目录结构调研](docs/references/chezmoi-layouts.md)；
signalridge 的能力与风险分析见[专题报告](docs/references/signalridge-dotfiles.md)。
