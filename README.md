# dotfiles

使用 [chezmoi](https://www.chezmoi.io/) 管理个人配置。

## 仓库结构

```text
.
├── .chezmoi.yaml.tmpl     # chezmoi 初始化配置模板
├── .chezmoiignore         # 不部署到主目录的文件
├── .gitignore             # Git 忽略规则
├── .github/workflows/
│   └── ci.yaml            # CI 工作流
├── README.md
├── install.sh             # 安装入口
└── docs/                  # 仓库文档，不部署到主目录
    └── research/          # 项目调研记录
        └── signalridge-dotfiles.md
```
