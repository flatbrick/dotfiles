# dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理个人配置。

## 仓库结构

```text
.
├── .chezmoiroot                    # 指定 home/ 为部署源
├── .chezmoiversion                 # 最低 chezmoi 版本
├── .gitignore                      # Git 忽略规则
├── .github/workflows/
│   └── ci.yaml                     # CI 工作流
├── README.md
├── install.sh                      # 安装 chezmoi 并部署配置
├── scripts/                        # 仓库脚本，不部署
│   └── readme-tree.sh
├── docs/                           # 仓库文档，不部署
│   ├── guides/
│   │   ├── aerospace.md
│   │   ├── cli-tools.md
│   │   ├── ghostty.md
│   │   ├── git.md
│   │   ├── herdr.md
│   │   ├── homebrew.md
│   │   ├── karabiner.md
│   │   ├── lazygit.md
│   │   ├── mise.md
│   │   └── yazi.md
│   └── references/
│       ├── chezmoi-layouts.md
│       └── signalridge-dotfiles.md
└── home/                           # chezmoi 部署源，按目标路径组织
    ├── .chezmoi.toml.tmpl          # 本机选项、编辑器与差异展示
    ├── .chezmoidata/
    │   ├── aerospace.yaml          # AeroSpace 浮动应用清单
    │   └── git.yaml                # 默认 Git 身份数据
    ├── .chezmoiignore              # 平台筛选与部署源内的杂项排除
    ├── .chezmoiremove              # apply 时删除的旧目标
    ├── .chezmoiscripts/
    │   ├── run_once_before_00_homebrew.sh.tmpl
    │   └── run_onchange_after_10_brew-bundle.sh.tmpl
    ├── dot_gitconfig               # 仅含说明的 ~/.gitconfig
    ├── dot_local/bin/
    │   └── executable_git-identity # 本机 Git 身份管理命令
    └── private_dot_config/
        ├── aerospace/
        │   └── aerospace.toml.tmpl
        ├── bat/
        │   └── config
        ├── btop/
        │   └── btop.conf
        ├── delta/
        │   └── config              # Git 与 chezmoi 共用的 delta 配置
        ├── gh/
        │   └── private_config.yml
        ├── ghostty/
        │   └── config              # Ghostty 终端配置
        ├── git/
        │   ├── config.tmpl         # Git 身份与设置
        │   ├── ignore
        │   └── message
        ├── herdr/
        │   └── config.toml
        ├── homebrew/
        │   └── Brewfile            # Homebrew 安装清单
        ├── lazygit/
        │   └── config.yml
        ├── mise/
        │   └── config.toml.tmpl
        ├── private_karabiner/
        │   └── private_karabiner.json
        └── yazi/
            ├── yazi.toml
            ├── keymap.toml
            └── theme.toml
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
