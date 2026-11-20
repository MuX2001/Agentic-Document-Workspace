# Research Slides — Style Rules

适用于本工作区的组会、1-on-1 meeting、paper discussion 和实验汇报。交付 PDF，同时保留可编辑的 Typst 源文件。具体任务中的用户要求优先于这些默认规则。

## Language

- 跟随讨论语言使用中文或英文，表达自然、简短、准确。
- 使用“训练”“实验”“推理”等自然中文；保留 encoder、policy、baseline、rollout、ablation、checkpoint、failure mode、MoE 等惯用术语，不机械翻译。
- 讨论问题直接落到待判断的对象、条件或实验，保留必要的限定。
- 不写 “This slide discusses…”、“Key takeaways” 等套话，不重复解释图中显而易见的信息。

## Stage boundaries

- 新建项目与 Content Preparation 只处理 Markdown、输入资料和内容取舍。
- 收到渲染指令或视觉反馈后进入 Slide Rendering，以下视觉规则在该阶段应用。
- 内容规范见 template/research-slides/content-format.md。Markdown 是内容源，layout.json 保存单页视觉调整。
- Typst 可选 A 和 B。Markdown 项目也可用 Beamer，默认 Moloch，可选 Argüelles。每个阶段结束后等待下一阶段的明确指令。

## Visual style

Beamer 用 XeLaTeX、CTeX 与所选上游主题编译。中英文采用 1119 的思源黑体，正文 Regular、标题与表头 Medium、强调 Bold。代码使用 Fira Code，图内文字遵循原图。优先使用本机字体，缺失时按 README 的官方来源获取并共享缓存。字号按 1119 页面宽度等比换算。默认配置在 `template/beamer/fonts.tex`，项目覆盖放在 `beamer/config.tex`。

- 按选定模板使用它的字体、字号、色板、标题层级、页眉页脚和页码。A 直接加载官方 Quarto Clean 0.2.1，B 直接加载 Touying 0.7.4 原版 Metropolis；中文补充字体使用微软雅黑。
- 由制作者根据研究内容选用封面、章节过渡、副标题、强调、内链导航、实验图文和比较表。图与解释优先同页，较大的消融矩阵按任务拆页。
- 页面密度通过列宽、图表位置和分页调整，保持所选主题的文字可读性。

## Layout selection

新建汇报时从 [本地预设](README.md#模板) 中选择一套，整份汇报共用该预设。以下布局由 `template/research-slides` 提供：

1. Equation / Theory：核心公式与必要的符号、假设说明。
2. Full-page Diagram：完整显示已有 SVG、PDF 或 PNG 图，保持比例，不裁切。
3. Experiment / Demo：真实关键帧、结果、必要的实验条件；视频单独保存在 `assets/videos/`。
4. Literature Comparison：可读的对比表，区分方法、假设、证据和 limitations。
5. Blank / Discussion：短问题或单张图片，不强制标题、结论和列表。

布局按内容选择，不为了形式变化而更换主题，不强迫每次汇报使用全部五类。

## Technical content

- 保留数学符号、变量定义和假设，使用原生 Typst 公式。
- 优先插入已有图，保留 Excalidraw 源文件和导出的 SVG，不在 slides 中重新画一遍。
- 原始 PDF 图由导入命令转换成 SVG 后插入，并保留原始文件。
- 只使用真实实验结果，不补造数值、曲线、失败案例或文献。
- 缺失资料时说明缺口；可用“未测量”明确缺失值，不补齐看似完整的表。
- 不自动添加脚注或 bibliography；用户要求或区分科学主张所必需时，提供最小必要归属信息。
- PDF demo 使用实际实验帧；原始 MP4 单独交付，需要时加可访问链接。不给 PDF 承诺内嵌视频播放能力。
- 不为凑页数、填空白或使汇报显得完整而加入范围之外的内容。

## Output and validation

- 项目内保存 `main.typ`、`template.typ` 和所需 assets，产物为 `output/slides.pdf`。
- 初次渲染与定稿输出全部 PNG；局部迭代可只输出指定页 PNG。PDF 和 overview 始终包含整份汇报。
- 检查页数、缺失资源、公式、字体、文本越界、图片裁切和可读性。
- 初稿检查整份汇报，局部修改检查受影响页面，全局样式修改和定稿检查全部页面。人工批准由用户明确确认并绑定当前版本。
- 发现问题后修改源文件并重新编译、检查。交付时如实说明仍未解决的限制。
- `template/research-slides/main.typ` 是布局教学样例，允许明确的素材占位说明；真实汇报不能照搬占位内容。
