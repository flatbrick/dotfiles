# Yazi 配置

[返回 README](../../README.md)

## 来源与纳管范围

基于 [signalridge/dotfiles](https://github.com/signalridge/dotfiles) 本地参考版本 [`a978087`](https://github.com/signalridge/dotfiles/commit/a978087) 的三份文件迁移，不自动同步上游：

| 仓库文件 | 部署目标 | 内容 |
|---|---|---|
| `home/private_dot_config/yazi/yazi.toml` | `~/.config/yazi/yazi.toml` | 自然排序、目录优先、显示隐藏文件与符号链接、大小行模式、图片预览、打开方式 |
| `home/private_dot_config/yazi/keymap.toml` | `~/.config/yazi/keymap.toml` | 快速导航、编辑器选择、shell、模糊查找、重命名与路径复制 |
| `home/private_dot_config/yazi/theme.toml` | `~/.config/yazi/theme.toml` | Dracula 配色与文件类型颜色 |

参考原文：[yazi.toml](https://github.com/signalridge/dotfiles/blob/a978087/private_dot_config/yazi/yazi.toml)、[keymap.toml](https://github.com/signalridge/dotfiles/blob/a978087/private_dot_config/yazi/keymap.toml)、[theme.toml](https://github.com/signalridge/dotfiles/blob/a978087/private_dot_config/yazi/theme.toml)。

迁移前只读检查了本机对应三文件，未发现账号、凭据或工作身份字段；没有复制本机的工作目录导航、Git fetcher 或其他本机偏好。只纳管这三份静态配置，不纳管 `init.lua`、插件、缓存、状态或历史。本次不覆盖真实本机配置、不安装软件、不运行插件安装命令。

## 版本兼容与偏离参考的地方

本机 `yazi --version` 返回 **26.8.15（Homebrew，aarch64-apple-darwin）**。配置对照该版本的 [主配置预设](https://github.com/sxyazi/yazi/blob/v26.8.15/yazi-config/preset/yazi-default.toml)、[快捷键预设](https://github.com/sxyazi/yazi/blob/v26.8.15/yazi-config/preset/keymap-default.toml)、[暗色主题预设](https://github.com/sxyazi/yazi/blob/v26.8.15/yazi-config/preset/theme-dark.toml) 及随安装附带的 changelog 迁移，而非依赖旧字段仍被兼容。

- 快捷键的 `[manager]` 改成 `[mgr]`；主配置和主题继续使用 `[mgr]`。打开规则及文件类型规则使用当前的 `url`，不是旧 `name`。
- 保留自然排序、目录优先、隐藏文件、符号链接、大小行模式，以及 1000×1000 像素、Lanczos3、质量 90 的图片预览。纠正参考将图片尺寸写成文件字节上限的注释；删除已移除的 `sixel_fraction` 和绑定作者 WezTerm/Überzug++ 的注释。实际图片协议由 Yazi 与终端协商；不支持图形协议的终端不会因此获得图片显示能力。
- 编辑器固定使用 `nvim -- %s`，`block = true`，不再跟随 `EDITOR`。`--` 分隔选项与文件路径；`%s` 由当前 Yazi 对每个所选文件分别进行 shell 转义，不要额外包裹引号。
- macOS 的默认应用 `open %s` 与访达 `open -R %s` 也使用同样的逐文件转义，并通过 `for = "macos"` 限制平台；编辑器限定 `for = "unix"`。没有增加其他平台的打开工具；非 macOS 的默认应用/访达操作不在本配置支持范围内。
- 保留参考的文本、代码、Nix 扩展名规则和默认应用回退；补充 `text/*` 与空文件规则以覆盖无扩展名文本，目录规则置于前面，避免目录名恰好匹配代码扩展名时被当作文件编辑。预览仍使用当前版本内置 previewers，不额外配置插件。
- 删除已过时的 `micro_workers`、`macro_workers`，工作线程交由当前默认值管理；保留 `bizarre_retry = 5`。
- 删除作者特定的 `g p → ~/Projects`；`g .` 保留 chezmoi 默认源位置 `~/.local/share/chezmoi`，不包含用户名。若使用自定义 source 目录，先运行 `chezmoi source-path`，再修改这条导航；路径含空格时需在 `cd` 的参数外加引号。`g c` 明确导航到 `~/.config`，并非自动读取自定义 `XDG_CONFIG_HOME`。
- `!` 改为 `shell --block --interactive`，移除已失效的 `--confirm`。输入框使用 `move bol`、`move eol`、`kill eol`，不再用只能移动/删除 999 个字符的写法。`copy dirname` 更新为 `copy dirpath`。
- 保留 `Ctrl-f → plugin fzf`。该版本的默认快捷键及[内置 fzf 实现](https://github.com/sxyazi/yazi/blob/v26.8.15/yazi-plugin/preset/plugins/fzf.lua) 均确认它随 Yazi 提供，无需安装 `.yazi` 插件，但仍要求已有 `fzf` 可执行文件。此键会覆盖默认向下翻页，仍可用 `PageDown`；默认 `z` 也可调用 fzf。
- 保留 `y p`、`y d`、`y n` 路径复制组合键，并补充 `y y → yank`：`y` 成为组合键前缀后，用 `y y` 复制文件，`p` 仍为粘贴，避免丢失普通文件复制入口。`r` 使用当前重命名动作，多选时才会批量重命名，不把单个重命名描述成无条件批量操作。
- 删除 `b z`、`b t` 对 `ouch` 插件的调用：参考未提供相应插件，这里不引入无配套快捷键、插件下载或新的归档安装体系。
- Dracula 主题保留原有有效色值；`hovered`/`preview_hovered` 移到 `[indicator].current/preview`，标签颜色移到 `[tabs].active/inactive`，删除已移除的 `tab_width`。`separator_open/close` 改成 `sep_left/sep_right`，继续不显示状态栏分隔符；删除不再生效的 `separator_style` 与重复的 `[status].mode_*`，由 `[mode]` 设置模式颜色。`[select]` 改为 `[pick]`；帮助面板的 `on` 改为 `chord`，`run/desc` 合并成 `action` 并沿用粉色，删除已移除的 `footer`，原描述灰色不再单独设置。删除旧 `[flavor].use`，不加载外部 flavor；`syntect_theme = ""` 继续使用内置语法高亮主题，未声称代码预览也加载了外部 Dracula tmTheme。
- 配置注释和快捷键描述改为简体中文；其余未覆盖的设置由当前 Yazi 默认配置补齐。

## 依赖与快捷键

本次不修改安装清单，也不引入新应用。现有 Brewfile 已列出 Yazi、fzf、Neovim、jq、poppler 等软件；列入清单不等于所有可选预览依赖都已安装。

- 基本文件浏览需要已有 `yazi`；文本/代码预览使用内置能力，MIME 探测使用 `file`。
- 编辑需要 PATH 中的 `nvim` 命令；退出 Neovim 后返回 Yazi。此选择独立于 chezmoi 的 `code --wait` 编辑器。
- `Ctrl-f` 或 `z` 需要已有 `fzf`；`open`、`open -R` 是 macOS 自带命令。本次未调用真实 macOS 默认应用或访达。
- 视频、PDF、SVG、特殊图片格式及归档预览，分别取决于当前 Yazi 内置预览器要求的 `ffmpeg`、`pdftoppm`、`resvg`、`magick`、`7zz` 等已有工具，以及终端图像协议。缺失时对应预览可能不可用，不会自动下载依赖。`ffmpegthumbnailer` 不能视作当前内置视频预览器所需 `ffmpeg` 的替代品。
- 不启用 ouch、Git 插件或额外主题。默认快捷键若调用其他可选工具（如 `Z` 的 zoxide、`s` 的 fd、`S` 的 ripgrep），仍遵循 Yazi 本身的依赖要求，不属于新增插件。

| 按键 | 行为 |
|---|---|
| `g h` / `g c` / `g d` / `g .` | 主目录 / 配置目录 / 下载目录 / 默认 chezmoi 源目录 |
| `Ctrl-h`（或默认 `.`） | 切换隐藏文件 |
| `a` / `r` | 新建 / 重命名 |
| `e` | 交互选择打开方式（编辑器或 macOS 访达等） |
| `!` | 输入 shell 命令，阻塞等待结束 |
| `Ctrl-f`（或默认 `z`） | 内置 fzf 模糊查找 |
| `y y` / `p` | 复制文件 / 粘贴 |
| `y p` / `y d` / `y n` | 复制文件路径 / 所在目录路径 / 文件名 |
| 输入框 `Ctrl-a` / `Ctrl-e` / `Ctrl-k` | 行首 / 行尾 / 删除至行尾 |

## 部署

**本次未自动部署到本机。** 真实 `~/.config/yazi` 已有配置，应用前先自行备份并查看差异。仅在决定替换这三份偏好后执行：

```sh
chezmoi diff ~/.config/yazi/yazi.toml ~/.config/yazi/keymap.toml ~/.config/yazi/theme.toml
chezmoi apply ~/.config/yazi/yazi.toml ~/.config/yazi/keymap.toml ~/.config/yazi/theme.toml
```

指定这些目标不会部署其他配置或触发 Homebrew 生命周期脚本。完整 `chezmoi apply` 也会部署它们，但范围更广，需另行检查。已有本机 `init.lua` 或插件不会被这三份文件自动删除，若它们改变主题或打开行为，应先排除其影响。

## 验证命令与边界

已使用 Python `tomllib` 解析三份配置，并在临时 HOME 中实际启动 Yazi 26.8.15，
加载仓库配置后正常退出。编辑器现为 `nvim -- %s`，通过真实 Neovim headless 模式
验证包含空格、单引号、分号等 shell 元字符的绝对路径被作为单个文件打开；
没有执行文件名中的命令片段。

配置部署另在临时目标进行验证，不覆盖本机三份文件。
没有把全部可选预览器、系统剪贴板、fzf 交互或 macOS 默认应用／访达操作视为已验证；
这些功能仍依赖本机工具和终端环境。未安装插件，也未修改 Shell 初始化。
