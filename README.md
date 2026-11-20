# Agentic Document Workspace

这是一个由 agent 驱动的文档工作区，用于制作研究汇报幻灯片和示意图。工作流本身（说明、共享技能、脚本、模板与绘图预设）通过 Git 在多台机器间同步；具体项目体积较大且迭代频繁，留在本机，按需经由网盘手动复制。

## 工作流

- `slides/`：研究报告幻灯片。用 Markdown 撰写内容，可渲染为 Typst（A：Quarto Clean，B：Metropolis）或 XeLaTeX Beamer（Moloch、Argüelles），输出 PDF、PNG 与 HTML，并附带检查、人工审核和局部迭代流程。
- `drawing/`：示意图。支持 draw.io 与 Excalidraw，交付可编辑的原生源文件及导出的 SVG、PNG。
- `documents/`：预留的文档项目目录，工作流尚未实现。

详细用法见 [slides/README.md](slides/README.md) 与 [drawing/README.md](drawing/README.md)。

## 仓库内容与本地内容

仓库只收录工作流本身；具体项目以及各机器生成的文件都留在本地。

| 内容 | 维护方式 |
| --- | --- |
| 工作流说明、AGENTS.md、共享技能、脚本、模板、绘图预设 | 提交到 Git，各机器共享同一份 |
| package.json、package-lock.json、requirements-slides.txt | 提交到 Git；依赖在每台机器单独安装 |
| 模板随附的主题源码、字体及许可证 | 提交到 Git；属于创建项目必需的固定资源 |
| slides/projects/、drawing/diagrams/ | 只放在本机；换机器时复制整个项目文件夹 |
| documents/projects/ | 本机预留目录，尚未接入工作流 |
| node_modules/、.venv/、.cache/、渲染产物 output/、临时文件 | 各机器自行生成，无需提交 |
| .env、.codex/、.aws/、编辑器本地配置 | 在本机单独配置即可 |

本地 `research-slides` 技能位于 `slides/.agents/skills/`，随工作流同步。SeaSlides 作为可选 Git 子模块保存在 `slides/vendor/seaslides/`；主仓库只记录上游地址和固定提交号，不再直接收录它的整套资源。模板和字体仍按实际需要保留，不按扩展名统一忽略。

## 新机器部署

克隆仓库后，在每台机器上分别安装 Git、Node.js/npm 与 Python，以及所选渲染后端依赖的系统工具。当前启动脚本以 Windows 为主。

在仓库根目录安装依赖：

```powershell
npm --prefix drawing ci
.\slides\setup-slides.cmd
```

绘图使用 draw.io Desktop；若安装在非默认位置，通过本机环境变量 `DRAWIO_BIN` 指定可执行文件。Excalidraw 使用系统 Chrome、Edge 或单独安装的 Playwright Chromium。Beamer 需要本机提供 latexmk、XeLaTeX、CTeX 与 Pandoc；中文字体及其他环境要求见各工作流 README 及 slides 的 `doctor` 输出。

初始化完成后，日常用 Git 提交、推送和拉取工作流改动。依赖清单更新后，重新执行对应的安装命令。

## 手动复制项目

将 `slides/projects/<项目名>/` 或 `drawing/diagrams/<图名>/` 整个文件夹复制到另一台机器的相同相对位置。复制时保留内容、素材、模板快照、字体、布局和版本记录；如需保留已导出的结果，可一并复制项目内的 `output/`。预留的文档项目放在 `documents/projects/<项目名>/`。

不要复制整个工作区来覆盖另一台机器的仓库，也不要复制 `.git/`、`.venv/`、`node_modules/` 或缓存。项目不受 Git 保护，备份与多机冲突需在手动复制时自行处理；同时不要用 `git clean -fdx` 清理这个工作区，它会删除被忽略的本地项目。

绘图 README 中的 rainwater 示例与 slides README 中的 beamer-comparison 示例均属本地项目，首次克隆时不会包含；需要时按上述方式另行复制。


## 可选 SeaSlides 外部引用

上游：[touying-typ/seaslides](https://github.com/touying-typ/seaslides)。固定版本：`dcde5bf6c6875b300e2999fc7766f369a13a67ac`。这是可参考或显式调用的完整上游技能；日常 `slides.cmd new/build` 使用本地实现，不依赖它。Python、浏览器和其他运行依赖仍需各机器自行安装。

普通 clone 不下载子模块内容。需要时在本仓库根目录执行：

```powershell
git submodule update --init --recursive -- slides/vendor/seaslides
```

也可以首次使用 `git clone --recurse-submodules <本仓库地址>` 一起下载。拉取工作流后，若子模块版本有变，再执行上述 update 命令；不要用 `--remote` 自动跟随上游最新版本。

技能入口为 `slides/vendor/seaslides/skills/seaslides-typst-slides-skill/SKILL.md`。可以明确告诉 agent 读取该入口并使用 SeaSlides 完整流程；本地默认工作流仍由 research-slides 指导。子模块下载完整上游仓库，资源保存在本机，但不作为普通文件复制到本仓库的后续提交。

迁移前的资源仍存在于本仓库历史提交中；本次转换不重写历史，因此普通完整 clone 的历史体积不会立即缩小。
