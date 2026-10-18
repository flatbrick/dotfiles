# mise 全局配置

[返回 README](../../README.md)

## 来源与边界

`home/private_dot_config/mise/config.toml.tmpl` 原样引入自
[signalridge/dotfiles](https://github.com/signalridge/dotfiles) 提交
`a978087ba7393d87f5264f2c06562adbb70b71ad` 的
`private_dot_config/mise/config.toml.tmpl`，保留全部工具、版本、设置和参考注释，
不按本机已安装工具精简，也不自动跟踪上游更新。

模板只读取 chezmoi 内置变量 `.chezmoi.os`：仅在 `darwin` 输出 mac-cleanup 声明，
无需新增 `.chezmoidata` 或机器身份数据。仓库保存的是模板，目标是 `~/.config/mise/config.toml`。
本仓库通过 Homebrew 管理 mise 可执行程序；上游注释中的 nix、MCP wrappers、
`social-post`、`dsh-with`、CLIProxyAPI、agent 配置和 skills 路径描述上游环境，
不表示这些配套程序、认证或配置已在本仓库中部署。这里不复制账号、token 或工作身份。

本次只纳管配置声明，不引入上游自动 `mise install` 脚本，不安装、升级或卸载当前机器任何工具，
不修改真实 home 的 mise 配置，也不新增 shell activation。

## 完整工具声明

| 工具／后端标识 | 保留的版本及选项 |
|---|---|
| `node` | `lts`，不是 Node Current；上游注释中的具体 LTS 版本是参考提交时的说明，不是固定版本 |
| `bun`、`terraform`、`uv`、`go`、`rust` | 各为 `latest` |
| `python` | `3.14`，固定主次版本线 |
| `lua` | `5.4` |
| `pipx:git+https://github.com/signalridge/ai-research-skills.git` | `latest`，`uvx = "true"` |
| `pipx:poetry`、`pipx:pre-commit`、`pipx:posting` | 各为 `latest` |
| `pipx:mac-cleanup` | 仅 macOS，`latest`，`uvx_args = "--python 3.13"` |
| `go:github.com/xdevplatform/xurl` | `1.3.1` |
| `npm:@humanwhocodes/crosspost` | `1.0.4` |
| `npm:@earendil-works/pi-coding-agent` | `latest` |
| `npm:@deepseek-ai/dsh` | `0.2.0-rc.2`，保留上游预览版固定版本 |
| `npm:ccusage`、`npm:@ccusage/codex` | 各为 `latest` |
| `npm:agent-browser`、`npm:hyperframes`、`npm:impeccable` | 各为 `latest` |

Python 3.14 与 mac-cleanup 的独立 Python 3.13 环境必须区分：上游注明 mac-cleanup 3.3.0
要求 Python <3.14，因此显式让其虚拟环境使用 3.13，不能简单把所有 pipx 工具统一到 3.14。
日后更换全局 Python 版本线可能重建其他 pipx 工具环境。

## 设置、依赖与风险

- npm 后端统一使用 Bun 安装，Node 仍须在 PATH 中以运行 `#!/usr/bin/env node` 的 CLI；
  Bun 不能替代 Node 运行时。pipx 后端使用 uv/uvx，Go 后端依赖 Go 工具链。
- Bun 默认跳过生命周期脚本。上游特别指出 hyperframes 的 `onnxruntime-node` 原生库可能缺失，
  影响配音、转录、背景移除等功能；仍原样保留声明，不主动加入 `--trust` 或运行 postinstall。
- hyperframes 还需要 ffmpeg；上游注释说由 nix profile 提供，本仓库没有因导入该模板而采用 nix。
  使用该功能前需自行确认 `ffmpeg` 可用。浏览器渲染可能需要 Chrome for Testing 并触发下载；
  agent-browser 的浏览器安装和 hyperframes 的 skills 安装都不在本次纳管范围内。
- impeccable 仅声明 CLI，不自动全局部署 skill；参考注释建议按项目安装，不同时引入另一套 skill 来源。
- xurl、crosspost 的声明不提供任何发布授权。上游的 `social-post` 确认包装器并未随模板引入，
  不应把裸 CLI 当作带确认门的发布流程。dsh 的 OAuth/CLIProxyAPI 配套也不在本次范围。
- 保留 `auto_install = true`：**没有安装脚本不等于部署后永远不会自动安装**。
  后续启用 mise、调用相关工作流时仍可能安装缺失工具；部署前应明确接受这一上游行为。
- 保留 idiomatic version files、experimental，以及信任目录 `~/Projects`、`~/Work`。
  这些目录中的配置被赋予信任，进入不可信项目以前需审阅配置，勿把“来源目录可信”视为代码安全证明。
- 保留 `always_keep_download = false`、`always_keep_install = false`，不强制保留所有下载及安装副本。
- 环境路径保持 `./node_modules/.bin`、`./bin`；项目本地可执行文件可能优先于系统工具，应注意目录内容。
- `latest` 和 `lts` 是动态选择器，并非锁定可重现版本；实际安装版本取决于未来安装时的上游状态。
  Homebrew 与 mise 可能提供同名工具，PATH 决定实际使用者；本次不卸载或迁移已有安装。

## 修改与部署

优先修改仓库模板；若希望保持当前参考基线，更新时应明确选定新的参考提交并审阅完整差异。
以下操作仅供用户决定部署时执行，不代表本次已执行，也不会由本次新增脚本自动触发：

```sh
chezmoi diff ~/.config/mise/config.toml
chezmoi apply ~/.config/mise/config.toml
```

只部署这个文件，不执行全仓库 apply、`mise install`、`mise up`、`mise use`、bootstrap 或依赖安装。
不要为检查配置而执行工具、shell activation 或会获取远程版本的查询。

## 本地只读解析

模板须先渲染，不能直接当 TOML 解析。可从仓库根目录把渲染结果写到临时文件，
再用本机帮助中提供的 `config get --file` 读取，而不替换真实 home 配置：

```sh
rendered="$(mktemp -t mise-config)"
chezmoi execute-template < home/private_dot_config/mise/config.toml.tmpl > "$rendered"
MISE_AUTO_INSTALL=0 MISE_OFFLINE=1 mise config get --file "$rendered"
```

检查结束后自行删除该临时文件。`config get` 只读配置，不能证明工具已安装或能够运行。
如需查看现有安装诊断，本机 `mise doctor --help` 提供 `mise doctor` 和 `mise doctor path`；
在禁止网络、安装和升级的场景下优先使用上述显式文件解析，不把 doctor 当成网络或安装验证入口。
已验证源模板与参考版本逐字节一致，macOS/Linux 渲染结果均能作为 TOML 解析；
macOS 包含独立 Python 3.13 的 mac-cleanup 声明，Linux 排除它。
临时 HOME 中使用 `MISE_AUTO_INSTALL=0 MISE_OFFLINE=1 mise config get --file`
成功读取 macOS 渲染配置。未执行 doctor、安装、升级或联网版本校验，
不将声明中的工具视为已经安装或验证可运行。
