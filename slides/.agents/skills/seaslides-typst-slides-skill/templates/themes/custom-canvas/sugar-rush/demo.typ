#import "@preview/touying:0.7.4": *
#import "template.typ": *

#set text(font: ("Arial", "Arial Unicode MS"), size: 12pt)

// Coupled two-line badges use fixed optical gaps; ordinary content stacks use
// the theme's normal .8em rhythm.
#let micro-label-gap = 2pt
#let compact-cta-gap = 4pt

#show: sugar-rush-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [SUGAR RUSH],
    subtitle: [2026 夏日音乐节 . 年度手册],
    author: [SUGAR RUSH Organizers],
    date: datetime.today(),
  ),
)

// ======= Page 1: Cover =======

#slide(config: config-page(margin: 0pt, header: none, footer: none, background: {
  set image(width: 100%, height: 100%, fit: "cover")
  image("images/cover_bg.png")
}))[
  // Bottom scrim for text readability
  #place(bottom + left, block(width: 100%, height: 45%,
    fill: gradient.linear(palette.ink.transparentize(100%), palette.ink.transparentize(40%))))

  // Subtitle + info text at bottom left
  #place(bottom + left, dx: 5%, dy: -16%)[
    #block(width: 60%)[
      #stack(spacing: .8em,
        text(size: 12pt, fill: palette.white, tracking: 1.5pt)[2026 夏日音乐节 · 年度手册],
        text(size: 22pt, weight: "black", fill: palette.white, font: ("Arial", "Arial Unicode MS"))[让甜炸的夏天到来。],
      )
    ]
  ]

  // Date + location pills
  #place(bottom + left, dx: 5%, dy: -5%)[
    #grid(columns: (auto, auto), column-gutter: 12pt, align: horizon,
      block(fill: palette.white, inset: (x: 14pt, y: 6pt), radius: 16pt, stroke: 2pt + palette.ink)[
        #text(size: 9pt, fill: palette.ink, weight: "bold", tracking: 1pt)[7.18 — 7.24]
      ],
      text(size: 9pt, fill: palette.white, tracking: 1pt)[椰岛大草原 · CocoBay],
    )
  ]

  // CTA button at bottom right
  #place(bottom + right, dx: -5%, dy: -5%)[
    #cta-button(palette.pink)[BOOK NOW →]
  ]
]

// ======= Page 2: Chapter 1 — WHAT =======

#slide(config: config-page(margin: 0pt, header: none, footer: none, background: {
  set image(width: 100%, height: 100%, fit: "cover")
  image("images/ch1_what.png")
}))[
  // Large semi-transparent watermark behind content
  #place(center + horizon, dy: -12%)[
    #text(size: 160pt, weight: "black", fill: palette.ink.transparentize(90%), tracking: 10pt, font: ("Arial", "Arial Unicode MS"))[WHAT.]
  ]

  // Chapter badge
  #place(top + left, dx: 4%, dy: 6%)[
    #chapter-badge[CH . 01]
  ]

  // Giant chapter word
  #place(center + horizon, dy: -8%)[
    #text(size: 72pt, weight: "black", fill: palette.ink, tracking: 4pt, font: ("Arial", "Arial Unicode MS"))[WHAT.]
  ]

  // Subtitle strip
  #place(center + horizon, dy: 14%)[
    #block(fill: palette.white, inset: (x: 32pt, y: 14pt), stroke: (bottom: 3pt + palette.pink))[
      #text(size: 18pt, fill: palette.ink)[当全世界都在变热，我们决定，让它#text(fill: palette.pink, weight: "bold")[变甜]。]
    ]
  ]

  // Footer
  #place(bottom + right, dx: -4%, dy: -3%)[
    #text(size: 7pt, fill: palette.gray)[02 / #h(2pt) SUGAR RUSH]
  ]
]

// ======= Page 3: By the Numbers =======

#slide(config: config-page(margin: (top: 2em, bottom: 1.2em, x: 2em), header: none, footer: none))[
  #section-title(palette.pink)[BY THE NUMBERS]
  #v(2pt)
  #section-sub[SUGAR RUSH 2026 . KEY FACTS]

  #v(12pt)

  // Four KPI cards
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    column-gutter: 14pt,
    kpi-card(palette.pink, [DAYS], [7], [连续狂欢 / NON-STOP], icon: [◈]),
    kpi-card(palette.blue, [STAGES], [5], [主题舞台 / THEMED], icon: [♪], decoration: memphis-wave(palette.blue)),
    kpi-card(palette.yellow, [ARTISTS], [80], [组艺人 / ACTS], icon: [◆], decoration: memphis-triangle(palette.coral, size: 18pt)),
    kpi-card(palette.mint, [FANS], [50K], [预期观众 / EXPECTED], icon: [◈]),
  )

  #v(6pt)

  // Divider line
  #line(length: 100%, stroke: 1.5pt + palette.ink.transparentize(85%))

  #v(6pt)

  // Dark info banner
  #dark-banner[
    #grid(columns: (65%, 35%), align: (left + horizon, right + horizon),
      [
        #text(size: 14pt, weight: "bold", fill: palette.yellow, tracking: 1pt)[≈ 12 HOURS OF MUSIC EVERY DAY]
        #v(4pt)
        #text(size: 10pt, fill: palette.white)[从下午 4 点到次日凌晨 4 点，连续 12 个小时不间断]
        #v(3pt)
        #text(size: 8pt, fill: palette.gray.lighten(20%))[5 个舞台轮番接力 . 同时段最多 3 个演出 . 跨场地步行最远 600 米]
      ],
      [
        #align(center)[
          #memphis-zigzag(palette.mint)
          #v(4pt)
          #block(width: 52pt, height: 52pt, radius: 26pt, fill: palette.pink)[
            #align(center + horizon)[
              #text(size: 16pt, weight: "bold", fill: palette.white)[12]
              #v(-4pt)
              #text(size: 7pt, fill: palette.white, tracking: 2pt)[HOURS]
            ]
          ]
        ]
      ],
    )
  ]

  #v(1fr)
  #page-footer[数据基于 2026 排期预测 . Source: SUGAR RUSH 组委会]
]

// ======= Page 4: Principles =======

#slide(config: config-page(margin: (top: 1.8em, bottom: 0.8em, x: 2em), header: none, footer: none))[
  #grid(columns: (1fr, auto), align: (left + top, right + top),
    [
      #section-title(palette.blue)[WHAT WE STAND FOR]
      #v(2pt)
      #section-sub[三大理念 · THREE PRINCIPLES]
    ],
    memphis-dots(palette.pink, palette.blue, palette.yellow),
  )

  #v(6pt)

  // Three pillar cards
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 14pt,
    pillar-card(palette.pink, [01], [FREE], [
      #align(center)[
        #text(size: 30pt, fill: palette.pink)[⚡]
        #v(1pt)
        #text(size: 12pt, weight: "bold", fill: palette.ink)[不设鄙视链]
      ]
    ], [
      #memphis-bullet(palette.pink)[所有风格都是好风格]
      #v(2pt)
      #memphis-bullet(palette.pink)[摇滚乐迷可以爱嘻哈]
      #v(2pt)
      #memphis-bullet(palette.pink)[阵营自由切换，从不审判]
      #v(2pt)
      #memphis-bullet(palette.pink)[音乐之外的事情，先放下]
    ]),
    pillar-card(palette.yellow, [02], [FUN], [
      #align(center)[
        #text(size: 30pt, fill: palette.yellow)[✦]
        #v(1pt)
        #text(size: 12pt, weight: "bold", fill: palette.ink)[玩到极致]
      ]
    ], [
      #memphis-bullet(palette.yellow)[留下最甜的回忆]
      #v(2pt)
      #memphis-bullet(palette.yellow)[10 件巨型互动艺术装置]
      #v(2pt)
      #memphis-bullet(palette.yellow)[50+ 摊位市集与限定周边]
      #v(2pt)
      #memphis-bullet(palette.yellow)[把孩子内心还给你 7 天]
    ]),
    pillar-card(palette.mint, [03], [FOREVER YOUNG], [
      #align(center)[
        #text(size: 30pt, fill: palette.mint)[♥]
        #v(1pt)
        #text(size: 12pt, weight: "bold", fill: palette.ink)[舞池里没有年纪]
      ]
    ], [
      #memphis-bullet(palette.mint)[18 岁也好，80 岁也罢]
      #v(2pt)
      #memphis-bullet(palette.mint)[银发族专属休息岛]
      #v(2pt)
      #memphis-bullet(palette.mint)[12 岁以下家庭票同价]
      #v(2pt)
      #memphis-bullet(palette.mint)[心跳的频率才是入场券]
    ]),
  )

  #v(1fr)
  #page-footer[SUGAR RUSH 价值观 . 自 2018 年沿用至今]
]

// ======= Page 5: Chapter 2 — WHO =======

#slide(config: config-page(margin: 0pt, header: none, footer: none, background: {
  set image(width: 100%, height: 100%, fit: "cover")
  image("images/ch2_who.png")
}))[
  // Large semi-transparent watermark behind content
  #place(center + horizon, dy: -12%)[
    #text(size: 160pt, weight: "black", fill: palette.ink.transparentize(90%), tracking: 10pt, font: ("Arial", "Arial Unicode MS"))[WHO.]
  ]

  // Chapter badge
  #place(top + left, dx: 4%, dy: 6%)[
    #chapter-badge[CH . 02]
  ]

  // Giant chapter word
  #place(center + horizon, dy: -12%)[
    #text(size: 72pt, weight: "black", fill: palette.ink, tracking: 4pt, font: ("Arial", "Arial Unicode MS"))[WHO.]
  ]

  // Subtitle bar
  #place(center + horizon, dy: 2%)[
    #block(fill: palette.white, inset: (x: 32pt, y: 14pt), stroke: (bottom: 3pt + palette.pink))[
      #text(size: 18pt, fill: palette.ink)[80 组艺人 · 5 个风格阵营 · #text(fill: palette.pink, weight: "bold")[1] 张你忘不掉的脸]
    ]
  ]

  // Genre tag pills at bottom
  #place(bottom + left, dx: 5%, dy: -16%)[
    #grid(columns: (auto, auto, auto, auto, auto), column-gutter: 8pt, align: horizon,
      block(fill: palette.pink, inset: (x: 8pt, y: 4pt), radius: 2pt)[
        #stack(spacing: micro-label-gap,
          text(size: 7pt, fill: palette.white, weight: "bold")[ROCK . 25],
          text(size: 6pt, fill: palette.white.darken(15%))[摇滚 25 组],
        )
      ],
      block(fill: palette.blue, inset: (x: 8pt, y: 4pt), radius: 2pt)[
        #stack(spacing: micro-label-gap,
          text(size: 7pt, fill: palette.white, weight: "bold")[ELECTRO . 30],
          text(size: 6pt, fill: palette.white.darken(15%))[电子 30 组],
        )
      ],
      block(fill: palette.mint, inset: (x: 8pt, y: 4pt), radius: 2pt)[
        #stack(spacing: micro-label-gap,
          text(size: 7pt, fill: palette.white, weight: "bold")[FOLK . 15],
          text(size: 6pt, fill: palette.white.darken(15%))[民谣 15 组],
        )
      ],
      block(fill: palette.yellow, inset: (x: 8pt, y: 4pt), radius: 2pt)[
        #stack(spacing: micro-label-gap,
          text(size: 7pt, fill: palette.ink, weight: "bold")[HIPHOP . 10],
          text(size: 6pt, fill: palette.ink.lighten(20%))[嘻哈 10 组],
        )
      ],
      cta-button(palette.pink)[MEET THE LINEUP →],
    )
  ]
]

// ======= Page 6: Headliners =======

#slide(config: config-page(margin: (top: 2em, bottom: 1.2em, x: 2em), header: none, footer: none))[
  #grid(columns: (1fr, auto), align: (left + top, right + top),
    [
      #section-title(palette.yellow)[THE HEADLINERS]
      #v(2pt)
      #section-sub[2026 四组头牌艺人 . BOOM, BOOM, BOOM, BOOM.]
    ],
    memphis-triangle(palette.pink, size: 28pt),
  )

  #v(8pt)

  // Banner image
  #block(width: 100%, height: 180pt, clip: true, stroke: 3pt + palette.ink, radius: 4pt)[
    #image("images/headliners.png", width: 100%, height: 100%, fit: "cover")
  ]

  #v(6pt)

  // Four headliner info cards
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    column-gutter: 10pt,
    headliner-card(palette.pink, [01], [CHERRY BOMB], [ROCK . 摇滚主唱], [代表作："Pink Static"], [3 张白金专辑 . 巡演 60 城], icon: [★]),
    headliner-card(palette.blue, [02], [NEON CLOUD], [ELECTRO . 电子 DJ], [代表作："3AM Mirror"], [柏林 Berghain 常驻 . DJ Mag 30], icon: [♫]),
    headliner-card(palette.mint, [03], [MINT FOLK], [FOLK . 民谣吉他手], [代表作："Slow Lemon"], [Spotify 月听众 480 万], icon: [♥]),
    headliner-card(palette.yellow, [04], [YELLOW HUSTLE], [HIPHOP . 嘻哈 rapper], [代表作："Sugar High"], [XXL Freshman 2025 . 双白金], icon: [♪]),
  )

  #v(1fr)
  #page-footer[阵容截至 2026-04-30 . 实际演出以现场为准]
]

// ======= Page 7: Four Flavors =======

#slide(config: config-page(margin: (top: 2em, bottom: 1.2em, x: 2em), header: none, footer: none))[
  #grid(columns: (1fr, auto), align: (left + top, right + top),
    [
      #section-title(palette.blue)[FOUR FLAVORS, ONE FESTIVAL]
      #v(2pt)
      #section-sub[四大风格阵营 . TASTE YOUR OWN]
    ],
    memphis-checkerboard(size: 40pt, cell: 10pt),
  )

  #v(10pt)

  // 2x2 quadrant grid
  #grid(
    columns: (1fr, 1fr),
    rows: (auto, auto),
    column-gutter: 14pt,
    row-gutter: 14pt,
    // Rock
    flavor-card(palette.pink, [ROCK · 摇滚], [25 组艺人], [
      #memphis-bullet(palette.pink)[关键词: #text(fill: palette.pink, weight: "bold")[噪音 · 燃 · 释放]]
      #v(4pt)
      #memphis-bullet(palette.pink)[舞台：CHERRY STAGE · 容量 5000]
      #v(4pt)
      #memphis-bullet(palette.pink)[主场日: #text(weight: "bold")[Day 2 · 7.19] 整夜不停]
      #v(4pt)
      #memphis-bullet(palette.pink)[头牌: CHERRY BOMB + 24 组独立乐队]
    ], icon: [⚡]),
    // Electro
    flavor-card(palette.blue, [ELECTRO · 电子], [30 组艺人], [
      #memphis-bullet(palette.blue)[关键词: #text(fill: palette.blue, weight: "bold")[律动 · 深夜 · 迷幻]]
      #v(4pt)
      #memphis-bullet(palette.blue)[舞台：NEON GRID · 容量 5000]
      #v(4pt)
      #memphis-bullet(palette.blue)[主场日: #text(weight: "bold")[Day 3 · 7.20] 通宵 12h]
      #v(4pt)
      #memphis-bullet(palette.blue)[头牌: NEON CLOUD + 29 组国际 DJ]
    ], icon: [♫]),
    // Folk
    flavor-card(palette.mint, [FOLK · 民谣], [15 组艺人], [
      #memphis-bullet(palette.mint)[关键词: #text(fill: palette.mint, weight: "bold")[故事 · 慢 · 温度]]
      #v(4pt)
      #memphis-bullet(palette.mint)[舞台：MINT GROVE · 容量 3000]
      #v(4pt)
      #memphis-bullet(palette.mint)[主场日: #text(weight: "bold")[Day 4 · 7.21] 黄昏专场]
      #v(4pt)
      #memphis-bullet(palette.mint)[头牌: MINT FOLK + 14 组创作人]
    ], icon: [♥]),
    // Hiphop
    flavor-card(palette.yellow, [HIPHOP · 嘻哈], [10 组艺人], [
      #memphis-bullet(palette.yellow)[关键词: #text(fill: palette.coral, weight: "bold")[街头 · 节拍 · 态度]]
      #v(4pt)
      #memphis-bullet(palette.yellow)[舞台：YELLOW BLOCK · 容量 7000]
      #v(4pt)
      #memphis-bullet(palette.yellow)[主场日: #text(weight: "bold")[Day 5 · 7.22] 午夜炸场]
      #v(4pt)
      #memphis-bullet(palette.yellow)[头牌: YELLOW HUSTLE + 9 组 rapper]
    ], icon: [♪]),
  )

  #v(1fr)
  #page-footer[第五阵营 CROSSOVER . 见 Day 6 . 7.23 跨界之夜]
]

// ======= Page 8: Chapter 3 — WHERE =======

#slide(config: config-page(margin: 0pt, header: none, footer: none, background: {
  set image(width: 100%, height: 100%, fit: "cover")
  image("images/ch3_where.png")
}))[
  // Chapter badge
  #place(top + left, dx: 4%, dy: 6%)[
    #chapter-badge[CH . 03]
  ]

  // Giant chapter word
  #place(left + horizon, dx: 6%, dy: -12%)[
    #text(size: 72pt, weight: "black", fill: palette.ink, tracking: 4pt, font: ("Arial", "Arial Unicode MS"))[WHERE.]
  ]

  // Subtitle bar
  #place(center + horizon, dy: 6%)[
    #block(fill: palette.white, inset: (x: 32pt, y: 14pt), stroke: (bottom: 3pt + palette.pink))[
      #text(size: 18pt, fill: palette.ink)[椰岛大草原 · 一座为夏天造的城市]
    ]
  ]

  // Info pills at bottom
  #place(bottom + left, dx: 5%, dy: -14%)[
    #grid(columns: (1fr, 1fr, 1fr, 1fr), column-gutter: 10pt,
      block(fill: palette.bg, inset: (x: 8pt, y: 6pt), stroke: 2pt + palette.ink)[
        #stack(spacing: micro-label-gap,
          grid(columns: (auto, auto), column-gutter: 4pt, align: horizon,
            text(size: 9pt, fill: palette.pink)[◆],
            text(size: 7pt, fill: palette.pink, weight: "bold")[VENUE · 场地],
          ),
          text(size: 7pt, fill: palette.ink)[椰岛大草原 · CocoBay],
        )
      ],
      block(fill: palette.bg, inset: (x: 8pt, y: 6pt), stroke: 2pt + palette.ink)[
        #stack(spacing: micro-label-gap,
          grid(columns: (auto, auto), column-gutter: 4pt, align: horizon,
            text(size: 9pt, fill: palette.mint)[◈],
            text(size: 7pt, fill: palette.mint, weight: "bold")[AREA · 占地],
          ),
          text(size: 7pt, fill: palette.ink)[120 公顷 · 5 大舞台环抱],
        )
      ],
      block(fill: palette.bg, inset: (x: 8pt, y: 6pt), stroke: 2pt + palette.ink)[
        #stack(spacing: micro-label-gap,
          grid(columns: (auto, auto), column-gutter: 4pt, align: horizon,
            text(size: 9pt, fill: palette.yellow)[◆],
            text(size: 7pt, fill: palette.yellow, weight: "bold")[WHEN · 日期],
          ),
          text(size: 7pt, fill: palette.ink)[2026.7.18 — 7.24 · 7 天],
        )
      ],
      block(fill: palette.bg, inset: (x: 8pt, y: 6pt), stroke: 2pt + palette.ink)[
        #stack(spacing: micro-label-gap,
          grid(columns: (auto, auto), column-gutter: 4pt, align: horizon,
            text(size: 9pt, fill: palette.blue)[→],
            text(size: 7pt, fill: palette.blue, weight: "bold")[ACCESS · 交通],
          ),
          text(size: 7pt, fill: palette.ink)[机场 30 km · 高铁 15 min],
        )
      ],
    )
  ]

  // Date badge at bottom right
  #place(bottom + right, dx: -4%, dy: -4%)[
    #block(fill: palette.pink, inset: (x: 12pt, y: 6pt))[
      #stack(spacing: micro-label-gap,
        text(size: 12pt, weight: "bold", fill: palette.white, tracking: 1pt)[7.18],
        text(size: 12pt, weight: "bold", fill: palette.white, tracking: 1pt)[7.24],
      )
    ]
  ]
]

// ======= Page 9: 5 Stages =======

#slide(config: config-page(margin: (top: 2em, bottom: 1.2em, x: 2em), header: none, footer: none))[
  #section-title(palette.yellow)[5 STAGES, ONE WORLD]
  #v(2pt)
  #section-sub[中央 SUGAR DOME . 四个分舞台辐射]

  #v(8pt)

  // Hub-spoke layout using grid + place
  #block(width: 100%, height: 320pt)[
    // Top-left spoke: Cherry Stage
    #place(top + left, dx: 0%, dy: 0%)[
      #block(width: 30%)[
        #spoke-card(palette.pink, [CHERRY STAGE · 摇滚], [5,000], [观众容量 · 西北区], [Day 2 主场 · 全程户外], icon: [⚡])
      ]
    ]
    // Top-right spoke: Neon Grid
    #place(top + right, dx: 0%, dy: 0%)[
      #block(width: 30%)[
        #spoke-card(palette.blue, [NEON GRID · 电子], [5,000], [观众容量 · 东北区], [Day 3 主场 · 半室内棚], icon: [♫])
      ]
    ]
    // Center hub
    #place(center + horizon, dy: -5%)[
      #hub-center[SUGAR \ DOME][主舞台 . 30000]
    ]
    // Bottom-left spoke: Mint Grove
    #place(bottom + left, dx: 0%, dy: 0%)[
      #block(width: 30%)[
        #spoke-card(palette.mint, [MINT GROVE · 民谣], [3,000], [观众容量 · 西南区], [Day 4 主场 · 椰林环抱], icon: [♥])
      ]
    ]
    // Bottom-right spoke: Yellow Block
    #place(bottom + right, dx: 0%, dy: 0%)[
      #block(width: 30%)[
        #spoke-card(palette.yellow, [YELLOW BLOCK · 嘻哈], [7,000], [观众容量 · 东南区], [Day 5 主场 · 街区氛围], icon: [♪])
      ]
    ]
    // Dashed connector lines from center hub to corner spoke cards
    #place(center + horizon)[
      // Top-left connector (to Cherry Stage)
      #line(start: (-40pt, -30pt), end: (-160pt, -110pt), stroke: (dash: "dashed", paint: palette.pink, thickness: 1.5pt))
    ]
    #place(center + horizon)[
      // Top-right connector (to Neon Grid)
      #line(start: (40pt, -30pt), end: (160pt, -110pt), stroke: (dash: "dashed", paint: palette.blue, thickness: 1.5pt))
    ]
    #place(center + horizon)[
      // Bottom-left connector (to Mint Grove)
      #line(start: (-40pt, 30pt), end: (-160pt, 110pt), stroke: (dash: "dashed", paint: palette.mint, thickness: 1.5pt))
    ]
    #place(center + horizon)[
      // Bottom-right connector (to Yellow Block)
      #line(start: (40pt, 30pt), end: (160pt, 110pt), stroke: (dash: "dashed", paint: palette.yellow, thickness: 1.5pt))
    ]

    // Decorative dots
    #place(center + horizon, dx: -15%, dy: -35%)[#memphis-dots(palette.yellow, palette.blue)]
    #place(center + horizon, dx: 22%, dy: 38%)[#memphis-triangle(palette.mint, size: 18pt)]
  ]

  #v(1fr)
  #page-footer[5 个舞台跨场地步行最远 600m . 30s shuttle 接驳]
]

// ======= Page 10: Schedule =======

#slide(config: config-page(margin: (top: 2em, bottom: 1.2em, x: 2em), header: none, footer: none))[
  #grid(columns: (1fr, auto), align: (left + top, right + top),
    [
      #section-title(palette.coral)[SEVEN DAYS OF SUGAR]
      #v(2pt)
      #section-sub[7.18 — 7.24 . 一周完整日程]
    ],
    cta-button-dark[HR / DAY . 7 DAYS],
  )

  #v(10pt)

  // Timeline — 7 event cards in two rows (above/below line)
  // Row 1: Days 1, 3, 5, 7 (above the line)
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    column-gutter: 6pt,
    align: bottom,
    timeline-card(palette.pink, [7.18], [OPENING], [开幕之夜], [CHERRY BOMB 开场]),
    [],
    timeline-card(palette.mint, [7.20], [ELECTRO], [电子之夜], [通宵 12h . NEON GRID]),
    [],
    timeline-card(palette.gray, [7.22], [HIPHOP], [嘻哈午夜], [10 组 . YELLOW BLOCK]),
    [],
    timeline-card-dark(palette.pink, [7.24 . FINALE], [CLOSING], [闭幕大狂欢], [SUGAR DOME . 烟花]),
  )

  #v(4pt)

  // Timeline line with nodes
  #block(width: 100%, height: 28pt)[
    // Horizontal line
    #place(center + horizon)[
      #line(length: 96%, stroke: 2pt + palette.ink)
    ]
    // Numbered circles
    #grid(columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr), align: center,
      timeline-node(palette.pink, [1]),
      timeline-node(palette.coral, [2]),
      timeline-node(palette.mint, [3]),
      timeline-node(palette.blue, [4]),
      timeline-node(palette.gray, [5]),
      timeline-node(palette.coral, [6]),
      timeline-node(palette.pink, [7], star: true),
    )
  ]

  #v(4pt)

  // Row 2: Days 2, 4, 6 (below the line)
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    column-gutter: 6pt,
    align: top,
    [],
    timeline-card-bottom(palette.coral, [7.19], [ROCK DAY], [摇滚日], [25 组 · CHERRY STAGE]),
    [],
    timeline-card-bottom(palette.blue, [7.21], [FOLK], [民谣午后], [15 组 · MINT GROVE]),
    [],
    timeline-card-bottom(palette.coral, [7.23], [CROSSOVER], [跨界之夜], [4 大头牌同台]),
    [],
  )

  #v(4pt)

  // Day labels
  #grid(columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr), align: center,
    text(size: 7pt, fill: palette.gray, tracking: 1pt)[SAT],
    text(size: 7pt, fill: palette.gray, tracking: 1pt)[SUN],
    text(size: 7pt, fill: palette.gray, tracking: 1pt)[MON],
    text(size: 7pt, fill: palette.gray, tracking: 1pt)[TUE],
    text(size: 7pt, fill: palette.gray, tracking: 1pt)[WED],
    text(size: 7pt, fill: palette.gray, tracking: 1pt)[THU],
    text(size: 7pt, fill: palette.gray, tracking: 1pt)[FRI],
  )

  #v(6pt)

  // Daily schedule banner
  #dark-banner[
    #grid(columns: (70%, 30%), align: (left + horizon, right + horizon),
      [
        #grid(columns: (auto, auto), column-gutter: 8pt, align: horizon,
          text(size: 16pt, fill: palette.yellow)[◉],
          text(size: 11pt, fill: palette.yellow, weight: "bold", tracking: 1.5pt)[DAILY SCHEDULE],
        )
        #v(3pt)
        #text(size: 9pt, fill: palette.white)[每天 16:00 入场 · 17:00 开演 · 次日 04:00 结束 · 5 个舞台同时进行]
      ],
      cta-button(palette.pink)[DOWNLOAD APP →],
    )
  ]

  #v(1fr)
  #page-footer[具体演出时间以 APP 内日程为准]
]

// ======= Page 11: Chapter 4 — VIBES =======

#slide(config: config-page(margin: 0pt, header: none, footer: none, background: {
  set image(width: 100%, height: 100%, fit: "cover")
  image("images/ch4_vibes.png")
}))[
  // Scrim
  #place(bottom + left, block(width: 100%, height: 50%,
    fill: gradient.linear(palette.ink.transparentize(100%), palette.ink.transparentize(20%))))

  // Chapter badge
  #place(top + left, dx: 4%, dy: 6%)[
    #block(fill: palette.yellow, inset: (x: 12pt, y: 6pt), radius: 2pt)[
      #text(size: 9pt, fill: palette.ink, tracking: 3pt, weight: "bold")[CH . 04]
    ]
  ]

  // Giant chapter word
  #place(center + horizon, dy: -14%)[
    #text(size: 72pt, weight: "black", fill: palette.white, tracking: 4pt, font: ("Arial", "Arial Unicode MS"))[VIBES.]
  ]

  // Subtitle bar
  #place(center + horizon, dy: 6%)[
    #block(fill: palette.white, inset: (x: 32pt, y: 14pt), stroke: (bottom: 3pt + palette.pink))[
      #text(size: 18pt, fill: palette.ink)[音乐之外，还有#text(fill: palette.pink, weight: "bold")[十种甜]的方式]
    ]
  ]

  // Bottom info pills
  #place(bottom + left, dx: 5%, dy: -10%)[
    #grid(columns: (auto, auto, auto), column-gutter: 10pt,
      block(fill: palette.bg, inset: (x: 10pt, y: 6pt), stroke: 2pt + palette.ink)[
        #stack(spacing: micro-label-gap,
          grid(columns: (auto, auto), column-gutter: 4pt, align: horizon,
            text(size: 10pt, fill: palette.pink)[◈],
            text(size: 8pt, fill: palette.pink, weight: "bold")[MARKET],
          ),
          text(size: 7pt, fill: palette.ink)[50+ 摊位 · 限定周边],
        )
      ],
      block(fill: palette.yellow, inset: (x: 10pt, y: 6pt), stroke: 2pt + palette.ink)[
        #stack(spacing: micro-label-gap,
          grid(columns: (auto, auto), column-gutter: 4pt, align: horizon,
            text(size: 10pt, fill: palette.ink)[◆],
            text(size: 8pt, fill: palette.ink, weight: "bold")[ART INSTALL],
          ),
          text(size: 7pt, fill: palette.ink)[10 件巨型装置 · AR 互动],
        )
      ],
      block(fill: palette.bg, inset: (x: 10pt, y: 6pt), stroke: 2pt + palette.ink)[
        #stack(spacing: micro-label-gap,
          grid(columns: (auto, auto), column-gutter: 4pt, align: horizon,
            text(size: 10pt, fill: palette.pink)[♥],
            text(size: 8pt, fill: palette.pink, weight: "bold")[FOOD & FUN],
          ),
          text(size: 7pt, fill: palette.ink)[40+ 餐车 · 篝火 · 工坊],
        )
      ],
    )
  ]

  // Footer
  #place(bottom + right, dx: -4%, dy: -3%)[
    #text(size: 7pt, fill: palette.white)[11 / 14 . SUGAR RUSH]
  ]
]

// ======= Page 12: Beyond the Music =======

#slide(config: config-page(margin: (top: 1.5em, bottom: 1.2em, x: 2em), header: none, footer: none))[
  #section-title(palette.pink)[BEYOND THE MUSIC]
  #v(2pt)
  #section-sub[音乐之外的两大主线 · TWO TRACKS]

  #v(3pt)

  // Two comparison columns
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 16pt,
    compare-column(palette.pink, [MARKET], [周边市集], "images/market.png", [50+], [独立摊位], [来自 12 个城市的设计师], [
      #memphis-bullet(palette.pink)[SUGAR RUSH 官方限定周边]
      #v(2pt)
      #memphis-bullet(palette.pink)[独立设计师手作集市]
      #v(2pt)
      #memphis-bullet(palette.pink)[本地小吃 40+ 餐车]
      #v(2pt)
      #memphis-bullet(palette.pink)[营业时间 16:00 — 02:00]
    ], icon: [◈]),
    compare-column(palette.yellow, [ART INSTALL], [互动装置], "images/installation.png", [10], [巨型装置], [每件都能拍照打卡], [
      #memphis-bullet(palette.yellow)[10 件巨型几何充气雕塑]
      #v(2pt)
      #memphis-bullet(palette.yellow)[AR 互动 · 扫码触发动画]
      #v(2pt)
      #memphis-bullet(palette.yellow)[彩绘工坊 · 夜光涂鸦墙]
      #v(2pt)
      #memphis-bullet(palette.yellow)[入夜后变身霓虹艺术园]
    ], icon: [◆], badge: [MOST POPULAR]),
  )

  #v(1fr)
  #page-footer[市集与装置均含在通票内 · 无需额外票]
]

// ======= Page 13: Tickets =======

#slide(config: config-page(margin: (top: 1.2em, bottom: 0.8em, x: 2em), header: none, footer: none))[
  #grid(columns: (1fr, auto), align: (left + top, right + top),
    [
      #section-title(palette.blue)[GET YOUR TICKET]
      #v(1pt)
      #section-sub[三档票务 . 立即开售]
    ],
    text(size: 28pt, fill: palette.pink)[◈#text(fill: palette.blue)[●]],
  )

  #v(2pt)

  // Three ticket cards
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 10pt,
    // Early Bird
    ticket-card(palette.pink, [EARLY BIRD], [早鸟档 . 抢先入手], [限量 5000 张], [499], [
      #text(size: 8pt, fill: palette.ink)[#sym.checkmark 7 天通票]
      #v(1pt)
      #text(size: 8pt, fill: palette.ink, weight: "bold")[#sym.checkmark 入场不限场]
      #v(1pt)
      #text(size: 8pt, fill: palette.gray)[— VIP 专区]
      #v(1pt)
      #text(size: 8pt, fill: palette.gray)[— 艺人会面]
      #v(3pt)
      #align(center)[
        #block(fill: palette.coral, inset: (x: 12pt, y: 3pt), radius: 10pt)[
          #text(size: 7pt, fill: palette.white, weight: "bold", tracking: 2pt)[SOLD OUT]
        ]
      ]
    ]),
    // Regular (recommended) — elevated with prominent badge
    [
      #align(center)[
        #block(fill: palette.pink, inset: (x: 12pt, y: 3pt), radius: 10pt)[
          #text(size: 7pt, fill: palette.white, weight: "bold", tracking: 2pt)[#sym.star RECOMMENDED]
        ]
      ]
      #v(2pt)
      #block(stroke: 4pt + palette.blue, radius: 8pt)[
        #ticket-card(palette.blue, [REGULAR], [日常档 . 主力推荐], [限量 30000 张], [799], [
          #text(size: 8pt, fill: palette.ink)[#sym.checkmark 7 天通票 . 全部 5 个舞台]
          #v(1pt)
          #text(size: 8pt, fill: palette.ink, weight: "bold")[#sym.checkmark 含 1 杯指定饮品]
          #v(1pt)
          #text(size: 8pt, fill: palette.ink, weight: "bold")[#sym.checkmark 免费寄存 + 接驳车]
          #v(1pt)
          #text(size: 8pt, fill: palette.gray)[— VIP 专区]
          #v(3pt)
          #align(center)[
            #cta-button(palette.blue)[BUY NOW →]
          ]
        ])
      ]
    ],
    // VIP
    ticket-card(palette.yellow, [VIP PASS], [尊享通票 . 全程无忧], [限量 500 张], [1999], [
      #align(center)[#text(size: 16pt, fill: palette.pink)[★]]
      #v(1pt)
      #text(size: 8pt, fill: palette.ink)[#sym.checkmark 7 天全程通票]
      #v(1pt)
      #text(size: 8pt, fill: palette.ink, weight: "bold")[#sym.checkmark VIP 专区 + 包厢]
      #v(1pt)
      #text(size: 8pt, fill: palette.ink, weight: "bold")[#sym.checkmark 头牌艺人会面]
      #v(1pt)
      #text(size: 8pt, fill: palette.ink, weight: "bold")[#sym.checkmark 周边礼包 + 限定徽章]
      #v(3pt)
      #align(center)[
        #cta-button-dark[CONTACT US →]
      ]
    ]),
  )

  #v(1pt)

  // Sponsor strip
  #block(width: 100%, fill: palette.ink, inset: (x: 14pt, y: 5pt))[
    #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
      text(size: 7pt, fill: palette.yellow, tracking: 1.5pt, weight: "bold")[SPONSORED BY . 鸣谢],
      grid(columns: (auto, auto, auto, auto, auto, auto), column-gutter: 12pt, align: horizon,
        sponsor-item[#sym.diamond.stroked][COCOFRESH],
        sponsor-item[#sym.arrow.r.double][NEONIX],
        sponsor-item[#sym.star][SUGAR LAB],
        sponsor-item[#sym.note.quarter][RIPPLE TV],
        sponsor-item[#emoji.heart][PINK MOON],
        sponsor-item[#sym.star.stroked][DAYBREAK],
      ),
    )
    #v(1pt)
    #text(size: 6pt, fill: palette.gray.lighten(30%))[官方饮品 . 灯光 . 周边制造 . 媒体 . 美妆 . 接驳出行]
  ]

  #v(1fr)
  #page-footer[购票通道 . sugarrush.fest . 限购 4 张 / 实名]
]

// ======= Page 14: Closing =======

#slide(config: config-page(margin: 0pt, header: none, footer: none, background: {
  set image(width: 100%, height: 100%, fit: "cover")
  image("images/closing.png")
}))[
  // Fade to bg scrim at bottom
  #place(bottom + left, block(width: 100%, height: 40%,
    fill: gradient.linear(palette.bg.transparentize(100%), palette.bg.transparentize(5%))))

  // Date + CTA info at bottom left
  #place(bottom + left, dx: 5%, dy: -16%)[
    #grid(columns: (auto, auto), column-gutter: 20pt, align: horizon,
      block(fill: palette.bg, inset: (x: 12pt, y: 8pt), stroke: 2pt + palette.ink)[
        #stack(spacing: compact-cta-gap,
          text(size: 7pt, fill: palette.pink, weight: "bold")[SUGAR RUSH . 2026],
          text(size: 12pt, weight: "bold", fill: palette.ink, tracking: 1pt)[7.18 — 7.24],
        )
      ],
      block(fill: palette.pink, inset: (x: 16pt, y: 8pt))[
        #stack(spacing: compact-cta-gap,
          text(size: 7pt, fill: palette.white, tracking: 1pt)[GET YOUR TICKET],
          text(size: 11pt, weight: "bold", fill: palette.white, tracking: 1pt)[sugarrush.fest],
        )
      ],
    )
  ]

  // Thank you strip
  #place(bottom + left, dx: 5%, dy: -5%)[
    #block(width: 90%)[
      #align(center)[
        #block(fill: palette.pink, inset: (x: 20pt, y: 6pt), radius: 0pt)[
          #text(size: 9pt, fill: palette.white)[谢谢每一个 #text(weight: "bold")[让夏天变甜] 的人]
        ]
      ]
    ]
  ]

  // Footer
  #place(bottom + left, dx: 3%, dy: -1%)[
    #text(size: 6pt, fill: palette.gray)[copyright SUGAR RUSH 2026 . Made with sugar in 椰岛大草原]
  ]
  #place(bottom + right, dx: -3%, dy: -1%)[
    #text(size: 6pt, fill: palette.gray)[14]
  ]
]
