# Slide Workspace 幻灯片工作区

工作区采用三个独立阶段。内容主文件为 `slides.md`。默认使用 Typst A（Quarto Clean），也可选 Typst B（Metropolis）或 XeLaTeX Beamer（Moloch、Argüelles）。

## 1. 新建项目

告诉 Codex「新建下次组会，用 B，根据这些输入建立 Markdown」，或运行以下命令。

```powershell
.\slides.cmd new 20261126-meeting --template B --language zh
```

新建只创建文件。Codex 根据输入填写汇报背景和内容初稿，完成后交付 Markdown。英文使用 `--language en`。同名项目拒绝覆盖。

## 2. Content Preparation

直接编辑 `projects/<name>/slides.md`，或告诉 Codex「准备内容，整理这些结果，确定哪些需要 present」。可以多次补充、讨论、删减和调整叙事。

每个 `## S01 · 标题` 定义一页，ID 随内容保留。每页使用以下三级栏目。

- 本页目的
- 上屏内容
- 讲述背景
- 证据与约束
- 可选上屏内容
- 待补充项

将实际展示文字、表格和素材引用放入“上屏内容”。背景与证据栏目保留理解本页所需的上下文。编辑阶段只处理内容。此阶段无需命令，也不会触发渲染、素材转换或视觉检查。

完整格式、公式写法和英文栏目见 [content-format.md](template/research-slides/content-format.md)。

## 3. Slide Rendering

告诉 Codex「开始渲染」，或运行以下命令。

```powershell
.\slides.cmd build projects/20261126-meeting
```

渲染读取 Markdown 与项目素材，生成 `main.typ`，编译一次 PDF，再由同一 PDF 输出 PNG、overview 和 HTML。默认预览为 96 ppi。处理编译报错并看图检查排版后交付。

反馈示例为「S03 表格更宽，省略可选解释」。视觉调整按 slide ID 保存在 `layout.json`。局部迭代可以只输出指定页 PNG，PDF 和 overview 始终覆盖全部页面。

```powershell
.\slides.cmd build projects/20261126-meeting --pages 2,3
.\slides.cmd build projects/20261126-meeting --final
```

`--final` 仅用于生成全部 144 ppi PNG。检查限于编译报错和看图审查视觉元素；局部改动只看受影响页面，全局改动再看整份，不记录审批或重复核对哈希。

“上屏内容”和“可选上屏内容”默认显示。可以在 `layout.json` 中对某页设置 `"include_optional": false`。必要的文字压缩回写 Markdown，保留原始依据并说明重要删减。

## 项目文件

### 使用 Beamer

Beamer 主题、许可证及来源记录统一放在 [template/beamer/themes/](template/beamer/themes/)。

字体按名称和字重查找，优先使用 Windows 系统和当前用户安装的字体。缺少思源黑体时从 Adobe 下载所缺字重。英文与代码字体沿用各主题原配置。下载文件和 XeLaTeX 所需的可变字体字重共用 `.cache/beamer-fonts/`。换电脑后用 build 重新解析本机路径。[思源黑体](https://github.com/adobe-fonts/source-han-sans)

新建时可以把 Beamer 写入项目配置。内容准备阶段照常编辑 Markdown。对已有 Markdown 项目，在 build 时指定后端即可临时切换。

```powershell
.\slides.cmd new my-talk --backend beamer --language zh
.\slides.cmd build projects/my-talk
.\slides.cmd build projects/my-talk --beamer-theme arguelles
.\slides.cmd build projects/my-talk --backend typst
```

`deck.json` 中的 `backend` 可取 `typst` 或 `beamer`，`beamer_theme` 可取 `moloch` 或 `arguelles`。指定 `--beamer-theme` 即选择 Beamer。工作区固定了 Moloch 2.3.1 与 Argüelles 2.6.0 的官方运行文件。编译使用 latexmk、XeLaTeX 和 CTeX。两套主题的中文使用思源黑体，正文 Regular、标题与表头 Medium、强调 Bold；英文及代码保留原主题字体，Argüelles 启用其原生 Alegreya 字体。项目覆盖放入 `beamer/config.tex`。

每次成功构建都更新 `output/slides.pdf` 和常规预览。`output/beamer/<主题>/` 同时保存该主题最近生成的 `main.pdf`、可编辑的 `main.tex`、配置和引用图。在该目录运行 `latexmk -xelatex main.tex` 可复编。持续编辑请改 Markdown、layout.json 或项目级 config.tex，重新构建会生成新的 TeX。`--pages` 控制预览页，`--final` 控制预览分辨率。

build 统一读取 Markdown、稳定 ID 和 layout.json，选出上屏内容并分栏。渲染阶段才根据后端生成 main.typ 或 main.tex 并编译。Beamer 通过 Pandoc 将 `typst-math` 转为原生 LaTeX 公式，也接受 `latex-math`。两条路径共用 PDF 检查、PNG、HTML 和视觉检查。旧式 Markdown 按二级标题分帧，旧主题专用的热图着色和表格权重属于 Typst 布局。

同页对比样例在 [beamer-comparison](projects/beamer-comparison/slides.md)。数学曲线和表格均由递推式计算。两套主题的上游说明见 [Moloch](https://github.com/jolars/moloch) 和 [Argüelles](https://github.com/piazzai/arguelles)。后续如需对比极简学术风格或更鲜明的章节设计，可参考 [Auriga](https://github.com/anishathalye/auriga) 和 [Focus](https://github.com/elauksap/focus-beamertheme)。

### Typst 项目快照

```text
projects/<name>/
  slides.md               内容主文件与上下文
  deck.json               Markdown 格式、语言和入口
  template.typ            项目模板快照
  preset.typ              原版 A/B 主题接口
  theme-packages/          所选主题及依赖的完整原版源码、许可证
  fonts/                  所选主题字体及许可证
  template-origin.json    模板来源与校验值
  layout.json             可选，在渲染阶段保存单页视觉调整
  main.typ                渲染时生成
  assets/                 图像与独立视频
  sources/                原始资料
  output/
    slides.pdf / slides.html
    pngs/ / overview.png
    quality.json / build.json
```

`slides.md` 中的图片使用项目内相对路径。原始素材可以在内容阶段直接复制保存。渲染阶段需要转换 PDF 图时使用导入命令。

```powershell
.\slides.cmd import-asset projects/20261126-meeting D:/figures/result.pdf --page 1
```

PDF 图转换为 SVG，并保存原始文件。SVG、PNG、JPEG、WebP、MP4 和 Excalidraw 也可导入。视频保留在 assets/videos/。素材来源记录在 sources/assets.json。

## 模板

```powershell
.\slides.cmd templates
.\slides.cmd preview A
```

A 直接使用原版 Quarto Clean 0.2.1，B 直接使用 Touying 0.7.4 内置的原版 Metropolis。保留原版主题外观与全部原生 API；适配层负责中文字体回退和共享科研内容接口。完整源码与字体随新项目复制，校验值记录在 template-origin.json。详见 [主题说明](template/research-slides/theme.md)。

`preview` 明确启动模板样例渲染。样例位于 `template/research-slides/output/presets/<name>/output/`。

Markdown 支持 research-slides-v2 栏目格式和按二级标题分页的格式。Typst 项目从 main.typ 构建。每个项目有独立模板快照。

## 首次安装与环境排错

```powershell
.\setup-slides.cmd
.\slides.cmd doctor
```

安装与诊断只在环境需要时使用。依赖固定于 requirements-slides.txt，安装在 .venv。新项目自带 Touying 0.7.4、uniwarn 0.1.1，以及 A 所需的 Quarto Clean 0.2.1 源码快照。A 使用 Roboto / Fira Code，B 使用 Fira Sans；中文统一使用思源黑体。新建不下载字体；doctor 或首次渲染时优先解析本机思源，缺失字重下载并缓存。Typst 使用独立字体缓存，即使关闭系统字体也可加载。

本地单次编译实现位于 scripts/render_slides.py。行为规范在 [research-slides skill](.agents/skills/research-slides/SKILL.md) 与 [slide-style.md](slide-style.md)。


## 可选上游 SeaSlides

SeaSlides 以固定版本子模块保存在 `vendor/seaslides/`，入口为 `vendor/seaslides/skills/seaslides-typst-slides-skill/SKILL.md`。日常新建与渲染使用本地 scripts 和 template，无需下载此子模块；doctor 只报告这个可选参考是否存在。需要参考或明确使用完整上游技能时，在仓库顶层执行 `git submodule update --init --recursive -- slides/vendor/seaslides`。部署与版本同步详见 [顶层说明](../README.md#可选-seaslides-外部引用)。

工作流开发时可运行 `scripts/test-slides.py` 与 `scripts/test-beamer.py`；日常做幻灯片无需运行这些测试。
