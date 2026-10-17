# dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理个人配置。

## 仓库结构

```text
.
├── .chezmoi.yaml.tmpl # chezmoi 初始化配置模板
├── .chezmoidata.yaml  # Git 身份模板数据
├── .chezmoiignore     # 不部署到主目录的文件
├── .gitignore         # Git 忽略规则
├── .github/workflows/
│   └── ci.yaml        # CI 工作流
├── README.md
├── install.sh         # 安装入口
├── scripts/           # 仓库维护脚本，不部署
├── dot_gitconfig      # 仅含说明的 ~/.gitconfig
├── private_dot_config/git/
│   ├── config.tmpl    # Git 身份与设置 → ~/.config/git/config
│   ├── ignore         # 全局忽略规则
│   └── message        # 提交消息模板
├── private_dot_config/homebrew/
│   └── Brewfile       # Homebrew 安装清单
└── docs/              # 仓库文档，不部署到主目录
    ├── guides/        # 配置与维护指南
    │   ├── git.md
    │   └── homebrew.md
    └── references/    # 外部参考项目及分析
        └── signalridge-dotfiles.md
```

## 使用与维护

| 文档 | 内容 |
|---|---|
| [Git 配置](docs/guides/git.md) | 身份数据、配置部署、工具依赖与认证 |
| [Homebrew 安装清单](docs/guides/homebrew.md) | 已纳管清单的部署、审阅与手动安装 |

后续软件的配置说明按主题放在 `docs/guides/`，在此添加入口；外部参考项目及分析放在 `docs/references/`。

上方结构树的注释列由脚本统一对齐，不要手工补空格；增删条目后执行：

```sh
./scripts/readme-tree.sh
```

CI 会以 `--check` 校验，未对齐时失败。

## 参考项目

本仓库参考 [signalridge/dotfiles](https://github.com/signalridge/dotfiles) 的
chezmoi 配置组织方式，按需引入配置并逐步调整为个人使用，不整体部署参考项目。

当前引入范围为 Git 配置，以参考项目的 `b1c0ea4` 版本为基线：

- `dot_gitconfig`
- `private_dot_config/git/config.tmpl`
- `private_dot_config/git/ignore`
- `private_dot_config/git/message`

上述文件引入时保持原样；身份数据由本仓库的 `.chezmoidata.yaml` 单独提供。
参考项目的安装脚本、包管理配置和其他工具配置未随之引入，也不自动同步上游更新。

架构分析、使用风险与采用建议见 [调研报告](docs/references/signalridge-dotfiles.md)。
