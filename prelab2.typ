// --------------------- metadata  --------------------- 
#let course  = "Electronic Circuits"
#let name    = "Prelab 2"
#let student = "Alan Fung"
#let date    = "7 Apr. 2026"
// -----------------------------------------------------

#import "@preview/zap:0.5.0"
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot

// ── Layout helpers ────────────────────────────────────
#let header = {
  grid(
    columns: (1fr, 1fr),
    align(left)[*#course* — #name],
    align(right)[#student · #date],
  )
  line(length: 100%, stroke: 0.5pt)
  v(4pt)
}

#let problem(num, breakable: false, body) = {
  v(8pt)
  block(
    breakable: breakable,
    stroke: 0.5pt + luma(180),
    radius: 4pt,
    inset: (x: 8pt, y: 12pt),
    width: 100%,
  )[
    *#num*
    #v(2pt)
    #body
  ]
}

#let part(letter, question, answer) = {
  v(4pt)
  [*#letter.* #question]
  pad(left: 1em)[#answer]
}

#let mesh(draw, center, label: $I$, dir: "cw", radius: 0.7) = {
  let (cx, cy) = center
  let start = if dir == "cw" { 100deg } else { 80deg }
  let mark  = if dir == "cw" {
    (end: ">", fill: black)
  } else {
    (start: ">", fill: black)
  }

  draw.arc(
    (cx + radius * calc.cos(start), cy + radius * calc.sin(start)),
    start: start,
    stop: start - 330deg,
    radius: radius,
    mark: mark,
    stroke: .6pt,
  )
  draw.content((cx, cy), label)
}

#let circuit(caption: none, body) = {
  let fig = zap.circuit(body)
  if caption != none {
    figure(fig, caption: caption)
  } else {
    align(center, fig)
  }
}

// -----------------------------------------------------

// ==================== DOCUMENT =======================
#set page(margin: (x: 2.5cm, y: 2cm))
#set text(font: "New Computer Modern", size: 11pt)
#set par(justify: true)

#header

#problem(breakable: true, "Pre-lab:")[
  Carry out a "paper-and-pencil" analysis of the RC circuit given in Figure 1. $V_0$ is the initial voltage 
  present across the capacitor terminals just before the switch closes.
  #circuit(caption: "Single time constant circuit", {
    import zap: *
    set-style(variant: "ieee")
    vsource("vin", (0,0), (0,4), label: $V_"in"$)
    resistor("r1", (0,4), (4,4), label: $R_1$)
    resistor("r2", (4,4), (4,0), label: $R_2$)
    wire((4,4), (6,4))
    capacitor("c1", (6,4), (6,0), label: $C_1$)
    node("vout", (6,4), label: $V_"out"$)
    earth("gnd", (6,0))
    wire((0,0), (6,0))

  })

  #part("a",
    [
      Write the expression for the expected output voltage $V_"out"$ as a function of time in terms of
      $R_1$, $R_2$, $C_1$, $V_0$, input voltage $V_"in"$, and time. Assume that the input switches from
      0 to a value $V_"in"$ at time $t = 0$.
    ],
    [
      Let us simplify the circuit with a series of source transformations:
      #circuit({
        import zap: *
        set-style(variant: "ieee")
        vsource("vin", (0,0), (0,4), label: $R_e/R_1 V_"in"$)
        resistor("re", (0,4), (4,4), label: $R_e$)
        wire((4,4), (4,4))
        capacitor("c1", (4,4), (4,0), label: $C_1$)
        node("vout", (4,4), label: $V_"out"$)
        earth("gnd", (4,0))
        wire((0,0), (4,0))
      })

      where $R_e = (R_1 R_2)/(R_1 + R_2)$.

      The output voltage for this circuit is simply
      $
        V_"out" = R_e/R_1 V_"in" + (V_0 - R_e/R_1V_"in") e^(-t/(R_e C_1))\
        = R_2/(R_1+R_2)V_"in" + (V_0 - R_2/(R_1+R_2)V_"in") e^((-(R_1+R_2)t)/(R_1 R_2 C_1))
      $

    ]
  )

  #part("b",
    [
      Draw the waveform with respect to time for $V_"out" (t)$ for each case below.
      Given $R_1= 15 "k"Ω$, $R_2 = 5 "k"Ω$ and that $V_"in"$ switches instantaneously from 0 to 10V.
      There are different cases to consider while doing the calculations for the pre-lab:\
      (i) $V_0 = 0"V"$ and $C_1 = 0.1 mu"F"$\
      (ii) $V_0 = 1"V"$ and $C_1 = 0.1 mu"F"$
    ],
    [
      #canvas({
        plot.plot(
          size: (10, 6),
          x-label: $t" (ms)"$,
          y-label: $V_"out"" (V)"$,
          {
            plot.add(
              domain: (0, 2),
              label: "(i)",
              t => {
                let tau = 0.375
                let vi = 2.5
                let v0 = 0
                vi + (v0 - vi) * calc.exp(-t / tau)
              }
            )
            plot.add(
              domain: (0, 2),
              label: "(ii)",
              t => {
                let tau = 0.375
                let vi = 2.5
                let v0 = 1
                vi + (v0 - vi) * calc.exp(-t / tau)
              }
            )
          }
        )
      })
      
    ]
  )

  #part("c",
    [
      For an AC source at the input given as $V_"in"$\
      #part("i",
        [
          Classify the circuit as STC high pass or low pass with output $V_"out"$ across $C_1 = 0.1 mu"F"$],
        [
        At a low frequency, the capacitor is an open circuit, so the voltage is $R_2/(R_1+R_2) V_"in"$
        so the circuit is a low-pass filter.
        ]
      )
      #part("ii",
        [
          Find the cutoff or 3dB frequency in Hz for this circuit for $R_1=15"k"Ω, R_2=5"k"Ω.$
        ],
        [
          $f_"3dB" = 1/(2 pi tau) = 1/(2 pi R_e C_1) = 1/(2 pi times 3.75 times 10^3 times 0.1 times 10^-6) = 424.4 "Hz"$
        ]
      )
      #part("iii",
        [
          Find the gain $V_"out"/V_"in"$ at
        ],
        [
          - ω = 0:
          #circuit({
            import zap: *
            set-style(variant: "ieee")
            vsource("vin", (0,0), (0,4), label: $R_e/R_1 V_"in"$)
            resistor("re", (0,4), (4,4), label: $R_e$)
            wire((4,4), (4,4))
            node("vout", (4,4), label: $V_"out"$)
            earth("gnd", (4,0))
            wire((0,0), (4,0))
          })

          $V_"out" = R_e/R_1 V_"in"$, so $V_"out"/V_"in" = R_2/(R_1+R_2) = 0.25$.
          \ \ \ \ \ \ \
          - ω = ∞:
          #circuit({
            import zap: *
            set-style(variant: "ieee")
            vsource("vin", (0,0), (0,4), label: $R_e/R_1 V_"in"$)
            resistor("re", (0,4), (4,4), label: $R_e$)
            wire((4,4),(4,0))
            wire((4,4), (4,4))
            node("vout", (4,4), label: $V_"out"$)
            earth("gnd", (4,0))
            wire((0,0), (4,0))
          })
          Since $V_"out" = 0$, $V_"out"/V_"in" = 0$.
        ],
      )
    ], []
  )
]
