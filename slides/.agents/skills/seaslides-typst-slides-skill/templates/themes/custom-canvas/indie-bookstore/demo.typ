#import "@preview/touying:0.7.4": *
#import "template.typ": *

#show: zine-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Zine 文化指南],
    subtitle: [一份从一张纸到一家书店的独立出版地图],
    author: [PPT Master],
    date: datetime.today(),
  ),
)

// ========== Page 1: Cover ==========

#title-slide(
  bg-image: "images/cover_hero.png",
  title: [ZINE\ CULTURE\ GUIDE],
  subtitle: [一份从一张纸到一家书店的独立出版地图],
  info-text: [INDIE BOOKSTORE #sym.times ZINE #sym.dot.c PPT MASTER RISOGRAPH],
)

// ========== Page 2: TOC ==========

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.blue, height: 44pt),
    text(size: 28pt, weight: "bold", fill: palette.text-dark,
      font: ("Arial", "Heiti SC"))[CONTENTS / 目录],
  )
  #v(2pt)
  #eyebrow[FIVE PARTS #sym.dot.c 18 PAGES #sym.dot.c READ IN ANY ORDER]
  #v(2pt)
  #line(length: 100%, stroke: 2pt + palette.border)
  #v(8pt)

  // TOC items
  #{
    let toc-row(num, color, title-text, desc, pages) = {
      block(width: 100%, stroke: (bottom: 0.5pt + palette.border.transparentize(80%)), inset: (bottom: 6pt))[
        #grid(columns: (56pt, 1fr, 120pt), column-gutter: 10pt, align: horizon,
          riso-square(size: 48pt, fill-color: color)[
            #text(size: 20pt, fill: palette.bg, weight: "bold",
              font: ("Arial",))[#num]],
          [
            #text(size: 13pt, weight: "bold", fill: palette.text-dark)[#title-text]
            #v(2pt)
            #text(size: 8.5pt, fill: palette.text-sec)[#desc]
          ],
          block(fill: palette.blue, inset: (x: 12pt, y: 7pt), radius: 0pt, width: 100%)[
            #set align(center)
            #text(size: 10pt, fill: palette.bg, weight: "bold",
              font: ("Menlo",), tracking: 1.5pt)[#pages]
          ],
        )
      ]
    }
    grid(rows: 5, row-gutter: 6pt,
      toc-row([01], palette.pink, [ZINE 是什么 + 简史四浪潮], [从科幻同人志到 Riot Grrrl，一百年里 zine 的四次浪潮], [P03 -- P04]),
      toc-row([02], palette.blue, [RISOGRAPH：zine 工艺的灵魂载体], [套色错位、半色调、限定色 -- 让一台日本复印机变成艺术工具], [P05 -- P06]),
      toc-row([03], palette.mustard, [怎么自己做一本 ZINE], [八页折叠法 + 内容类型清单 -- 一张 A4 就够], [P07 -- P08]),
      toc-row([04], palette.blue, [全球 + 中国独立书店地图], [神保町 / Shakespeare & Co / 香蕉鱼 / 假杂志 + abC #sym.times UNFOLD 双书展], [P09 -- P13]),
      toc-row([05], palette.pink, [怎么逛 / 怎么收藏 / 行动清单], [从读者到作者，你的第一本 zine 在 4 步之外], [P14 -- P18]),
    )
  }

  #v(1fr)
  #zine-footer[CONTENTS -- P02][RISO NAVY #sym.times FLUO PINK ON CREAM]
]

// ========== Page 3: Zine What ==========

#slide(config: config-page(margin: (top: 1.5em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (28%, 4%, 68%), column-gutter: 0pt,
    // Left image strip
    [
      #block(width: 100%, height: 100%, clip: true)[
        #place(top + left, block(width: 100%, height: 370pt, fill: palette.pink))
        #place(top + left, dy: 4pt,
          block(width: 100%, height: 366pt, clip: true)[
            #image("images/zine_history_collage.png", width: 100%, height: 100%, fit: "cover")
          ])
        #place(bottom + left, dx: 6pt, dy: -28pt)[
          #text(size: 6.5pt, fill: palette.text-sec, tracking: 1pt, font: ("Menlo",))[A CENTURY OF\ SELF-PUBLISHING]
        ]
      ]
    ],
    [],
    // Right content
    [
      #eyebrow[PART 01 #sym.dot.c WHAT IS A ZINE]
      #v(4pt)
      #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
        title-bar(color: palette.blue, height: 52pt),
        [
          #text(size: 50pt, fill: palette.pink, weight: "black",
            font: ("Arial",), tracking: 2pt)[ZINE]
          #h(10pt)
          #text(size: 50pt, fill: palette.text-dark, weight: "bold")[=]
          #h(10pt)
          #text(size: 50pt, fill: palette.blue, weight: "black",
            font: ("Arial",), tracking: 2pt)[MAGAZINE]
        ],
      )
      #v(4pt)
      #text(size: 24pt, weight: "bold", fill: palette.text-dark)[#sym.minus 商业逻辑 #h(14pt) #sym.minus 编辑把关 #h(14pt) #sym.minus 规模]
      #v(6pt)
      #line(length: 100%, stroke: 1.5pt + palette.border)
      #v(6pt)

      // Three numbered characteristics
      #grid(rows: 3, row-gutter: 6pt,
        grid(columns: (36pt, 1fr), column-gutter: 8pt, align: horizon,
          block(width: 28pt, height: 28pt, fill: palette.pink, radius: 14pt)[
            #align(center + horizon)[#text(size: 10pt, fill: white, weight: "bold")[.1]]
          ],
          [
            #text(size: 12pt, weight: "bold", fill: palette.text-dark)[自制、非商业]
            #v(2pt)
            #text(size: 9pt, fill: palette.text-sec)[印量极小，多在 1000 份以内，常少于 100 份]
          ],
        ),
        grid(columns: (36pt, 1fr), column-gutter: 8pt, align: horizon,
          block(width: 28pt, height: 28pt, fill: palette.pink, radius: 14pt)[
            #align(center + horizon)[#text(size: 10pt, fill: white, weight: "bold")[.2]]
          ],
          [
            #text(size: 12pt, weight: "bold", fill: palette.text-dark)[装订简单、内容混合]
            #v(2pt)
            #text(size: 9pt, fill: palette.text-sec)[订书钉/折页/手工缝；手写/打字/拼贴/漫画/摄影/宣言全部上场]
          ],
        ),
        grid(columns: (36pt, 1fr), column-gutter: 8pt, align: horizon,
          block(width: 28pt, height: 28pt, fill: palette.pink, radius: 14pt)[
            #align(center + horizon)[#text(size: 10pt, fill: white, weight: "bold")[.3]]
          ],
          [
            #text(size: 12pt, weight: "bold", fill: palette.text-dark)[完全作者主权]
            #v(2pt)
            #text(size: 9pt, fill: palette.text-sec)[没有编辑、没有把关、没有商业审查 -- 这就是 zine 的精神底色]
          ],
        ),
      )

      #v(8pt)
      // Bottom dark banner
      #block(fill: palette.text-dark, width: 100%, inset: (x: 12pt, y: 8pt), radius: 0pt)[
        #text(size: 10pt, fill: palette.mustard, weight: "bold")[关键边界 >] #h(6pt)
        #text(size: 9pt, fill: palette.bg.transparentize(10%))[一本 zine 一旦进入大规模发行 + 编辑流程 + 利润逻辑，它就不再是 zine]
      ]
    ],
  )

  #v(1fr)
  #zine-footer[P03 #sym.dot.c WHAT IS A ZINE][ZINE = MAG #sym.minus COMMERCE #sym.minus EDITOR #sym.minus SCALE]
]

// ========== Page 4: Zine History Timeline ==========

#slide(config: config-page(margin: (top: 1.5em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.pink, height: 36pt),
    text(size: 22pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[一百年里 ZINE 的四次浪潮],
  )
  #v(2pt)
  #eyebrow[FOUR WAVES OF SELF-PUBLISHING #sym.dot.c 1920s -- 2026]
  #v(2pt)
  #line(length: 100%, stroke: 1.5pt + palette.border)
  #v(2pt)

  // Top row: 1920s, 1976, 2010s+
  #grid(columns: (20%, 28%, 20%, 10%, 22%), column-gutter: 0pt,
      // 1920s
      [
        #align(center)[
          #text(size: 24pt, fill: palette.pink, weight: "bold",
            font: ("Arial",))[1920s]
        ]
        #v(1pt)
        #zine-card(variant: "pink")[
          #text(size: 8pt, fill: palette.text-dark, weight: "bold")[业余出版火种]
          #v(2pt)
          #text(size: 7.5pt, fill: palette.text-dark)[哈莱姆文艺复兴\ 黑人创作 \*FIRE!!\*\ 自由独立地表达]
          #v(3pt)
          #mono-caption[EMBER]
        ]
      ],
      [],
      // 1976
      [
        #align(center)[
          #text(size: 24pt, fill: palette.pink, weight: "bold",
            font: ("Arial",))[1976]
        ]
        #v(1pt)
        #zine-card(variant: "pink")[
          #text(size: 8pt, fill: palette.text-dark, weight: "bold")[朋克 ZINE 浪潮]
          #v(2pt)
          #text(size: 7.5pt, fill: palette.text-dark)[\*SNIFFIN' GLUE\*\ MARK PERRY 创办\ 复印机普及 + 工薪阶层]
          #v(3pt)
          #mono-caption[DIY EXPLOSION]
        ]
      ],
      [],
      // 2010s+
      [
        #align(center)[
          #text(size: 24pt, fill: palette.pink, weight: "bold",
            font: ("Arial",))[2010s+]
        ]
        #v(1pt)
        #zine-card(variant: "cream")[
          #text(size: 8pt, fill: palette.text-dark, weight: "bold")[当代复兴 + 书展爆发]
          #v(2pt)
          #text(size: 7.5pt, fill: palette.text-dark)[SF Zine Fest (2001)\ LA Zine Fest (2012)\ 大英图书馆 / TATE 收藏]
          #v(3pt)
          #mono-caption[RENAISSANCE]
        ]
      ],
  )

  #v(2pt)

  // Timeline bar with arrow
  #grid(columns: (1fr, auto), column-gutter: 0pt, align: horizon,
    block(width: 100%, height: 8pt, fill: palette.blue),
    text(size: 20pt, fill: palette.blue, weight: "bold")[#sym.arrow.r],
  )

  #v(2pt)

  // Bottom row: 1930s, 1991
  #grid(columns: (12%, 24%, 28%, 20%, 16%), column-gutter: 0pt,
    [],
    // 1930s
    [
      #align(center)[
        #text(size: 24pt, fill: palette.pink, weight: "bold",
          font: ("Arial",))[1930s]
      ]
      #v(1pt)
      #zine-card(variant: "dark")[
        #text(size: 8pt, fill: palette.bg, weight: "bold")[科幻同人志]
        #v(2pt)
        #text(size: 7.5pt, fill: palette.bg.transparentize(15%))[\*THE COMET\* (1930)\ 第一本科幻同人志\ 1940 RUSS CHAUVENET\ 创造"FANZINE"一词]
        #v(3pt)
        #text(size: 7pt, fill: palette.pink, tracking: 1.5pt, font: ("Menlo",))[CRYSTALLIZE]
      ]
    ],
    [],
    // 1991
    [
      #align(center)[
        #text(size: 24pt, fill: palette.pink, weight: "bold",
          font: ("Arial",))[1991]
      ]
      #v(1pt)
      #zine-card(variant: "dark")[
        #text(size: 8pt, fill: palette.bg, weight: "bold")[RIOT GRRRL]
        #v(2pt)
        #text(size: 7.5pt, fill: palette.bg.transparentize(15%))[\*BIKINI KILL\* 同名 zine\ KATHLEEN HANNA 主编\ 第三波女性主义 + DIY 朋克\ RIOT GRRRL PRESS 分发网络]
        #v(3pt)
        #text(size: 7pt, fill: palette.pink, tracking: 1.5pt, font: ("Menlo",))[FEMINIST WAVE]
      ]
    ],
    [],
  )

  #v(1fr)
  #zine-footer[P04 #sym.dot.c FOUR WAVES OF ZINE][EMBER #sym.arrow.r CRYSTALLIZE #sym.arrow.r EXPLOSION #sym.arrow.r FEMINIST #sym.arrow.r RENAISSANCE]
]

// ========== Page 5: Risograph Origin ==========

#slide(config: config-page(margin: (top: 1.5em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (35%, 3%, 62%), column-gutter: 0pt,
    // Left sidebar with machine image
    [
      #block(width: 100%, height: 100%)[
        #place(top + left, block(width: 100%, height: 370pt, fill: palette.pink))
        #place(top + left, dy: 4pt,
          block(width: 100%, height: 366pt, clip: true)[
            #image("images/risograph_machine.png", width: 100%, height: 100%, fit: "cover")
          ])
        // Machine label at bottom
        #place(bottom + left, dx: 8pt, dy: -32pt)[
          #text(size: 10pt, fill: palette.text-dark, weight: "bold", font: ("Arial",))[RISO EZ200]
          #h(16pt)
          #text(size: 8pt, fill: palette.text-sec, font: ("Menlo",), tracking: 1pt)[EST. 1986]
        ]
      ]
    ],
    [],
    // Right content
    [
      #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
        title-bar(color: palette.blue, height: 36pt),
        text(size: 28pt, weight: "black", fill: palette.text-dark,
          font: ("Arial", "Heiti SC"))[RISOGRAPH],
      )
      #v(2pt)
      #text(size: 11pt, fill: palette.text-dark, weight: "bold")[zine 工艺的灵魂载体]
      #v(2pt)
      #eyebrow[RISO KAGAKU 1946 #sym.dot.c RISOGRAPH 007 (1986)]
      #v(4pt)
      #line(length: 100%, stroke: 1pt + palette.border)
      #v(4pt)

      // Four visual characteristics
      #grid(rows: 4, row-gutter: 6pt,
        vlist-item([01], [限定调色板 (LIMITED PALETTE)], [一墨筒一色 -- 色彩有限但风格强烈；颜色总数有限反成美学语言], accent: palette.blue),
        vlist-item([02], [套色错位 (MISREGISTRATION)], [每次过纸轻微偏移 1--3px，叠印边缘的"错版"成为美学], accent: palette.pink),
        vlist-item([03], [半色调网点 (HALFTONE)], [色块以网点呈现，介于工业印刷品与丝网作品之间，本质背景就是纸], accent: palette.mustard),
        vlist-item([04], [色块叠印 (OVERPRINT)], [相同色块叠加产生第三色错觉 -- 蓝 + 粉 = 紫色错觉，技术不是缺陷而是工具], accent: palette.blue),
      )
    ],
  )

  #v(1fr)
  #zine-footer[P05 #sym.dot.c RISOGRAPH ORIGIN][LIMITED PALETTE #sym.dot.c MISREGISTRATION #sym.dot.c HALFTONE]
]

// ========== Page 6: Risograph Process ==========

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.blue, height: 36pt),
    text(size: 22pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[工艺：5 步从数字图像到印张],
  )
  #v(2pt)
  #eyebrow[RISOGRAPH WORKFLOW #sym.dot.c ONE COLOR AT A TIME #sym.dot.c 50--10,000 PRINTS / MIN]
  #v(4pt)

  // Banner image
  #block(width: 100%, height: 140pt, clip: true, stroke: (top: 3pt + palette.pink, bottom: 3pt + palette.pink))[
    #image("images/risograph_process_banner.png", width: 100%, height: 100%, fit: "cover")
  ]

  #v(6pt)

  // Five steps
  #grid(columns: (1fr, 1fr, 1fr, 1fr, 1fr), column-gutter: 4pt,
    // Step 1
    zine-card(variant: "cream")[
      #text(size: 18pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[01]
      #h(4pt)
      #text(size: 8pt, fill: palette.text-sec, tracking: 1pt, font: ("Menlo",))[DIGITAL FILE]
      #v(3pt)
      #text(size: 10pt, weight: "bold", fill: palette.text-dark)[接收数字图像]
      #v(3pt)
      #text(size: 7.5pt, fill: palette.text-sec)[#sym.dot.c 一张设计稿\ #sym.dot.c 拆解 N 个颜色\ #sym.dot.c 每色单独出层]
      #v(3pt)
      #text(size: 7pt, fill: palette.text-tert, style: "italic", font: ("Menlo",))[INPUT]
    ],
    // Step 2
    zine-card(variant: "cream")[
      #text(size: 18pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[02]
      #h(4pt)
      #text(size: 8pt, fill: palette.text-sec, tracking: 1pt, font: ("Menlo",))[BURN MASTER]
      #v(3pt)
      #text(size: 10pt, weight: "bold", fill: palette.text-dark)[烧蚀像素化母版]
      #v(3pt)
      #text(size: 7.5pt, fill: palette.text-sec)[#sym.dot.c 热头烧穿纤维基母版\ #sym.dot.c 小孔形成蜂窝阵列\ #sym.dot.c 母版即"刻版"]
      #v(3pt)
      #text(size: 7pt, fill: palette.text-tert, style: "italic", font: ("Menlo",))[STENCIL]
    ],
    // Step 3
    zine-card(variant: "blue")[
      #text(size: 18pt, weight: "bold", fill: palette.bg, font: ("Arial",))[03]
      #h(4pt)
      #text(size: 8pt, fill: palette.bg.transparentize(30%), tracking: 1pt, font: ("Menlo",))[WRAP DRUM]
      #v(3pt)
      #text(size: 10pt, weight: "bold", fill: palette.bg)[包裹彩色墨筒]
      #v(3pt)
      #text(size: 7.5pt, fill: palette.bg.transparentize(20%))[#sym.dot.c 母版裹圆筒\ #sym.dot.c 筒内填大豆基油墨\ #sym.dot.c 一筒 = 一种颜色]
      #v(3pt)
      #text(size: 7pt, fill: palette.bg.transparentize(30%), style: "italic", font: ("Menlo",))[INK DRUM]
    ],
    // Step 4
    zine-card(variant: "cream")[
      #text(size: 18pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[04]
      #h(4pt)
      #text(size: 8pt, fill: palette.text-sec, tracking: 1pt, font: ("Menlo",))[ROLL PRINT]
      #v(3pt)
      #text(size: 10pt, weight: "bold", fill: palette.text-dark)[滚压油墨到纸]
      #v(3pt)
      #text(size: 7.5pt, fill: palette.text-sec)[#sym.dot.c 滚筒高速旋转\ #sym.dot.c 墨从孔渗出\ #sym.dot.c 纸被压在筒下走]
      #v(3pt)
      #text(size: 7pt, fill: palette.text-tert, style: "italic", font: ("Menlo",))[SINGLE COLOR]
    ],
    // Step 5
    zine-card(variant: "dark")[
      #text(size: 18pt, weight: "bold", fill: palette.bg, font: ("Arial",))[05]
      #h(4pt)
      #text(size: 8pt, fill: palette.bg.transparentize(30%), tracking: 1pt, font: ("Menlo",))[RUN AGAIN]
      #v(3pt)
      #text(size: 10pt, weight: "bold", fill: palette.bg)[换墨筒再印一次]
      #v(3pt)
      #text(size: 7.5pt, fill: palette.bg.transparentize(20%))[#sym.dot.c 换粉墨筒，再过纸\ #sym.dot.c 错位 1--3px = 美学]
      #v(3pt)
      #text(size: 7pt, fill: palette.pink, style: "italic", font: ("Menlo",))[#sym.dot.c 套色错位完成]
      #v(2pt)
      #text(size: 7pt, fill: palette.bg.transparentize(30%), style: "italic", font: ("Menlo",))[OVERPRINT]
    ],
  )

  #v(1fr)
  #zine-footer[P06 #sym.dot.c RISO WORKFLOW][5 STEPS #sym.dot.c N COLORS #sym.dot.c ONE PRINT]
]

// ========== Page 7: Zine Folding ==========

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.blue, height: 36pt),
    text(size: 22pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[一张纸 #sym.arrow.r 一本 ZINE],
  )
  #v(2pt)
  #eyebrow[EIGHT-PAGE FOLD METHOD #sym.dot.c ONE A4 + ONE CUT]
  #v(6pt)

  // Center image with corner cards
  #block(width: 100%, height: 230pt)[
    // Annotation cards at corners
    #place(top + left)[
      #block(width: 24%, inset: 6pt)[
        #zine-card(variant: "blue")[
          #text(size: 12pt, weight: "bold", fill: palette.bg, font: ("Arial",))[01]
          #h(4pt)
          #text(size: 9pt, fill: palette.bg, weight: "bold")[折叠]
          #v(2pt)
          #text(size: 7.5pt, fill: palette.bg.transparentize(15%))[长边对折\ + 短边对折]
          #v(2pt)
          #text(size: 7pt, fill: palette.pink, font: ("Menlo",))[#sym.arrow.r 8 RECTANGLES]
        ]
      ]
    ]
    #place(top + right)[
      #block(width: 24%, inset: 6pt)[
        #zine-card(variant: "pink")[
          #text(size: 12pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[02]
          #h(4pt)
          #text(size: 9pt, fill: palette.text-dark, weight: "bold")[关键剪口]
          #v(2pt)
          #text(size: 7.5pt, fill: palette.text-dark.transparentize(15%))[从对折边沿\ 剪到中心点]
          #v(2pt)
          #text(size: 7pt, fill: palette.text-dark, font: ("Menlo",))[#sym.arrow.r ONE CUT, NO MORE]
        ]
      ]
    ]
    // Center image
    #place(center + horizon)[
      #block(width: 46%, height: 200pt, clip: true)[
        #image("images/zine_folding_hands.png", width: 100%, height: 100%, fit: "cover")
      ]
    ]
    #place(bottom + left)[
      #block(width: 24%, inset: 6pt)[
        #zine-card(variant: "mustard")[
          #text(size: 12pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[03]
          #h(4pt)
          #text(size: 9pt, fill: palette.text-dark, weight: "bold")[组装]
          #v(2pt)
          #text(size: 7.5pt, fill: palette.text-dark.transparentize(15%))[双手两端\ 往中心推]
          #v(2pt)
          #text(size: 7pt, fill: palette.text-dark, font: ("Menlo",))[#sym.arrow.r POPS INTO BOOKLET]
        ]
      ]
    ]
    #place(bottom + right)[
      #block(width: 24%, inset: 6pt)[
        #zine-card(variant: "cream")[
          #text(size: 12pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[04]
          #h(4pt)
          #text(size: 9pt, fill: palette.text-dark, weight: "bold")[填内容]
          #v(2pt)
          #text(size: 7.5pt, fill: palette.text-sec)[手写 / 打字\ 拼贴 / 漫画]
          #v(2pt)
          #text(size: 7pt, fill: palette.pink, font: ("Menlo",))[NO RULES]
        ]
      ]
    ]
  ]

  #v(4pt)
  // Bottom banner
  #zine-card(variant: "mustard")[
    #text(size: 9pt, fill: palette.text-dark, weight: "bold")[硬约束 > 折叠 zine 的总页数必须是 4 的倍数 (8 / 12 / 16 / 20 ...)]
    #h(1fr)
    #text(size: 8pt, fill: palette.text-dark, font: ("Menlo",))[PAGES = 4 #sym.times INTEGER]
  ]

  #v(1fr)
  #zine-footer[P07 #sym.dot.c FOLD AN A4 INTO 8 PAGES][ONE PAGE #sym.dot.c ONE WHIM]
]

// ========== Page 8: Content Types ==========


#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.blue, height: 36pt),
    text(size: 22pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[你能填的东西 > 6 种内容],
  )
  #v(2pt)
  #eyebrow[SIX CONTENT TYPES #sym.dot.c THERE ARE NO MISTAKES, JUST WHIMS]
  #v(2pt)
  #line(length: 100%, stroke: 1.5pt + palette.border)
  #v(6pt)

  // 2x3 icon grid
  #grid(columns: (1fr, 1fr, 1fr), rows: (auto, auto), column-gutter: 6pt, row-gutter: 6pt,
    // Row 1
    zine-card(variant: "cream")[
      #grid(columns: (1fr, auto),
        text(size: 26pt, fill: palette.blue, weight: "bold")[/],
        text(size: 22pt, fill: palette.pink, weight: "bold", font: ("Arial",))[01],
      )
      #v(4pt)
      #text(size: 12pt, weight: "bold", fill: palette.text-dark)[草图 / 漫画]
      #v(2pt)
      #eyebrow[SKETCHES & MINI-COMICS]
      #v(2pt)
      #line(length: 30pt, stroke: 1pt + palette.border)
      #v(3pt)
      #text(size: 8.5pt, fill: palette.text-dark)[涂鸦、4 格漫画、手绘日记\ 字丑也行，构图弱也行]
      #v(2pt)
      #text(size: 8pt, fill: palette.pink, weight: "bold")[画得不像 = 风格]
    ],
    zine-card(variant: "pink")[
      #grid(columns: (1fr, auto),
        text(size: 26pt, fill: palette.text-dark, weight: "bold")[#sym.ast],
        text(size: 22pt, fill: palette.pink.darken(30%), weight: "bold", font: ("Arial",))[02],
      )
      #v(4pt)
      #text(size: 12pt, weight: "bold", fill: palette.text-dark)[诗 / 宣言 / 短文]
      #v(2pt)
      #text(size: 7pt, fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[POETRY & MANIFESTOS]
      #v(2pt)
      #line(length: 30pt, stroke: 1pt + palette.text-dark)
      #v(3pt)
      #text(size: 8.5pt, fill: palette.text-dark)[100 字宣言、一句口号、一首诗\ Riot Grrrl Manifesto 就是范式]
      #v(2pt)
      #text(size: 8pt, fill: palette.blue, weight: "bold")[短而准 > 长而虚]
    ],
    zine-card(variant: "mustard")[
      #grid(columns: (1fr, auto),
        text(size: 26pt, fill: palette.text-dark, weight: "bold")[#sym.suit.club],
        text(size: 22pt, fill: palette.text-dark.transparentize(30%), weight: "bold", font: ("Arial",))[03],
      )
      #v(4pt)
      #text(size: 12pt, weight: "bold", fill: palette.text-dark)[食谱 + 插图]
      #v(2pt)
      #text(size: 7pt, fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[RECIPES & HOW-TOS]
      #v(2pt)
      #line(length: 30pt, stroke: 1pt + palette.text-dark)
      #v(3pt)
      #text(size: 8.5pt, fill: palette.text-dark)[外婆的腌菜配方 + 手绘工具\ "如何修自行车"教学]
      #v(2pt)
      #text(size: 8pt, fill: palette.text-dark, weight: "bold")[日常实用 = 最普及的形式]
    ],
    // Row 2
    zine-card(variant: "cream")[
      #grid(columns: (1fr, auto),
        text(size: 26pt, fill: palette.blue, weight: "bold")[#sym.square.filled],
        text(size: 22pt, fill: palette.pink, weight: "bold", font: ("Arial",))[04],
      )
      #v(4pt)
      #text(size: 12pt, weight: "bold", fill: palette.text-dark)[家庭照片 + 私人写作]
      #v(2pt)
      #eyebrow[PHOTOS & PERSONAL WRITING]
      #v(2pt)
      #line(length: 30pt, stroke: 1pt + palette.border)
      #v(3pt)
      #text(size: 8.5pt, fill: palette.text-dark)[老照片复印件 + 旁注\ 家族故事 / 旅行札记]
      #v(2pt)
      #text(size: 8pt, fill: palette.pink, weight: "bold")[主权 > 隐私]
    ],
    zine-card(variant: "blue")[
      #grid(columns: (1fr, auto),
        text(size: 26pt, fill: palette.bg, weight: "bold")[#sym.suit.diamond],
        text(size: 22pt, fill: palette.pink, weight: "bold", font: ("Arial",))[05],
      )
      #v(4pt)
      #text(size: 12pt, weight: "bold", fill: palette.bg)[拼贴 + 混合媒材]
      #v(2pt)
      #text(size: 7pt, fill: palette.bg.transparentize(30%), tracking: 1pt, font: ("Menlo",))[COLLAGE & MIXED MEDIA]
      #v(2pt)
      #line(length: 30pt, stroke: 1pt + palette.bg.transparentize(40%))
      #v(3pt)
      #text(size: 8.5pt, fill: palette.bg.transparentize(10%))[杂志撕页 + 胶带 + 印章\ 字典页 + 票据 + 蕾丝]
      #v(2pt)
      #text(size: 8pt, fill: palette.pink, weight: "bold")[物质感 = 复印机救不了]
    ],
    zine-card(variant: "pink")[
      #grid(columns: (1fr, auto),
        text(size: 26pt, fill: palette.text-dark, weight: "bold")[#sym.triangle.t],
        text(size: 22pt, fill: palette.text-dark.transparentize(30%), weight: "bold", font: ("Arial",))[06],
      )
      #v(4pt)
      #text(size: 12pt, weight: "bold", fill: palette.text-dark)[实验性视觉]
      #v(2pt)
      #text(size: 7pt, fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[EXPERIMENTAL VISUALS]
      #v(2pt)
      #line(length: 30pt, stroke: 1pt + palette.text-dark)
      #v(3pt)
      #text(size: 8.5pt, fill: palette.text-dark)[纯色块、纯纹理、纯字\ 空白页 = 阅读节奏]
      #v(2pt)
      #text(size: 8pt, fill: palette.text-dark, weight: "bold")[没有信息 = 一种信息]
    ],
  )

  #v(1fr)
  #zine-footer[P08 #sym.dot.c 6 CONTENT TYPES][PICK ONE #sym.dot.c PICK ALL #sym.dot.c MAKE IT YOURS]
]

// ========== Page 9: Jimbocho ==========

#hero-slide("images/jimbocho_hero.png")[
  // Dark scrim
  #place(top + left, block(width: 100%, height: 100%,
    fill: gradient.linear(
      palette.text-dark.transparentize(20%),
      palette.text-dark.transparentize(50%),
      palette.text-dark.transparentize(30%),
    )))

  // Part label at top
  #place(top + left, dx: 5%, dy: 5%)[
    #text(size: 7pt, fill: palette.bg.transparentize(30%), tracking: 1.5pt, font: ("Menlo",))[PART 04 #sym.dot.c 全球独立书店 NO.1 -- 东京]
  ]

  // Title
  #place(top + left, dx: 5%, dy: 10%)[
    #text(size: 60pt, weight: "black", fill: palette.bg,
      font: ("Heiti SC",))[神保町]
    #v(2pt)
    #text(size: 28pt, weight: "bold", fill: palette.bg,
      font: ("Arial",), tracking: 4pt, style: "italic")[JIMBOCHO]
    #v(4pt)
    #text(size: 10pt, fill: palette.bg.transparentize(15%))[全球最大旧书街之一 #sym.dot.c 130--180 家书店]
  ]

  // TIME OUT badge at top-right
  #place(top + right, dx: -5%, dy: 6%)[
    #block(fill: palette.pink, inset: (x: 14pt, y: 8pt), radius: 0pt)[
      #text(size: 9pt, fill: palette.text-dark, weight: "bold", font: ("Arial",))[TIME OUT 2025]
      #v(2pt)
      #text(size: 8pt, fill: palette.text-dark)[全球最酷街区]
      #v(1pt)
      #text(size: 7pt, fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[COOLEST NEIGHBORHOOD]
    ]
  ]

  // Info cards at bottom - 3 cards with different content
  #place(bottom + left, dx: 5%, dy: -10%)[
    #block(width: 90%)[
      #grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt,
        // Card 1: Big number
        zine-card(variant: "dark")[
          #text(size: 28pt, fill: palette.pink, weight: "bold", font: ("Arial",))[130-180]
          #v(2pt)
          #text(size: 9pt, fill: palette.bg, weight: "bold")[家书店密集分布]
          #v(2pt)
          #text(size: 7pt, fill: palette.bg.transparentize(30%), font: ("Menlo",))[BOOKSTORES IN ONE DISTRICT]
          #v(2pt)
          #text(size: 7pt, fill: palette.bg.transparentize(20%))[靖国通 #sym.times 白山通交叉]
        ],
        // Card 2: Three key stores
        zine-card(variant: "dark")[
          #text(size: 10pt, fill: palette.pink, weight: "bold")[1875 #sym.dot.c 1902 #sym.dot.c 2015]
          #v(2pt)
          #text(size: 9pt, fill: palette.bg, weight: "bold")[三家代表性老店 / 奇店]
          #v(3pt)
          #text(size: 7.5pt, fill: palette.bg.transparentize(15%))[#sym.dot.c Takayama Honten (1875)\ #sym.dot.c Kitazawa English Books (1902)\ #sym.dot.c Morioka Shoten (2015) -- 一周一本]
        ],
        // Card 3: Utrecht x Harajuku
        zine-card(variant: "pink")[
          #text(size: 12pt, fill: palette.text-dark, weight: "bold", font: ("Arial",))[UTRECHT #sym.times 原宿]
          #v(2pt)
          #text(size: 8pt, fill: palette.text-dark)[日本最大独立 zine 收藏之一]
          #v(2pt)
          #text(size: 7.5pt, fill: palette.text-dark.transparentize(15%))[毛毡灯片 / 安静阅读\ 温暖灯光 + 实验精神]
          #v(2pt)
          #text(size: 7pt, fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[ZINE PILGRIMAGE]
        ],
      )
    ]
  ]

  // Footer
  #zine-footer-auto[P09 #sym.dot.c TOKYO JIMBOCHO][WORLD'S LARGEST USED-BOOK DISTRICT]
]

// ========== Page 10: Three Cities ==========

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.blue, height: 36pt),
    text(size: 22pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[三座城市 #sym.dot.c 三种姿态],
  )
  #v(2pt)
  #eyebrow[THREE CITIES #sym.dot.c THREE BOOKSTORE TEMPERAMENTS]
  #v(6pt)

  // Triptych image
  #block(width: 100%, height: 120pt, clip: true)[
    #image("images/three_cities_triptych.png", width: 100%, height: 100%, fit: "cover")
  ]

  #v(6pt)

  // Three pillar cards
  #grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt,
    // Paris
    block(width: 100%, inset: 12pt, radius: 0pt, fill: palette.bg-alt,
      stroke: (top: 4pt + palette.blue, rest: none),
    )[
      #grid(columns: (1fr, auto),
        text(size: 18pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[PARIS],
        text(size: 9pt, fill: palette.pink, weight: "bold")[巴黎],
      )
      #v(4pt)
      #text(size: 11pt, weight: "bold", fill: palette.text-dark)[Shakespeare and Company]
      #v(2pt)
      #text(size: 7pt, fill: palette.text-sec, tracking: 1pt, font: ("Menlo",))[37 RUE DE LA BUCHERIE #sym.dot.c EST 1951]
      #v(4pt)
      #text(size: 8.5pt, fill: palette.text-dark)[
        #sym.dot.c 原址 12 rue de l'Odeon\ Sylvia Beach 1919 创办\
        #sym.dot.c 现址 1951 George Whitman\ 接纳数千 "TUMBLEWEEDS"\
        #sym.dot.c 住宿条件：每天读 1 小时\ 写一页自传 + 帮工
      ]
      #v(3pt)
      #text(size: 8pt, fill: palette.pink, weight: "bold")[#sym.arrow.r 书店 = 写作者收容所]
    ],
    // London
    block(width: 100%, inset: 12pt, radius: 0pt, fill: palette.bg-alt,
      stroke: (top: 4pt + palette.pink, rest: none),
    )[
      #grid(columns: (1fr, auto),
        text(size: 18pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[LONDON],
        text(size: 9pt, fill: palette.pink, weight: "bold")[伦敦],
      )
      #v(4pt)
      #text(size: 11pt, weight: "bold", fill: palette.text-dark)[Daunt + Word on the Water]
      #v(2pt)
      #text(size: 7pt, fill: palette.text-sec, tracking: 1pt, font: ("Menlo",))[MARYLEBONE + REGENT'S CANAL]
      #v(4pt)
      #text(size: 8.5pt, fill: palette.text-dark)[
        #sym.dot.c DAUNT (Marylebone)\ 爱德华建筑 + 橡木阳台\ + 彩色玻璃 + 按国家分类\
        #sym.dot.c WORD ON THE WATER\ 1920s 荷兰运河船\ 皮椅 / 老打字机 / 火炉
      ]
      #v(3pt)
      #text(size: 8pt, fill: palette.pink, weight: "bold")[#sym.arrow.r 书店 = 场景即体验]
    ],
    // New York
    block(width: 100%, inset: 12pt, radius: 0pt, fill: palette.bg-alt,
      stroke: (top: 4pt + palette.blue, rest: none),
    )[
      #grid(columns: (1fr, auto),
        text(size: 18pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[NEW YORK],
        text(size: 9pt, fill: palette.pink, weight: "bold")[纽约],
      )
      #v(4pt)
      #text(size: 11pt, weight: "bold", fill: palette.text-dark)[Strand + Yu and Me Books]
      #v(2pt)
      #text(size: 7pt, fill: palette.text-sec, tracking: 1pt, font: ("Menlo",))[BROADWAY + CHINATOWN]
      #v(4pt)
      #text(size: 8.5pt, fill: palette.text-dark)[
        #sym.dot.c STRAND (1927)\ 2,500,000 册藏书\ 自称 "18 英里书架"\
        #sym.dot.c YU AND ME BOOKS (2021)\ 华埠首家亚裔女性书店\ 2023 火灾后社区众筹重建
      ]
      #v(3pt)
      #text(size: 8pt, fill: palette.pink, weight: "bold")[#sym.arrow.r 书店 = 社区基础设施]
    ],
  )

  #v(1fr)
  #zine-footer[P10 #sym.dot.c PARIS #sym.dot.c LONDON #sym.dot.c NEW YORK][收容所 / 场景 / 基础设施]
]

// ========== Page 11: Berlin ==========

#hero-slide("images/berlin_bucherbogen.png")[
  // Scrim
  #place(top + left, block(width: 100%, height: 100%,
    fill: gradient.linear(
      palette.text-dark.transparentize(15%),
      palette.text-dark.transparentize(45%),
      palette.text-dark.transparentize(20%),
    )))

  // Part label at top
  #place(top + left, dx: 5%, dy: 5%)[
    #text(size: 7pt, fill: palette.bg.transparentize(30%), tracking: 1.5pt, font: ("Menlo",))[PART 04 #sym.dot.c 全球独立书店 NO.4 -- 柏林]
  ]

  // Large centered title
  #place(center + horizon, dy: -8%)[
    #set align(center)
    // Pink misregistered shadow for riso effect
    #place(dx: 2pt, dy: 2pt)[
      #text(size: 60pt, weight: "black", fill: palette.pink.transparentize(50%),
        font: ("Arial",), tracking: 5pt)[BUCHERBOGEN]
    ]
    #text(size: 60pt, weight: "black", fill: palette.bg,
      font: ("Arial",), tracking: 5pt)[BUCHERBOGEN]
    #v(6pt)
    #text(size: 10pt, fill: palette.bg.transparentize(10%), tracking: 2pt, font: ("Menlo",))[柏林 #sym.dot.c BERLIN #sym.dot.c S-BAHN ARCHES]
  ]

  // Bottom-left info block
  #place(bottom + left, dx: 5%, dy: -14%)[
    #block(fill: palette.text-dark.transparentize(30%), inset: (x: 12pt, y: 8pt), radius: 0pt)[
      #text(size: 11pt, fill: palette.bg, weight: "bold")[藏在 S-BAHN 高架桥下的拱顶]
      #v(3pt)
      #text(size: 8pt, fill: palette.bg.transparentize(15%))[一书店/拱顶/砖墙 -- 专攻艺术 / 设计 / 摄影 / 电影 / 建筑书]
      #v(2pt)
      #text(size: 8pt, fill: palette.bg.transparentize(20%))[柏林"精准主题书店"的范式：不求全面，要绝对]
      #v(2pt)
      #text(size: 7.5pt, fill: palette.pink)[#sym.arrow.r 一个主题越精越好]
    ]
  ]

  // Bottom-right blue card
  #place(bottom + right, dx: -5%, dy: -14%)[
    #block(fill: palette.blue, inset: (x: 14pt, y: 10pt), radius: 0pt)[
      #text(size: 18pt, fill: palette.bg, weight: "bold", font: ("Arial",))[5 SUBJECTS]
      #v(3pt)
      #text(size: 9pt, fill: palette.bg.transparentize(10%))[艺术/设计/摄影/电影/建筑]
      #v(2pt)
      #text(size: 7pt, fill: palette.bg.transparentize(25%), tracking: 1pt, font: ("Menlo",))[UNDER ONE ARCHED VAULT]
    ]
  ]

  // Footer
  #zine-footer-auto[P11 #sym.dot.c BERLIN BUCHERBOGEN][EUROPEAN INDIE BOOKSTORE FINALE]
]

// ========== Page 12: China Bookstore Map ==========

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.blue, height: 36pt),
    text(size: 20pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[中国大陆独立书店地图 (ZINE 倾向)],
  )
  #v(2pt)
  #eyebrow[15 STORES #sym.dot.c #sym.star ZINE INTENSITY #sym.dot.c MAINLAND CHINA #sym.dot.c CURATED 2026]
  #v(4pt)

  // Table header
  #block(fill: palette.bg-alt, width: 100%, inset: (x: 8pt, y: 6pt), radius: 0pt)[
    #grid(columns: (22%, 12%, 50%, 16%), column-gutter: 4pt,
      text(size: 8pt, weight: "bold", fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[书店 #sym.dot.c STORE],
      text(size: 8pt, weight: "bold", fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[城市 #sym.dot.c CITY],
      text(size: 8pt, weight: "bold", fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[特色 #sym.dot.c CHARACTER],
      align(center, text(size: 8pt, weight: "bold", fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[ZINE 倾向]),
    )
  ]

  // Table rows
  #{
    let rows = (
      ("香蕉鱼书店", "上海", "首家专注独立出版，推广 zine，自营 Riso 工作室", sym.star.filled + sym.star.filled + sym.star.filled),
      ("假杂志", "宁波", "国内最早独立摄影出版机构，摄 zine 圣地", sym.star.filled + sym.star.filled + sym.star.filled),
      ("野狗", "郑州", "精选 200+ 国内外独立杂志 / 艺术出版物", sym.star.filled + sym.star.filled + sym.star.filled),
      ("一片旧店 / BOOKMART", "舟山", "艺术书 / 摄影集 / zine / 独立出版物全方位", sym.star.filled + sym.star.filled + sym.star.filled),
      ("Combo", "武汉", "设计师 / 插画师 / 艺术家作品展示空间", sym.star.filled + sym.star.filled),
      ("Protopaper", "西安", "设计工作室转书店，社区艺术连接", sym.star.filled + sym.star.filled),
      ("Jetlag Books", "北京 · 三里屯", "国际期刊 + 创意品牌时尚原文书，红点品牌奖", sym.star.filled),
      ("言 YAN-BOOKS", "北京", "设计 / 生活方式 / 国际杂志", sym.star.filled),
      ("群岛 BOOKS", "上海", "建筑 / 城市 / 泛设计为主，书桌式陈列", sym.star.filled),
      ("单向空间", "北京", "2006 创办，名取自本雅明《单向街》", sym.dash.em),
      ("三味书屋", "北京 · 长安街", "北京第一家民营书店，每一本书都是挑过的", sym.dash.em),
      ("博尔赫斯", "广州", "文学为主，兼及历史 / 哲学 / 艺术", sym.dash.em),
      ("目田书店", "长沙", "社区文化空间，好书精选", sym.dash.em),
      ("牡蛎", "杭州", "社区书店，文学 / 哲学 / 诗，兼二手", sym.dash.em),
      ("麦田书店", "昆明", "艺术文学，云南地方主题，黑胶唱片", sym.dash.em),
    )
    for (i, row) in rows.enumerate() {
      let stripe = calc.odd(i)
      let (store, city, char, level) = row
      let level-color = if type(level) == str { palette.text-sec }
        else if repr(level).contains("star.filled") and repr(level).len() > 40 { palette.pink }
        else if repr(level).contains("star.filled") { palette.blue }
        else { palette.text-sec }
      // Determine color based on index
      let lc = if i < 4 { palette.pink }
        else if i < 6 { palette.mustard }
        else if i < 9 { palette.blue }
        else { palette.text-sec }
      let bg = if stripe { palette.bg-alt.transparentize(60%) } else { white.transparentize(96%) }
      block(fill: bg, width: 100%, inset: (x: 8pt, y: 5pt), radius: 0pt, below: 0pt, above: 0pt,
        stroke: (bottom: 0.5pt + palette.border.transparentize(85%)),
      )[
        #grid(columns: (22%, 12%, 50%, 16%), column-gutter: 4pt,
          text(size: 8.5pt, weight: "bold", fill: palette.text-dark)[#store],
          text(size: 8.5pt, fill: palette.text-dark)[#city],
          text(size: 8.5pt, fill: palette.text-sec)[#char],
          align(center, text(size: 8.5pt, weight: "bold", fill: lc)[#level]),
        )
      ]
    }
  }

  #v(4pt)
  #text(size: 7pt, fill: palette.text-sec)[LEGEND: #h(6pt) #text(fill: palette.pink, weight: "bold")[#sym.star.filled#sym.star.filled#sym.star.filled] 核心 zine 圣地 #h(12pt) #text(fill: palette.mustard, weight: "bold")[#sym.star.filled#sym.star.filled] 独立出版兼营 #h(12pt) #text(fill: palette.blue, weight: "bold")[#sym.star.filled] 国际杂志为主 #h(12pt) #text(fill: palette.text-sec)[#sym.dash.em 文学 / 综合书店]]
  #v(1fr)
  #zine-footer[P12 #sym.dot.c MAINLAND CHINA INDIE BOOKSTORE MAP][CURATED 2026 #sym.dot.c SOURCED FROM 数英 / 搜狐 / 知乎]
]

// ========== Page 13: China Art Book Fair ==========

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.blue, height: 36pt),
    text(size: 22pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[中国艺术书展双子星],
  )
  #v(2pt)
  #eyebrow[SHANGHAI HOSTS THE MOST #sym.dot.c NEW SHOPS PUBLISH HERE FIRST]
  #v(6pt)

  #grid(columns: (30%, 70%), column-gutter: 6pt,
    // Left image
    block(width: 100%, height: 276pt, clip: true, radius: 0pt)[
      #image("images/zine_fair_scene.png", width: 100%, height: 100%, fit: "cover")
      #place(bottom + left)[
        #block(fill: palette.blue, inset: (x: 6pt, y: 3pt))[
          #text(size: 7pt, fill: palette.bg, font: ("Menlo",), tracking: 1pt)[BOOTH AISLE #sym.dot.c SHANGHAI #sym.dot.c 2026]
        ]
      ]
    ],
    // Right cards
    [
      // abC card
      #block(width: 100%, inset: 12pt, radius: 0pt,
        stroke: (top: 4pt + palette.blue, rest: 0.5pt + palette.border.transparentize(80%)),
        fill: palette.bg,
      )[
        #grid(columns: (1fr, auto),
          text(size: 14pt, weight: "bold", fill: palette.blue, font: ("Arial",), tracking: 1pt)[abC ART BOOK FAIR],
          text(size: 8pt, fill: palette.pink, font: ("Menlo",))[EST. 2015 #sym.dot.c 京沪双城],
        )
        #v(4pt)
        #text(size: 10pt, weight: "bold", fill: palette.text-dark)[art book in China #sym.dot.c 国内最具影响力的艺术书展]
        #v(2pt)
        #text(size: 8pt, fill: palette.text-sec)[推广本土艺术家书 / 独立出版 + 引介国际优秀出版方]
        #v(6pt)
        #grid(columns: (1fr, 1fr, 1fr, 1fr), column-gutter: 4pt,
          zine-card(variant: "blue")[
            #text(size: 16pt, fill: palette.bg, weight: "bold")[145]
            #v(2pt)
            #text(size: 7pt, fill: palette.bg.transparentize(20%))[中国艺术出版方\ + 个人创作者]
          ],
          zine-card(variant: "mustard")[
            #text(size: 16pt, fill: palette.text-dark, weight: "bold")[41]
            #v(2pt)
            #text(size: 7pt, fill: palette.text-dark.transparentize(20%))[国际出版方\ 参展 · 上海]
          ],
          zine-card(variant: "pink")[
            #text(size: 16pt, fill: palette.text-dark, weight: "bold")[10,000+]
            #v(2pt)
            #text(size: 7pt, fill: palette.text-dark.transparentize(20%))[参观人数\ 第 6 届上海]
          ],
          [
            #text(size: 8pt, fill: palette.text-dark)[#sym.arrow.r #text(weight: "bold")[第一影响力]]
            #v(2pt)
            #text(size: 7.5pt, fill: palette.text-sec)[独立出版圈\ 年度风向标]
          ],
        )
      ]

      #v(2pt)

      // UNFOLD card
      #block(width: 100%, inset: 12pt, radius: 0pt,
        stroke: (top: 4pt + palette.text-dark, rest: 0.5pt + palette.border.transparentize(80%)),
        fill: palette.bg,
      )[
        #grid(columns: (1fr, auto),
          text(size: 14pt, weight: "bold", fill: palette.text-dark, font: ("Arial",), tracking: 1pt)[UNFOLD SHANGHAI],
          text(size: 8pt, fill: palette.pink, font: ("Menlo",))[紧随 abC #sym.dot.c 一周后开幕],
        )
        #v(4pt)
        #text(size: 10pt, weight: "bold", fill: palette.text-dark)[UNFOLD Shanghai Art Book Fair #sym.dot.c 第二影响力]
        #v(2pt)
        #text(size: 8pt, fill: palette.text-sec)[摊位费更高，客流更大，票价更亲民，国际 Nieves 等参展]
        #v(6pt)
        #grid(columns: (1fr, 1fr, 1fr), column-gutter: 4pt,
          zine-card(variant: "dark")[
            #text(size: 14pt, fill: palette.bg, weight: "bold")[+1 WEEK]
            #v(2pt)
            #text(size: 7pt, fill: palette.bg.transparentize(20%))[在 abC 上海站之后\ 一周内连票发生]
          ],
          zine-card(variant: "pink")[
            #text(size: 14pt, fill: palette.text-dark, weight: "bold")[SHANGHAI]
            #v(2pt)
            #text(size: 7pt, fill: palette.text-dark.transparentize(20%))[承办中国最多书展\ 每年的城市]
          ],
          [
            #text(size: 8pt, fill: palette.text-dark)[#sym.arrow.r #text(weight: "bold")[实用建议]]
            #v(2pt)
            #text(size: 7.5pt, fill: palette.text-sec)[两周连打 =\ 上海双周朝圣]
          ],
        )
      ]
    ],
  )

  #v(1fr)
  #zine-footer[P13 #sym.dot.c CHINA ART BOOK FAIR TWINS][abC FIRST #sym.dot.c UNFOLD AFTER #sym.dot.c 上海双周]
]

// ========== Page 14: How to Browse ==========

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.blue, height: 36pt),
    text(size: 22pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[进店前的 4 条],
  )
  #v(2pt)
  #eyebrow[HOW TO BROWSE INDIE BOOKSTORES #sym.dot.c UNWRITTEN ETIQUETTE]
  #v(2pt)
  #line(length: 100%, stroke: 1.5pt + palette.border)
  #v(8pt)

  #grid(rows: 4, row-gutter: 10pt,
    rich-numbered-row([01], [看选品 = 看店主], [独立书店的本质是"一个人 / 一群人的精神书架"，选品就是店主在跟你对话], accent: palette.blue, icon-symbol: [#sym.star.filled]),
    rich-numbered-row([02], [至少留 1 小时], [独立书店不是便利店，浏览本身就是产品，在书架前发呆是一种合法消费], accent: palette.pink, icon-symbol: [#sym.circle.filled.small]),
    rich-numbered-row([03], [带现金], [一些小店不接受电子支付，现金还能减少手续费，给店主多留一杯咖啡的利润], accent: palette.mustard, icon-symbol: [#sym.triangle.filled.t]),
    rich-numbered-row([04], [拍照前先问], [多数独立书店对拍照敏感，选品是店主智识，尊重 + 一句招呼 = 通行证], accent: palette.blue, icon-symbol: [#sym.suit.club]),
  )

  #v(8pt)
  // Bottom banner
  #block(fill: palette.blue, width: 100%, inset: (x: 12pt, y: 8pt), radius: 0pt)[
    #text(size: 10pt, fill: palette.bg, weight: "bold")[额外提醒 >] #h(6pt)
    #text(size: 9pt, fill: palette.bg.transparentize(10%))[主流出版社的书随便哪里买都行，在独立书店买独立出版物 / 艺术家自费书，那才是核心目标]
  ]

  #v(1fr)
  #zine-footer[P14 #sym.dot.c 4 RULES BEFORE YOU ENTER][店主 / 时间 / 现金 / 招呼]
]

// ========== Page 15: How to Collect ==========

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.pink, height: 36pt),
    text(size: 22pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[收藏 ZINE 的 4 条],
  )
  #v(2pt)
  #eyebrow[HOW TO COLLECT ZINES #sym.dot.c NO ARCHIVAL PHD REQUIRED]
  #v(2pt)
  #line(length: 100%, stroke: 1.5pt + palette.border)
  #v(8pt)

  #grid(rows: 4, row-gutter: 10pt,
    rich-numbered-row([01], [从一本起步], [不要一开始就 100 本目标，找你最关心的一个主题，滚雪球收藏], accent: palette.pink, icon-symbol: [#sym.suit.heart]),
    rich-numbered-row([02], [用塑料封套保护], [zine 是一次性印刷，二次印刷罕见，一本破损 = 一本绝版], accent: palette.blue, icon-symbol: [#sym.square.filled]),
    rich-numbered-row([03], [跟踪作者 / 出版方 Instagram], [新刊首发是赶圈机会，100 份卖完就没了，第二天朋友圈截图也没用], accent: palette.mustard, icon-symbol: [#sym.at]),
    rich-numbered-row([04], [参加 abC / UNFOLD], [书展现场 = 新刊首发 + 作者签售，一年一次的物理朝圣], accent: palette.pink, icon-symbol: [#sym.suit.diamond]),
  )

  #v(8pt)
  // Bottom banner
  #block(fill: palette.pink, width: 100%, inset: (x: 12pt, y: 8pt), radius: 0pt)[
    #text(size: 10pt, fill: palette.text-dark, weight: "bold")[长期玩家秘诀 >] #h(6pt)
    #text(size: 9pt, fill: palette.text-dark.transparentize(10%))[给自己定一个"我只收集 X 主题的 zine" 的窄锚点，5 年后你会拥有这个主题的小型博物馆]
  ]

  #v(1fr)
  #zine-footer[P15 #sym.dot.c 4 RULES FOR COLLECTING ZINES][START NARROW #sym.dot.c GO DEEP #sym.dot.c GO LONG]
]

// ========== Page 16: Action Checklist ==========

#slide(config: config-page(margin: (top: 1.5em, bottom: 1em, x: 2em), header: none, footer: none))[
  // Centered title
  #align(center)[
    #text(size: 28pt, weight: "bold", fill: palette.text-dark,
      font: ("Heiti SC",))[你的第一本 ZINE]
    #v(4pt)
    #eyebrow[YOUR FIRST ZINE #sym.dot.c 4 STEPS #sym.dot.c ONE WEEKEND]
  ]
  #v(4pt)
  #line(length: 100%, stroke: 2pt + palette.border)
  #v(4pt)

  // Four steps: circles with arrows, then labels, then text details
  // Row 1: Circles with arrows between them
  #grid(columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr, 1fr), column-gutter: 4pt, align: center + horizon,
    step-circle([01], size: 60pt, variant: "blue"),
    step-arrow(),
    step-circle([02], size: 60pt, variant: "pink"),
    step-arrow(),
    step-circle([03], size: 60pt, variant: "pink"),
    step-arrow(),
    step-circle([04], size: 60pt, variant: "dark"),
    [],
  )

  #v(4pt)

  // Row 2: Labels (no arrows here, aligned below circles)
  #grid(columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr, 1fr), column-gutter: 4pt, align: horizon,
    zine-card(variant: "mustard")[
      #set align(center)
      #text(size: 8pt, fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[CHOOSE]
    ],
    [],
    zine-card(variant: "mustard")[
      #set align(center)
      #text(size: 8pt, fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[FOLD]
    ],
    [],
    zine-card(variant: "mustard")[
      #set align(center)
      #text(size: 8pt, fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[FILL]
    ],
    [],
    zine-card(variant: "pink")[
      #set align(center)
      #text(size: 8pt, fill: palette.text-dark, tracking: 1pt, font: ("Menlo",))[SHARE]
    ],
    // Result text
    align(center)[
      #text(size: 8pt, fill: palette.text-sec)[结果]
      #v(2pt)
      #text(size: 16pt, weight: "bold", fill: palette.pink, font: ("Arial",))[YOU\ ARE A]
      #v(2pt)
      #text(size: 20pt, weight: "bold", fill: palette.text-dark, font: ("Arial",))[PUBLISHER]
    ],
  )

  #v(4pt)

  // Row 3: Text details below
  #grid(columns: (1fr, auto, 1fr, auto, 1fr, auto, 1fr, 1fr), column-gutter: 4pt, align: top,
    align(center)[
      #text(size: 12pt, weight: "bold", fill: palette.text-dark)[选一个主题]
      #v(2pt)
      #text(size: 8pt, fill: palette.text-sec)[真心关心的\ 不必宏大]
      #v(3pt)
      #text(size: 7.5pt, fill: palette.pink)[小猫 / 早餐 / 通勤路]
    ],
    [],
    align(center)[
      #text(size: 12pt, weight: "bold", fill: palette.text-dark)[折一张 A4]
      #v(2pt)
      #text(size: 8pt, fill: palette.text-sec)[用 P07 方法\ 8 页 + 1 个剪口]
      #v(3pt)
      #text(size: 7.5pt, fill: palette.pink)[#sym.approx 30 秒完成]
    ],
    [],
    align(center)[
      #text(size: 12pt, weight: "bold", fill: palette.text-dark)[填 8 页]
      #v(2pt)
      #text(size: 8pt, fill: palette.text-sec)[手写 / 拼贴\ / 复印旧照片]
      #v(3pt)
      #text(size: 7.5pt, fill: palette.pink)[第一本 = 粗糙就对了]
    ],
    [],
    align(center)[
      #text(size: 12pt, weight: "bold", fill: palette.text-dark)[印 10 份送出去]
      #v(2pt)
      #text(size: 8pt, fill: palette.text-sec)[5 份给朋友\ 5 份寄独立书店]
      #v(3pt)
      #text(size: 7.5pt, fill: palette.pink)[这一刻你就成 zine 出版者了]
    ],
    [],
  )

  #v(6pt)
  // Bottom banner
  #zine-card(variant: "dark")[
    #text(size: 10pt, fill: palette.bg, weight: "bold")["zine 出版者"的门槛 = 寄出第一本的那一秒，不是商业注册，不是 ISBN，不是销量]
  ]

  #v(1fr)
  #zine-footer[P16 #sym.dot.c YOUR FIRST ZINE IN 4 STEPS][CHOOSE #sym.arrow.r FOLD #sym.arrow.r FILL #sym.arrow.r SHARE]
]

// ========== Page 17: Sources ==========

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    title-bar(color: palette.pink, height: 36pt),
    text(size: 24pt, weight: "bold", fill: palette.text-dark,
      font: ("Arial",), tracking: 1pt)[SOURCES & CREDITS],
  )
  #v(2pt)
  #eyebrow[PRIMARY REFERENCES #sym.dot.c 20 SOURCES #sym.dot.c WIKIPEDIA + INDIE PRESS + 中文社区]
  #v(4pt)

  // Three column headers
  #grid(columns: (1fr, 1fr, 1fr), column-gutter: 6pt,
    zine-card(variant: "cream")[
      #text(size: 10pt, weight: "bold", fill: palette.text-dark)[ZINE #sym.dot.c 简史 #sym.dot.c 制作]
    ],
    zine-card(variant: "pink")[
      #text(size: 10pt, weight: "bold", fill: palette.text-dark)[RISO #sym.dot.c 全球书店]
    ],
    zine-card(variant: "cream")[
      #text(size: 10pt, weight: "bold", fill: palette.text-dark)[中文 #sym.dot.c 书店 #sym.dot.c 书展]
    ],
  )
  #v(4pt)

  // Source lists in three columns
  #grid(columns: (1fr, 1fr, 1fr), column-gutter: 12pt,
    // Column 1
    [
      #set text(size: 7.5pt)
      #grid(rows: 6, row-gutter: 6pt,
        [#text(fill: palette.pink, weight: "bold")[01] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[Wikipedia #sym.dot.c Zine]\ #text(fill: palette.text-sec)[en.wikipedia.org/wiki/Zine]],
        [#text(fill: palette.pink, weight: "bold")[02] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[Wikipedia #sym.dot.c Riot grrrl]\ #text(fill: palette.text-sec)[en.wikipedia.org/wiki/Riot_grrrl]],
        [#text(fill: palette.pink, weight: "bold")[03] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[JSTOR Daily -- Start a Riot]\ #text(fill: palette.text-sec)[daily.jstor.org/start-a-riot-and-a-zine-grrrl]],
        [#text(fill: palette.pink, weight: "bold")[04] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[UNC Chapel Hill #sym.dot.c Brief History]\ #text(fill: palette.text-sec)[blogs.lib.unc.edu/rbc/2017/10/25]],
        [#text(fill: palette.pink, weight: "bold")[05] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[The Creative Independent]\ #text(fill: palette.text-sec)[thecreativeindependent.com/guides/how-to-make-a-zine]],
        [#text(fill: palette.pink, weight: "bold")[06] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[Book Riot #sym.dot.c Beginner's Guide]\ #text(fill: palette.text-sec)[bookriot.com/how-to-make-a-zine]],
      )
    ],
    // Column 2
    [
      #set text(size: 7.5pt)
      #grid(rows: 7, row-gutter: 6pt,
        [#text(fill: palette.pink, weight: "bold")[07] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[My Modern Met #sym.dot.c Riso Renaissance]\ #text(fill: palette.text-sec)[mymodernmet.com/risograph-printer]],
        [#text(fill: palette.pink, weight: "bold")[08] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[KPBS #sym.dot.c Risograph revival podcast]\ #text(fill: palette.text-sec)[kpbs.org/podcasts/the-finest/risograph-revival]],
        [#text(fill: palette.pink, weight: "bold")[09] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[It's Nice That #sym.dot.c Tokyo Risograph]\ #text(fill: palette.text-sec)[itsnicethat.com/articles/the-view-from-tokyo-risograph]],
        [#text(fill: palette.pink, weight: "bold")[10] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[AFAR #sym.dot.c 17 Independent Bookstores]\ #text(fill: palette.text-sec)[afar.com/magazine/the-best-independent-bookstores]],
        [#text(fill: palette.pink, weight: "bold")[11] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[Wikipedia #sym.dot.c Jimbocho Book Town]\ #text(fill: palette.text-sec)[en.wikipedia.org/wiki/Jimbocho_Book_Town]],
        [#text(fill: palette.pink, weight: "bold")[12] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[Wikipedia #sym.dot.c Shakespeare and Company]\ #text(fill: palette.text-sec)[en.wikipedia.org/wiki/Shakespeare_and_Company]],
        [#text(fill: palette.pink, weight: "bold")[13] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[Time Out Tokyo #sym.dot.c Best bookstores]\ #text(fill: palette.text-sec)[timeout.com/tokyo/shopping/the-best-bookstores]],
      )
    ],
    // Column 3
    [
      #set text(size: 7.5pt)
      #grid(rows: 7, row-gutter: 6pt,
        [#text(fill: palette.pink, weight: "bold")[14] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[数英 #sym.dot.c 国内 13 家独立书店漫游指南]\ #text(fill: palette.text-sec)[digitaling.com/articles/701483]],
        [#text(fill: palette.pink, weight: "bold")[15] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[搜狐 #sym.dot.c 北京最棒独立书店]\ #text(fill: palette.text-sec)[sohu.com/a/234189890_554564]],
        [#text(fill: palette.pink, weight: "bold")[16] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[UNFOLD Shanghai #sym.dot.c Official]\ #text(fill: palette.text-sec)[shanghaiartbookfair.com]],
        [#text(fill: palette.pink, weight: "bold")[17] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[abC Art Book Fair #sym.dot.c Official EN]\ #text(fill: palette.text-sec)[artbookinchina.com/en]],
        [#text(fill: palette.pink, weight: "bold")[18] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[Sixth Tone #sym.dot.c Art Book Fair Bubble]\ #text(fill: palette.text-sec)[sixthtone.com/news/1008799]],
        [#text(fill: palette.pink, weight: "bold")[19] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[Nippon.com #sym.dot.c 神保町 Jimbocho]\ #text(fill: palette.text-sec)[nippon.com/en/japan-topics/b11003]],
        [#text(fill: palette.pink, weight: "bold")[20] #h(4pt) #text(fill: palette.text-dark, weight: "bold")[Wikimedia Commons #sym.dot.c 图片素材]\ #text(fill: palette.text-sec)[commons.wikimedia.org #sym.dot.c CC BY 2.0]],
      )
    ],
  )

  #v(4pt)

  // Credits banner
  #zine-card(variant: "pink")[
    #text(size: 9pt, fill: palette.text-dark, weight: "bold")[致谢 >] #h(6pt)
    #text(size: 8pt, fill: palette.text-dark)[研究 / 排版 / 视觉 由 PPT Master + Gemini 3.1 Flash Image + screen-print #sym.times duotone 风格生成]
    #v(2pt)
    #text(size: 7.5pt, fill: palette.text-dark.transparentize(20%))[参考图像取自 Wikimedia Commons (CC BY 2.0)；AI 图像为本 deck 专属合成，不构成任何品牌 / 商标关联]
  ]

  #v(1fr)
  #zine-footer[P17 #sym.dot.c SOURCES & CREDITS][RESEARCHED 2026-05-17 #sym.dot.c CHECKED LIVE]
]

// ========== Page 18: Outro ==========

#ending-slide(bg-image: "images/zine_action_outro.png")[
  // Strong left scrim
  #place(top + left, block(width: 55%, height: 100%,
    fill: gradient.linear(
      palette.bg.transparentize(4%),
      palette.bg.transparentize(80%),
      angle: 0deg)))

  // Top-left label
  #place(top + left, dx: 5%, dy: 5%)[
    #text(size: 7pt, fill: palette.text-sec, tracking: 1.5pt, font: ("Menlo",))[END OF ISSUE No.1]
  ]

  // Big text
  #place(left + horizon, dx: 5%, dy: -10%)[
    #block(width: 42%)[
      #text(size: 44pt, fill: palette.text-dark, weight: "black",
        font: ("Heiti SC",),
      )[印一份。\ 送一份。\ 换一份。]
      #v(10pt)
      #text(size: 10pt, fill: palette.text-sec, style: "italic")[A zine is the world's smallest publishing house.\ It can also be yours.]
    ]
  ]

  // Bottom-right info block
  #place(bottom + right, dx: -5%, dy: -12%)[
    #block(fill: palette.text-dark.transparentize(30%), inset: (x: 12pt, y: 8pt), radius: 0pt)[
      #text(size: 9pt, fill: palette.bg, weight: "bold")[PPT Master #sym.dot.c 再版通知]
      #v(2pt)
      #text(size: 7pt, fill: palette.bg.transparentize(20%), style: "italic")[它 can also be yours.]
    ]
  ]

  // Footer
  #zine-footer-auto[PPT MASTER #sym.dot.c RISO ZINE GUIDE #sym.dot.c 2026][PRINT ONE. GIVE ONE. TRADE ONE.]
]
