#import "@preview/touying:0.7.4": *
#import "template.typ": *

#show: pritzker-theme.with(
  aspect-ratio: "16-9",
  config-common(breakable: false),
  config-info(
    title: [2026 普利兹克奖大师季],
    subtitle: [8 座新作 · 8 种深耕],
    author: [Architecture Review],
    date: datetime.today(),
  ),
)

// Font selection belongs to the deck, not the reusable theme. Both families
// are installed on the review platform and preserve the editorial serif mood.
#set text(font: ("Georgia", "Songti SC"), size: 12pt)

// ═══ Page 1: Cover ═══

#title-slide(
  bg-image: "images/ando_h_rooftop.png",
  info-line1: [从苏州河畔到沙漠腹地],
  info-line2: [读懂顶级建筑师的思考与坚守],
  quote-text: [不同于网红建筑的转瞬即逝，是岁月沉淀的匠心深耕],
  source: [资料来源：公众号 孙琬童],
)

// ═══ Page 2: Overview Grid ═══

#slide(config: config-page(margin: (top: 2.5em, bottom: 1.5em, x: 2em), header: none, footer: none))[
  #eyebrow[EIGHT MASTERS · EIGHT WORKS]
  #v(4pt)
  #text(size: 22pt, weight: "bold", fill: palette.text-dark)[八位大师 · 八种坚守]
  #v(4pt)
  #gold-rule(width: 80pt)
  #v(4pt)
  #text(size: 9pt, fill: palette.secondary)[2026 年集中亮相 · 横跨亚欧美非四大洲]

  #v(8pt)

  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    rows: (auto, auto),
    column-gutter: 10pt,
    row-gutter: 12pt,
    master-card[01][安藤忠雄][苏州 H+ 美术馆][中国 · 苏州 · 2026.1],
    master-card[02][奇普菲尔德][米兰圣朱利亚冰球馆][意大利 · 米兰 · 2026 冬奥],
    master-card[03][扎哈·哈迪德][淡江大桥（遗作）][中国 · 台北 · 2026.5.12],
    master-card[04][诺曼·福斯特][上海嘉艺术][中国 · 上海 · 2026.4],
    master-card[05][OMA × SANAA][纽约新美术馆扩建][美国 · 纽约 · 2026.3.21],
    master-card[06][彼得·卒姆托][LACMA 大卫·格芬画廊][美国 · 洛杉矶 · 2026.5.4],
    master-card[07][弗兰克·盖里][阿布扎比古根海姆（遗作）][阿联酋 · 阿布扎比 · 2026],
    master-card[08][凯雷][塞内加尔歌德学院][塞内加尔 · 达喀尔 · 2026.4],
  )

  #v(1fr)
  #block(width: 100%, stroke: (top: 0.5pt + palette.border), above: 4pt)[
    #v(4pt)
    #grid(columns: (1fr, auto),
      text(size: 7pt, fill: palette.tertiary)[2026 — 普利兹克大师新作季],
      context { text(size: 7pt, fill: palette.tertiary)[#utils.slide-counter.display() / #utils.last-slide-number] },
    )
  ]
]

// ═══ Page 3: Ando — full-bleed ═══

#slide(config: config-page(margin: 0pt, header: none, footer: none, background: {
  set image(width: 100%, height: 100%, fit: "cover")
  image("images/ando_h_exterior.png")
}))[
  // Left-to-right scrim
  #place(top + left, block(width: 50%, height: 100%,
    fill: gradient.linear(palette.scrim.transparentize(5%), palette.scrim.transparentize(100%), angle: 0deg)))
  // Bottom scrim
  #place(bottom + left, block(width: 100%, height: 50%,
    fill: gradient.linear(palette.scrim.transparentize(100%), palette.scrim.transparentize(15%))))

  // Eyebrow + editorial number
  #place(top + left, dx: 5%, dy: 6%)[#eyebrow(dark: true)[01 · MASTERWORK]]
  #place(top + left, dx: 5%, dy: 11%)[
    #editorial-num([01], size: 48pt, opacity: 85%, color: palette.gold-light)
  ]

  // Title block
  #place(left + horizon, dx: 5%, dy: -10%)[
    #block(width: 50%)[
      #text(size: 22pt, weight: "bold", fill: white)[安藤忠雄 · 苏州 H+ 美术馆]
      #v(5pt)
      #text(size: 12pt, fill: palette.gold-light, style: "italic")[在江南园林里写一首混凝土诗]
      #v(4pt)
      #gold-rule(width: 60pt)
      #v(4pt)
      #text(size: 8pt, fill: palette.border)[1995 年普利兹克奖得主 · 2026.1 开馆 · 苏州姑苏区上塘河畔]
    ]
  ]

  // Interior thumbnail
  #place(right + horizon, dx: -5%, dy: -6%)[
    #block(width: 20%)[
      #text(size: 7.5pt, fill: palette.border)[美术馆内部空间]
      #v(2pt)
      #image-frame("images/ando_h_interior.png", frame: true)
    ]
  ]

  // Bottom cards
  #place(bottom + left, dx: 5%, dy: -8%)[
    #block(width: 62%)[
      #grid(columns: (1fr, 1fr), column-gutter: 6pt,
        labeled-card("CORE CONCEPT", [立体园林 · 回游性], [
          从苏州土地的记忆中汲取园林精髓\
          · 在有限空间创造深度\
          · 设计视线与步行体验\
          · 通过水与光传导时间\
          \
          _不流于形式，而是作为设计的构建方式_
        ]),
        labeled-card("SPATIAL NARRATIVE", [空间叙事 · 三种对话], [
          混凝土的冷峻 ↔ 光线的温柔\
          几何的秩序 ↔ 园林的自由\
          东方美学 ↔ 西方现代主义\
          \
          _让建筑归于自然，让艺术治愈人心_
        ], variant: "dark"),
      )
    ]
  ]

  // Footer
  #place(bottom + left, dx: 5%, dy: -2%)[
    #text(size: 7pt, fill: palette.border)[图源 · H+ 美术馆]
  ]
  #place(bottom + right, dx: -5%, dy: -2%)[
    #context { text(size: 7pt, fill: palette.border)[#utils.slide-counter.display() / #utils.last-slide-number] }
  ]
]

// ═══ Page 4: Chipperfield — comparison ═══

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #eyebrow[02 · MASTERWORK]
  #v(3pt)
  #text(size: 22pt, weight: "bold", fill: palette.text-dark)[奇普菲尔德 · 米兰圣朱利亚冰球馆]
  #v(3pt)
  #text(size: 11pt, fill: palette.gold, style: "italic")[千年罗马竞技场的现代回响]
  #v(2pt)
  #text(size: 8pt, fill: palette.secondary)[戴卫·奇普菲尔德 · 2023 年普利兹克奖 · 2026 米兰冬奥会唯一新建永久场馆]

  #v(6pt)

  #grid(
    columns: (44%, 8%, 44%),
    align: (left, center, left),
    text(size: 8pt, fill: palette.tertiary, weight: "bold", tracking: 1pt)[PRECEDENT · 约 70 AD],
    [],
    text(size: 8pt, fill: palette.gold, weight: "bold", tracking: 1pt)[CONTEMPORARY · 2026],
  )
  #v(4pt)
  #grid(
    columns: (44%, 8%, 44%),
    align: horizon,
    [
      #block(width: 100%, height: 160pt, clip: true, stroke: (left: 3pt + palette.tertiary, rest: none))[
        #place(top + left)[#image("images/chipperfield_roman_amphitheater.png", width: 100%, height: 100%, fit: "cover")]
        #place(top + left, dx: 8pt, dy: 6pt)[
          #text(size: 8pt, fill: white, weight: "bold")[古罗马圆形剧场]
        ]
      ]
      #v(2pt)
      #text(size: 7pt, fill: palette.tertiary)[图源 · Unsplash]
    ],
    comparison-arrow[两千年回响],
    [
      #block(width: 100%, height: 160pt, clip: true, stroke: (left: 3pt + palette.gold, rest: none))[
        #place(top + left)[#image("images/chipperfield_milan_exterior.png", width: 100%, height: 100%, fit: "cover")]
        #place(top + left, dx: 8pt, dy: 6pt)[
          #text(size: 8pt, fill: white, weight: "bold")[米兰圣朱利亚冰球馆]
        ]
      ]
      #v(2pt)
      #text(size: 7pt, fill: palette.tertiary)[图源 · David Chipperfield Architects]
    ],
  )

  #v(6pt)

  #stat-row(
    stat-box(
      [16,000 #text(size: 8pt, style: "normal")[座]],
      [观众容量 · 椭圆形态呼应古罗马],
      variant: "light",
      value-size: 18pt,
    ),
    stat-box(
      [三道金属环带 + 玻璃腰线],
      [LED 灯带 — 城市尺度的动态幕墙],
      variant: "light",
      value-size: 10pt,
    ),
    stat-box(
      [以极致的克制与精确],
      [讲述建筑与历史 · 与城市公共生活的关系],
      variant: "dark",
      value-size: 10pt,
    ),
  )

  #v(1fr)
  #block(width: 100%, stroke: (top: 0.5pt + palette.border), above: 4pt)[
    #v(3pt)
    #grid(columns: (1fr, auto),
      text(size: 7pt, fill: palette.tertiary)[02 米兰圣朱利亚冰球馆],
      context { text(size: 7pt, fill: palette.tertiary)[#utils.slide-counter.display() / #utils.last-slide-number] },
    )
  ]
]

// ═══ Page 5: Zaha — montage ═══

#slide(config: config-page(margin: 0pt, fill: palette.scrim, background: none, header: none, footer: none))[
  // Three images spanning full width at top
  #place(top + left)[
    #grid(columns: (50%, 25%, 25%), column-gutter: 0pt,
      block(width: 100%, height: 250pt, clip: true)[
        #image("images/zaha_tamkang_bridge.png", width: 100%, height: 100%, fit: "cover")
      ],
      block(width: 100%, height: 250pt, clip: true, inset: (left: 3pt))[
        #image("images/zaha_tamkang_structure.png", width: 100%, height: 100%, fit: "cover")
      ],
      block(width: 100%, height: 250pt, clip: true, inset: (left: 3pt))[
        #image("images/zaha_tamkang_full.png", width: 100%, height: 100%, fit: "cover")
      ],
    )
  ]

  // Gradient band overlay
  #place(top + left, dy: 190pt,
    block(width: 100%, height: 200pt,
      fill: gradient.linear(palette.scrim.transparentize(100%), palette.scrim.transparentize(0%))))

  // Text block
  #place(bottom + left, dx: 5%, dy: -28%)[
    #eyebrow(dark: true)[03 · POSTHUMOUS WORK]
    #v(3pt)
    #gold-rule(width: 50pt)
    #v(6pt)
    #text(size: 28pt, weight: "bold", fill: white)[跨越江河的流动态势]
    #v(6pt)
    #text(size: 12pt, fill: palette.gold-light, style: "italic")[扎哈·哈迪德 · 1950 — 2016 · 1985 至今唯一首位获普利兹克奖女性建筑师]
  ]

  // Stat row at bottom
  #place(bottom + left, dx: 5%, dy: -6%)[
    #block(width: 90%)[
      #grid(columns: 3, column-gutter: 0pt,
        block(width: 100%, inset: (left: 10pt, rest: 6pt),
          stroke: (left: 2pt + palette.gold, rest: none),
        )[
          #text(size: 16pt, weight: "bold", fill: white)[920 米]
          #v(2pt)
          #text(size: 8pt, fill: palette.border)[全球同类型最长跨度 · 单塔不对称斜拉桥]
        ],
        block(width: 100%, inset: (left: 10pt, rest: 6pt),
          stroke: (left: 2pt + palette.gold, rest: none),
        )[
          #text(size: 16pt, weight: "bold", fill: white)[100%]
          #v(2pt)
          #text(size: 8pt, fill: palette.border)[还原扎哈生前理想化设计 · 历经多次方案攻坚]
        ],
        block(width: 100%, inset: (left: 10pt, rest: 6pt),
          stroke: (left: 2pt + palette.gold, rest: none),
        )[
          #text(size: 12pt, fill: palette.gold-light, style: "italic")[永不设限 · 突破边界]
          #v(2pt)
          #text(size: 8pt, fill: palette.border)[2026.5.12 通车 · 大桥已通 · 思想延续]
        ],
      )
    ]
  ]

  // Footer
  #place(bottom + left, dx: 5%, dy: -1.5%)[
    #text(size: 7pt, fill: palette.border)[图源 · Zaha Hadid Architects / 摄影 Paddy Chao]
  ]
  #place(bottom + right, dx: -5%, dy: -1.5%)[
    #context { text(size: 7pt, fill: palette.border)[#utils.slide-counter.display() / #utils.last-slide-number] }
  ]
]

// ═══ Page 6: Foster — backdrop ═══

#slide(config: config-page(margin: 0pt, header: none, footer: none, background: {
  set image(width: 100%, height: 100%, fit: "cover")
  image("images/foster_shanghai_exterior.png")
}))[
  // Cream wash overlay
  #place(top + left, block(width: 100%, height: 100%, fill: palette.bg.transparentize(28%)))

  // Giant editorial number
  #place(top + left, dx: 3%, dy: 3%)[
    #editorial-num([04], size: 180pt, opacity: 80%)
  ]

  // Title block — lower left
  #place(bottom + left, dx: 5%, dy: -16%)[
    #block(width: 50%)[
      #text(size: 32pt, weight: "bold", fill: palette.text-dark)[苏州河畔绽放的]
      #v(2pt)
      #text(size: 32pt, weight: "bold", fill: palette.text-dark)[钢铁花瓣]
      #v(5pt)
      #gold-rule(width: 60pt, thickness: 2.5pt)
      #v(6pt)
      #text(size: 10pt, fill: palette.secondary)[诺曼·福斯特 · 上海嘉艺术 · 普陀新地标]
      #v(3pt)
      #text(size: 8pt, fill: palette.tertiary)[1999 年普利兹克奖 · 2026.4 开放]
      #v(10pt)
      #text(size: 10.5pt, fill: palette.gold, style: "italic")[
        不是白盒子 · 是城市中缓慢生长的生命体\
        观展 · 观景 · 观城 — 三重体验
      ]
    ]
  ]

  // Detail thumbnail — right side with gold accent + caption
  #place(right + horizon, dx: -5%, dy: -5%)[
    #block(width: 22%)[
      #text(size: 7.5pt, fill: palette.tertiary)[花瓣立面细节]
      #v(3pt)
      #block(stroke: (left: 3pt + palette.gold, rest: none))[
        #block(inset: (left: 4pt))[
          #image-frame("images/foster_shanghai_petal.png", frame: true)
        ]
      ]
    ]
  ]

  // Footer
  #place(bottom + left, dx: 5%, dy: -3%)[
    #block(width: 90%)[
      #block(width: 100%, stroke: (top: 0.5pt + palette.border), above: 2pt)[
        #v(3pt)
        #grid(columns: (1fr, auto),
          text(size: 7pt, fill: palette.tertiary)[图源 · Foster + Partners / 摄影 Laurian Ghinitoiu],
          context { text(size: 7pt, fill: palette.tertiary)[#utils.slide-counter.display() / #utils.last-slide-number] },
        )
      ]
    ]
  ]
]

// ═══ Page 7: OMA/SANAA — before/after ═══

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #eyebrow[05 · COLLABORATION]
  #v(3pt)
  #text(size: 22pt, weight: "bold", fill: palette.text-dark)[OMA × SANAA · 纽约新美术馆扩建]
  #v(3pt)
  #text(size: 12pt, fill: palette.gold, style: "italic")[双强联动 · 新旧艺术共生]
  #v(2pt)
  #text(size: 8pt, fill: palette.secondary)[库哈斯（OMA / 2000）× 妹岛和世 + 西泽立卫（SANAA / 2010）· 2026.3.21 开放]

  #v(6pt)

  // Before/After images side by side + KPI stack + Bottom banner
  #stack(spacing: .8em,
    grid(
      columns: (30%, 30%, 28%),
      column-gutter: 8pt,
      [
        // Before image with label badge
        #block(width: 100%, height: 130pt, clip: true)[
          #image("images/oma_new_museum_before.png", width: 100%, height: 100%, fit: "cover")
          #place(top + left)[
            #block(fill: palette.dark, inset: (x: 6pt, y: 3pt))[
              #text(size: 8pt, fill: palette.gold-light, weight: "bold", tracking: 1.5pt)[BEFORE]
            ]
          ]
        ]
        #v(3pt)
        #text(size: 8pt, fill: palette.secondary, weight: "bold")[扩建前 · 标志性主楼]
        #v(1pt)
        #text(size: 7pt, fill: palette.tertiary)[SANAA 2010]
      ],
      [
        // After image with label badge
        #block(width: 100%, height: 130pt, clip: true)[
          #image("images/oma_new_museum_after.png", width: 100%, height: 100%, fit: "cover")
          #place(top + left)[
            #block(fill: palette.gold, inset: (x: 6pt, y: 3pt))[
              #text(size: 8pt, fill: palette.dark, weight: "bold", tracking: 1.5pt)[AFTER]
            ]
          ]
        ]
        #v(3pt)
        #text(size: 8pt, fill: palette.secondary, weight: "bold")[扩建后 · 新翼无缝衔接]
        #v(1pt)
        #text(size: 7pt, fill: palette.tertiary)[OMA 2026]
      ],
      [
        // KPI stack — stacked colored blocks
        #stack(spacing: .8em,
          block(fill: palette.dark, inset: 8pt, width: 100%)[
            #text(size: 16pt, weight: "bold", fill: palette.gold-light)[\$82M]
            #v(2pt)
            #text(size: 8pt, fill: palette.border)[总投资 8200 万美元]
          ],
          block(fill: palette.bg-alt, inset: 8pt, width: 100%)[
            #text(size: 16pt, weight: "bold", fill: palette.text-dark)[5,574 m#super[2]]
            #v(2pt)
            #text(size: 8pt, fill: palette.secondary)[新增建筑面积]
          ],
          block(fill: palette.gold.transparentize(80%), inset: 8pt, width: 100%)[
            #text(size: 10pt, fill: palette.gold, style: "italic", weight: "bold")[迭代更新 · 兼容并蓄]
            #v(2pt)
            #text(size: 8pt, fill: palette.secondary)[OMA 先锋解构 × SANAA 轻盈通透]
          ],
        )
      ],
    ),
    // Bottom massing model banner + manifesto
    grid(
      columns: (60%, 38%),
      column-gutter: 8pt,
      [
        #block(width: 100%, height: 68pt, clip: true)[
          #image("images/oma_new_museum_massing.png", width: 100%, height: 100%, fit: "cover")
          #place(top + left, dy: 2pt)[
            #block(inset: (left: 8pt), stroke: (left: 3pt + palette.gold, rest: none))[
              #text(size: 8pt, fill: white, weight: "bold")[OMA 体块模型 · 通透立面 + 错落空间 + 开放布局]
            ]
          ]
        ]
      ],
      align(right + bottom)[
        #text(size: 10pt, fill: palette.text-dark, style: "italic")[
          让城市街景\
          与艺术空间\
          相互渗透
        ]
      ],
    ),
  )

  #v(1fr)
  #block(width: 100%, stroke: (top: 0.5pt + palette.border), above: 4pt)[
    #v(3pt)
    #grid(columns: (1fr, auto),
      text(size: 7pt, fill: palette.tertiary)[图源 · OMA / 摄影 Dean Kaufman · Jason O'Rear],
      context { text(size: 7pt, fill: palette.tertiary)[#utils.slide-counter.display() / #utils.last-slide-number] },
    )
  ]
]

// ═══ Page 8: Zumthor — banner ═══

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #eyebrow[06 · TWENTY YEARS]
  #v(3pt)
  #text(size: 26pt, weight: "bold", fill: palette.text-dark)[20 年打磨的诗意艺术方舟]
  #v(3pt)
  #gold-rule(width: 60pt, thickness: 2.5pt)
  #v(5pt)
  #text(size: 10pt, fill: palette.secondary)[彼得·卒姆托 · LACMA 大卫·格芬画廊 · 2026.5.4 开放]
  #v(2pt)
  #text(size: 8pt, fill: palette.tertiary)[2009 年普利兹克奖 · 横跨洛杉矶威尔希尔大道之上]

  #v(6pt)

  // Full-width banner image
  #block(width: 100%, height: 130pt, clip: true)[
    #image("images/zumthor_lacma_exterior.png", width: 100%, height: 100%, fit: "cover")
  ]

  // SUSPENDED ARK label overlay + Stats row
  #v(-18pt)
  #stack(spacing: .8em,
    block(fill: palette.dark, inset: (x: 8pt, y: 4pt))[
      #text(size: 8pt, fill: palette.gold-light, weight: "bold", tracking: 2pt)[SUSPENDED ARK]
    ],
    // Stats row with labels + dark quote block
    grid(
      columns: (1fr, 1fr, 1fr, 1fr),
      column-gutter: 8pt,
      stat-column("SCALE")[\$724M][7.24 亿美元投资 · 32,293 m#super[2]],
      stat-column("STRUCTURE")[七座极简混凝土亭][错落排布 · 横跨繁忙大道之上],
      stat-column("CRAFT TIME")[20 年][反复打磨 · 以极致耐心对抗时代浮躁],
      quote-block[建筑是场所的\诗意容器][— 彼得·卒姆托],
    ),
  )

  #v(1fr)
  #block(width: 100%, stroke: (top: 0.5pt + palette.border), above: 4pt)[
    #v(3pt)
    #grid(columns: (1fr, auto),
      text(size: 7pt, fill: palette.tertiary)[摒弃艺术品等级化 · 古典与当代平等共生 · 图源 Archdaily / 摄影 Iwan Baan],
      context { text(size: 7pt, fill: palette.tertiary)[#utils.slide-counter.display() / #utils.last-slide-number] },
    )
  ]
]

// ═══ Page 9: Gehry — floating ═══

#slide(config: config-page(margin: (top: 2em, bottom: 1em, x: 2em), header: none, footer: none))[
  #eyebrow[07 · FINAL MAGNUM OPUS]
  #v(2pt)
  #text(size: 26pt, weight: "bold", fill: palette.text-dark)[沙漠中的解构主义绝唱]
  #v(2pt)
  #gold-rule(width: 60pt, thickness: 2.5pt)
  #v(4pt)
  #text(size: 13pt, fill: palette.secondary, style: "italic")[弗兰克·盖里 · 阿布扎比古根海姆博物馆 · 2026 开幕]
  #v(2pt)
  #text(size: 8pt, fill: palette.tertiary)[1989 年普利兹克奖得主 · 弗兰克·盖里（1929 — 2025）大师遗作]

  #v(4pt)

  // Image gallery + manifesto
  #stack(spacing: .8em,
    grid(
      columns: (48%, 24%, 24%),
      column-gutter: 6pt,
      [
        #image-frame("images/gehry_abu_dhabi_render1.png", height: 140pt, frame: true)
        #v(2pt)
        #text(size: 8pt, fill: palette.secondary)[效果图 · 主视角]
        #v(1pt)
        #text(size: 7pt, fill: palette.tertiary)[不规则曲面 · 灵动褶皱 · 极具冲击的几何形态]
      ],
      [
        #image-frame("images/gehry_abu_dhabi_render2.png", height: 85pt, frame: true)
        #v(2pt)
        #text(size: 7pt, fill: palette.tertiary)[第二角度]
      ],
      [
        #image-frame("images/gehry_abu_dhabi_render3.png", height: 85pt, frame: true)
        #v(2pt)
        #text(size: 7pt, fill: palette.tertiary)[鸟瞰角度]
      ],
    ),
    // Manifesto block below images
    grid(
      columns: (48%, 50%),
      column-gutter: 6pt,
      [],
      manifesto-block(
        "FINAL STATEMENT",
        [近 20 年心血 · 生命尾声的造型实验],
        [金属外立面随日光流转变换肌理 · 沙漠极端气候定制遮阳系统],
        tag: [建筑无边界 · 创意无极限],
      ),
    ),
  )

  #v(1fr)
  #block(width: 100%, stroke: (top: 0.5pt + palette.border), above: 4pt)[
    #v(3pt)
    #grid(columns: (1fr, auto),
      text(size: 7pt, fill: palette.tertiary)[图源 · Gehry Partners — 解构主义大师的收官终篇],
      context { text(size: 7pt, fill: palette.tertiary)[#utils.slide-counter.display() / #utils.last-slide-number] },
    )
  ]
]

// ═══ Page 10: Kéré — annotation ═══

#slide(config: config-page(margin: 0pt, header: none, footer: none, background: {
  set image(width: 100%, height: 100%, fit: "cover")
  image("images/kere_senegal_exterior.png")
}))[
  // Vertical scrim
  #place(top + left, block(width: 100%, height: 100%,
    fill: gradient.linear(palette.scrim.transparentize(30%), palette.scrim.transparentize(60%), palette.scrim.transparentize(25%))))

  // Header
  #place(top + left, dx: 5%, dy: 6%)[
    #eyebrow(dark: true)[08 · ROOTED IN EARTH]
    #v(5pt)
    #text(size: 20pt, weight: "bold", fill: white)[夯土砖屏风 · 扎根乡土的温暖建筑]
    #v(3pt)
    #gold-rule(width: 50pt)
    #v(4pt)
    #text(size: 9pt, fill: white.transparentize(15%))[迪埃贝多·凯雷 · 塞内加尔歌德学院]
    #v(2pt)
    #text(size: 8pt, fill: palette.border)[2022 年普利兹克奖 · 2026.4 达喀尔开幕]
  ]

  // Three-column card layout
  #place(top + left, dx: 5%, dy: 38%)[
    #block(width: 90%)[
      #grid(columns: (35%, 22%, 43%), column-gutter: 6pt,
        // Philosophy card (light)
        block(width: 100%, fill: palette.bg.transparentize(6%), inset: 10pt,
          stroke: (left: 3pt + palette.gold, rest: none),
        )[
          #text(size: 8pt, fill: palette.gold, tracking: 2pt)[DESIGN PHILOSOPHY]
          #v(3pt)
          #text(weight: "bold", size: 11pt, fill: palette.text-dark)[顺应自然 · 而非与之对抗]
          #v(2pt)
          #gold-rule(width: 20pt, thickness: 1.5pt)
          #v(4pt)
          #set text(fill: palette.text-dark, size: 8.5pt)
          · 本土压制土砖构筑主体结构\
          · 自然通风系统 · 摆脱空调依赖\
          · 适配本土气候 · 节能 · 采光\
          · 空间开放包容 · 服务社区
          #v(6pt)
          #text(size: 8pt, fill: palette.secondary, style: "italic")[
            出生并滂 · 始终坚持以本土材料\
            与可持续建造服务社区
          ]
          #v(6pt)
          #gold-rule(width: 16pt, thickness: 1pt)
          #v(2pt)
          #text(size: 7.5pt, fill: palette.gold, weight: "bold")[迪埃贝多 · 黄金屏风 · 落叶]
        ],
        // Courtyard card (image + label)
        block(width: 100%, fill: palette.bg.transparentize(6%), inset: 6pt)[
          #block(width: 100%, height: 160pt, clip: true)[
            #image("images/kere_senegal_courtyard.png", width: 100%, height: 100%, fit: "cover")
          ]
          #v(4pt)
          #text(size: 8pt, fill: palette.gold, tracking: 1pt)[CORE]
          #v(2pt)
          #text(weight: "bold", size: 9pt, fill: palette.text-dark)[猴面包树 · 生命象征]
          #v(1pt)
          #text(size: 7pt, fill: palette.secondary)[置入核心院落]
        ],
        // Interior card (dark + image)
        block(width: 100%, fill: palette.dark.transparentize(14%), inset: 6pt)[
          #block(width: 100%, height: 160pt, clip: true)[
            #image("images/kere_senegal_interior.png", width: 100%, height: 100%, fit: "cover")
          ]
          #v(4pt)
          #text(size: 8pt, fill: palette.gold-light, tracking: 1pt)[INTERIOR]
          #v(2pt)
          #text(weight: "bold", size: 9pt, fill: white)[承担文化交流 · 教育传播 · 艺术展演]
          #v(1pt)
          #text(size: 7pt, fill: palette.border)[服务本地的当代公共空间 · 连接社区 · 多功能]
        ],
      )
    ]
  ]

  // Bottom quote
  #place(bottom + left, dx: 5%, dy: -4%)[
    #text(size: 9pt, fill: palette.gold-light, style: "italic")[全球同质化时代 · 顶级建筑扎根土地 · 温暖人心]
  ]
  #place(bottom + right, dx: -5%, dy: -4%)[
    #context { text(size: 7pt, fill: palette.border)[#utils.slide-counter.display() / #utils.last-slide-number · 图源 Archdaily / 摄影 Iwan Baan] }
  ]
]

// ═══ Page 11: Epilogue ═══

#focus-slide(brackets: true,
  footer-left: [资料来源 · 公众号 孙琬童 · 致敬八位普利兹克大师],
  footer-right: context { [#utils.slide-counter.display() / #utils.last-slide-number · END] },
)[
  #eyebrow[Epilogue · 结 · 语]
  #v(16pt)
  #text(size: 28pt, weight: "bold", fill: palette.text-dark)[所有传世的经典]
  #v(8pt)
  #text(size: 24pt, fill: palette.gold, style: "italic")[皆源于日复一日的坚守]
  #v(16pt)
  #gold-rule(width: 100pt)
  #v(16pt)
  #grid(
    columns: 4,
    column-gutter: 16pt,
    align(center)[
      #text(size: 18pt, weight: "bold", fill: palette.gold, style: "italic")[耐心]
      #v(5pt)
      #text(size: 10pt, fill: palette.text-dark)[耗时二十年打磨一座场馆]
      #v(3pt)
      #text(size: 8pt, fill: palette.tertiary)[— 卒姆托 · 盖里]
    ],
    align(center)[
      #text(size: 18pt, weight: "bold", fill: palette.gold, style: "italic")[扎根]
      #v(5pt)
      #text(size: 10pt, fill: palette.text-dark)[坚守本土人文 · 温暖人心]
      #v(3pt)
      #text(size: 8pt, fill: palette.tertiary)[— 凯雷 · 安藤 · 奇普菲尔德]
    ],
    align(center)[
      #text(size: 18pt, weight: "bold", fill: palette.gold, style: "italic")[破界]
      #v(5pt)
      #text(size: 10pt, fill: palette.text-dark)[突破边界 · 颠覆常规]
      #v(3pt)
      #text(size: 8pt, fill: palette.tertiary)[— 扎哈 · 福斯特 · OMA]
    ],
    align(center)[
      #text(size: 18pt, weight: "bold", fill: palette.gold, style: "italic")[敬畏]
      #v(5pt)
      #text(size: 10pt, fill: palette.text-dark)[对空间 · 自然 · 人文的]
      #v(1pt)
      #text(size: 10pt, fill: palette.text-dark)[极致敬畏与深度思考]
    ],
  )
  #v(16pt)
  #text(size: 10pt, fill: palette.secondary, style: "italic")[2026 这场大师新作季 · 不仅是全球美学盛宴 · 更让我们明白]
]
