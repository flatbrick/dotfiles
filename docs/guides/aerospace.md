# AeroSpace 配置

[返回 README](../../README.md)

## 来源与纳管范围

`home/private_dot_config/aerospace/aerospace.toml.tmpl` 使用
[signalridge 的 AeroSpace 模板](https://github.com/signalridge/dotfiles/blob/a978087/private_dot_config/aerospace/aerospace.toml.tmpl)
的布局、快捷键及应用规则生成方式。应用清单由
`home/.chezmoidata/aerospace.yaml` 的 `aerospace.floatingApps` 提供，保留本机八个浮动应用。
不引入上游的整机 `work/private` 分类，将三组条件清单简化成一份用户清单；
其余有效设置与参考基线 `a978087` 一致，不自动跟踪上游变更。

保留全部本机行为，包括：

- Settings/preferences、画中画、Finder 特定对话框的浮动规则。
- System Settings、Preview、Calculator、Karabiner Settings/EventViewer、RustDesk、
  Raycast 和 Ghostty 的浮动应用列表。
- 按显示器位置强制分配工作区：1–6 到显示器 1，7–8 到显示器 2，9–10 到显示器 3。
- 自动登录启动、8 像素间距、鼠标跟随显示器、完整主模式与服务模式快捷键。

模板注释与数据来源均指向 `.chezmoidata/aerospace.yaml`。
应用条目使用 `id`（macOS bundle ID）及 `comment`（可读名称），按清单顺序生成浮动规则。
服务模式实际入口为 `Alt+S`，原文件中 `alt-shift-;` 的注释不代表实际绑定。
本配置仅适用于 macOS，非 macOS 由 `home/.chezmoiignore` 排除。

## 修改与部署

增删浮动应用只修改 `home/.chezmoidata/aerospace.yaml`；
调整布局和快捷键则修改模板。部署前确认规则及显示器分配适合目标机器；
位置编号依赖实际显示器布局，不能保证另一台机器具有相同布局。

仅部署该文件，避免运行全仓库安装脚本：

```sh
chezmoi diff ~/.config/aerospace/aerospace.toml
chezmoi apply ~/.config/aerospace/aerospace.toml
```

不要直接修改生成的本机清单后再 `chezmoi add`，以免将数据固化到模板；
应将应用变更写回 YAML，将其他设置变更写回模板。
应用配置后，由用户自行决定何时重载 AeroSpace；重载可能立即改变窗口布局和快捷键。
辅助功能权限等由用户在 macOS 中授权，纳管不自动授予权限。

## 检查边界

已渲染模板并解析 TOML，确认全部有效配置与本机现有文件结构等价，
包括八个应用规则、显示器分配及快捷键；临时目标实际部署也通过相同比对。
因生成注释和空白可能变化，不再声明与本机文件逐字节一致。
本机 AeroSpace 为 `0.21.3-Beta`；没有启动 GUI、重载配置、变更窗口或进行桌面行为测试。
`aerospace config` 是活动配置查询命令；本次没有将它当作独立文件校验器，
也没有执行 `reload-config`（包括 dry-run）。语法和部署检查不等于完整应用语义验证。
