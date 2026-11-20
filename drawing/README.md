# Drawing Workspace · 通用绘图工作区

draw.io 和 Excalidraw 均可直接点名。任务只需写目标、素材位置和可选的工具或风格。例如“用 draw.io 画这套系统的部署关系”，或“用 Excalidraw 的纸上讲解解释过滤过程”。已有图默认沿用原生格式。

从相邻项目提交 UTF-8 任务单：

~~~powershell
& ..\drawing\draw.ps1 -Brief .\brief.md
~~~

CLI 从 Drawing 启动，使用 workspace-write。每张图及其说明保存在 diagrams/ 下。素材路径可相对于任务单。

[三套手绘预设及样板](presets/README.md) · [双工具示例](diagrams/rainwater/README.md)

在工作区根目录重新导出：

~~~powershell
node export.mjs diagrams/rainwater/collection.drawio
node export.mjs diagrams/rainwater/styles.excalidraw
~~~

输出为源文件旁同名的 SVG 和 PNG。不同格式的源文件如需并存，使用不同文件名。draw.io 默认导出第一页，使用本机 draw.io Desktop；其他安装位置可通过 DRAWIO_BIN 指定可执行文件。Excalidraw 使用项目依赖（新机运行 npm ci）和系统 Chrome、Edge 或 Playwright Chromium。
