# dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理个人配置。

## 仓库结构

```text
.
├── .chezmoiroot
├── .chezmoiversion
├── .github/
│   └── workflows/
│       └── ci.yaml
├── .gitignore
├── README.md
├── docs/
│   ├── guides/
│   │   ├── git.md
│   │   └── homebrew.md
│   └── references/
│       └── signalridge-dotfiles.md
├── home/
│   ├── .chezmoi.toml.tmpl
│   ├── .chezmoidata/
│   │   └── git.yaml
│   ├── .chezmoiignore
│   ├── dot_gitconfig
│   └── private_dot_config/
│       ├── delta/
│       │   └── config
│       ├── git/
│       │   ├── config.tmpl
│       │   ├── ignore
│       │   └── message
│       └── homebrew/
│           └── Brewfile
├── install.sh
└── scripts/
    └── readme-tree.sh
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
| [Git 配置](docs/guides/git.md) | 身份数据、配置部署、工具依赖与认证 |
| [Homebrew 安装清单](docs/guides/homebrew.md) | 已纳管清单的部署、审阅与手动安装 |

后续软件的配置说明按主题放在 `docs/guides/`，在此添加入口；外部参考项目及分析放在 `docs/references/`。

## 参考项目

目录组织参考 [twpayne/dotfiles](https://github.com/twpayne/dotfiles)，
配置按需参考 [signalridge/dotfiles](https://github.com/signalridge/dotfiles) 的 `a978087` 版本；
采用范围以已纳管文件及对应指南为准，不整体部署参考仓库。
