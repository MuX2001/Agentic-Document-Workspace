#import "template.typ": *
#show: research-theme.with(lang: "zh")

// Layout gallery, not experimental findings. Replace samples in real decks.
#theory-slide(
  $ Delta_T (t, tau) = L_0 (t, tau) - L_T (t, tau) $,
  title: [触觉效用的配对比较],
  explanation: [
    固定观测、动作目标与噪声，仅切换触觉输入。

    $t$ 为执行状态，$tau$ 为 flow time。
  ],
)

// Existing user asset, imported without redrawing. See sources/README.md.
#diagram-slide(diagram("assets/la4vla.png"))

#experiment-slide(
  [
    #frame-strip(
      [*接触前* #caption[真实关键帧]],
      [*接触中* #caption[真实关键帧]],
      [*动作结束* #caption[真实关键帧]],
    )
    #caption[关键帧来自同一 rollout，保留时间戳。]
  ],
  [
    *实验条件*

    checkpoint、任务、seed

    *实测结果*

    成功率、误差与延迟：待填

    #caption[布局样例，尚无实验数据。]
  ],
  title: [实验记录],
)

#comparison-slide(
  ([方法], [输入与假设], [比较证据], [Limitations]),
  (
    ([Baseline], [观测与训练条件], [原文结果与评估条件], [作者报告的边界]),
    ([待讨论方法], [关键差异], [论文结果与本地复现], [尚未验证的部分]),
  ),
  title: [文献对比],
)

#discussion-slide[
  去触觉模式进入训练分布后，效用差异是否仍然稳定？

  哪个闭环实验可以检验这项离线指标？
]
