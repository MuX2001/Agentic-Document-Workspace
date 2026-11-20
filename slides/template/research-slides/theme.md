# Research slides：原版主题

A 使用 touying-quarto-clean 0.2.1 的完整原版 clean-theme；B 使用 Touying 0.7.4 自带的完整 Metropolis。两者均保留上游源码与许可证。preset.typ 直接调用原版主题；template.typ 提供共享科研内容组件，不重画主题。

新建项目复制所选主题与依赖到 theme-packages/，字体到 fonts/。渲染优先使用项目快照；来源与逐文件 SHA-256 见 template-origin.json。原版源码来源见工作区 upstream/SOURCES.json。

| 模板 | 字体与原有设计 |
|---|---|
| A | Roboto 轻字重、蓝色强调、原版标题及页码，代码使用 Fira Code |
| B | Fira Sans、深色标题栏、橙色强调、原版页码和进度条 |

中文使用 Microsoft YaHei 回退，数学使用 Typst 的 New Computer Modern。保留原版默认字号、留白及主题组件。不要再统一套用 Simple 主题或去掉主题固有设计。

## 三个独立阶段

新建与内容准备只编辑 slides.md，不渲染。内容规范见 content-format.md。
渲染读取 Markdown 和 layout.json，生成 main.typ。一个 Markdown slide ID 对应一页；不会自动插入封面或章节页。

## 共享内容接口

```typst
#import "template.typ": *
#show: research-theme.with(lang: "zh")
#discussion-slide(title: [待讨论问题])[需要讨论的具体问题。]
```

| 函数 | 用途 |
|---|---|
| theory-slide(formula, title: none, explanation: none, columns: auto) | 公式及解释 |
| diagram-slide(figure, title: none) | 完整原图 |
| experiment-slide(visual, results, title: none) | 关键帧与结果 |
| comparison-slide(headers, rows, title: none, widths: (1.4fr, 2fr, 2fr, 2fr)) | 文献对比表 |
| discussion-slide(body, title: none) | 居中讨论内容 |
| markdown-slide(body, title: none, compact: false) | Markdown 内容页 |

diagram(path, height: 403pt)、frame-strip、experiment-frame、caption、markdown-table、markdown-figure 均保留。图片使用 contain，不裁剪；必要时在 layout.json 指定 image_height。表格、图注 18 pt，正文遵循所选主题默认 20 pt。

## 完整原版 API

在原生 Typst 项目中，通过 preset.typ 的 native 访问完整主题模块：

```typst
#import "template.typ": research-theme
#import "preset.typ": native
#show: research-theme.with(lang: "zh")
#native.title-slide(title: [研究题目], subtitle: [组会汇报])
```

A 还可调用 native.slide、native.new-section-slide、native.fg、native.bg、native.button、native.small-cite。A 的作者信息遵循原版结构化 authors 参数。
B 还可调用 native.slide、native.outline-slide、native.new-section-slide、native.focus-slide。
完整参数见项目 theme-packages/preview/ 中的源码与 README。

Markdown 项目的 main.typ 会在 build 时重建；手写原生 API 请使用独立 Typst 入口并在 deck.json 去掉 markdown_source、设置 entry 和 expected_pages。完整源码导入不代表自动向汇报加入所有页面类型；封面、目录和章节页仅按内容需要使用。

现有项目保留各自快照。新建使用 starter.md / starter-en.md；main.typ 是模板教学样例，其中的实验占位文字不用于真实汇报。
