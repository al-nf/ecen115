// --------------------- metadata  --------------------- 
#let course  = "Electronic Circuits"
#let name    = "Homework 2"
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
    *#num.*
    #v(2pt)
    #body
  ]
}

#let part(letter, question, answer) = {
  v(4pt)
  [*#letter.* #question]
  pad(left: 1em)[#answer]
}
/*
#part("",
  [
  ],
  [
  ]
)
*/

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

#problem(breakable: true, 1)[
  Consider the circuit below:

  #circuit({
    import zap: *
    set-style(variant: "ieee")
    vsource("vin", (0,0), (0,2), label: $V_"in"$)
    resistor("r1", (0,2), (0,4), label: $1 "kΩ"$)
    resistor("r2", (0,4), (2,4), label: $1 "kΩ"$)
    resistor("r3", (2,4), (2,2), label: $1 "kΩ"$)
    resistor("r4", (2,2), (2,0), label: $5 "kΩ"$)
    resistor("r5", (4,4), (4,0), label: $24 "kΩ"$)
    capacitor("c", (6,4), (6,0), label: $100 "pF"$)
    resistor("r6", (8,4), (8,0), label: $24 "kΩ"$)
    node("vout", (8,4), label: $V_"out"$)
  
    wire((2,4), (8,4))
    wire((0,0), (8,0))
  })
  This can be simplified to:
  #circuit({
    import zap: *
    set-style(variant: "ieee")
    vsource("vin", (0,0), (0,4), label: $V_"in"$)
    resistor("r1", (0,4), (2,4), label: $2 "kΩ"$)
    resistor("r2", (2,4), (2,0), label: $4 "kΩ"$)
    capacitor("c", (4,4), (4,0), label: $100 "pF"$)
    node("vout", (4,4), label: $V_"out"$)
  
    wire((2,4), (4,4))
    wire((0,0), (4,0))
  })
  Which can be further simplified to:
  #circuit({
    import zap: *
    set-style(variant: "ieee")
    vsource("vin", (0,0), (0,4), label: $2/3V_"in"$)
    resistor("r1", (0,4), (4,4), label: $4/3 "kΩ"$)
    capacitor("c", (4,4), (4,0), label: $100 "pF"$)
    node("vout", (4,4), label: $V_"out"$)
  
    wire((0,0), (4,0))
  })
  #part("i",
    [
      Find the value of $V_"out"/V_"in"$ at:
    ],
    [
      a. ω = 0:
      $
        V_"out" = 2/3V_"in" -> V_"out"/V_"in" = 2/3
      $
      b. ω = ∞:
      $
        V_"out" = 0 -> V_"out"/V_"in" = 0
      $
    
    ]
  )
  #part("ii",
    [
      From your answer in (i), what type of filter is this circuit?
    ],
    [
      Since the output voltage is 0 at high frequency, this circuit is a low pass filter.
    ]
  )
  #part("iii",
    [
      Find the cutoff frequency in Hz and gain in dB.
    ],
    [
      $
        tau = R C = 4/3 times 100 times 10^(-9) = 1.33 times 10^(-7)
      $
      $
        f_"3dB" = 1/(2 pi tau) = 1.2 "MHz"\
        ⍵_0 = 1/tau = 7.5 "Mrad/s"\
        20 log_10(V_"out"/V_"in") = 20 log_10 (2/3) = -3.52 "dB"
      $
    ]
  )
  #part("iv",
    [
      Draw the amplitude Bode plot of this filter.
    ],
    [
      #canvas({
        plot.plot(
          size: (10, 6),
          x-label: $omega$,
          y-label: $|H| " (dB)"$,
          y-min: -30,
          y-max: 0,
          x-mode: "log",
          x-grid: true,
          y-grid: true,
          {
            plot.add(domain: (1e3, 7.5e6), t => -3.52)
            plot.add(domain: (7.5e6, 1e8), t => -3.52 - 20 * calc.log(t / 7.5e6, base: 10))
            plot.add(((7.5e6, -3.52),), mark: "o", mark-size: 0.15)
            plot.annotate({
              draw.line((7.5e6, -3.52), (7.5e6, -6.52), stroke: (dash: "dashed"))
              draw.line((1e3, -6.52), (7.5e6, -6.52), stroke: (dash: "dashed"))
              draw.circle((7.5e6, -6.52), radius: 0.1, fill: black)
              draw.content((7.5e6, -6.52), anchor: "south", padding: 1.2)[$omega_0 = 7.5 "Mrad/s"$]
              draw.content((2e3, -6.52), anchor: "south", padding: 1.2)[$-3 "dB"$]
              draw.content((0.6e7, -14), anchor: "west", padding: 0.2)[$-20 "dB/dec"$]
            })
          }
        )
      })
    ]
  )
  #part("v",
    [
      If an input $V_"in" (t) = 6 + 3 sin(2 pi 10^3 t) + 4 sin (2 pi 10^12 t)$ is given to this circuit, write the expression for the corresponding output voltage $V_o$ as a function of time.
    ],
    [
      The higher frequency term is filtered out, so:
      $
        V_o = 2/3 (6+3sin(2 pi 10^3 t)) = 4 + 2 sin (2 pi 10^3 t)
      $
    ]
  )
]
\ \ \ \ \ \ \
#problem(breakable: true, 2)[
  Consider the circuit below:

  #circuit({
    import zap: *
    set-style(variant: "ieee")
    vsource("vin", (0,0), (0,4), label: $V_"in"$)
    resistor("r1", (0,4), (2,4), label: $8 "kΩ"$)
    resistor("r2", (2,4), (2,0), label: $8 "kΩ"$)
    capacitor("c1", (2,4), (6,4), label: $10 "pF"$)
    resistor("r3", (6,4), (6,2), label: $1 "kΩ"$)
    resistor("r4", (6,2), (6,0), label: $3 "kΩ"$)
    resistor("r5", (6,4), (8,4), label: $6 "kΩ"$)
    resistor("r6", (8,4), (8,2), label: $4 "kΩ"$)
    resistor("r7", (8,2), (8,0), label: $4 "kΩ"$)
    node("vout", (8,4), label: $V_"out"$)

    earth("gnd", (2,0))
  
    wire((0,0), (8,0))
  })

  This can be simplified with a source transformation:
  #circuit({
    import zap: *
    set-style(variant: "ieee")
    vsource("vin", (0,0), (0,4), label: $V_"in"/2$)
    resistor("r1", (0,4), (3,4), label: $4 "kΩ"$)
    capacitor("c1", (3,4), (6,4), label: $10 "pF"$)
    resistor("r4", (6,4), (6,0), label: $4 "kΩ"$)
    resistor("r5", (6,4), (8,4), label: $6 "kΩ"$)
    resistor("r7", (8,4), (8,0), label: $8 "kΩ"$)
    node("vout", (8,4), label: $V_"out"$)

    earth("gnd", (0,0))
  
    wire((0,0), (8,0))
  })

  #part("a",
    [
      Classify the circuit as STC high or low pass for the voltage output $V_"out"$.
    ],
    [
      Let us consider a DC input with ⍵ = 0. The capacitor becomes an open circuit:
      #circuit({
        import zap: *
        set-style(variant: "ieee")
        vsource("vin", (0,0), (0,4), label: $V_"in"/2$)
        resistor("r1", (0,4), (4,4), label: $4 "kΩ"$)
        resistor("r5", (6,4), (8,4), label: $6 "kΩ"$)
        resistor("r4", (6,4), (6,0), label: $4 "kΩ"$)
        resistor("r7", (8,4), (8,0), label: $8 "kΩ"$)
        node("vout", (8,4), label: $V_"out"$)

        earth("gnd", (0,0))
      
        wire((0,0), (8,0))
      })
      $V_"out" = 0$, so this circuit is a high-pass filter.

      \ \ \ \ 
      Let us also find the gain at ⍵ = ∞, for the sake of completion:
      #circuit({
        import zap: *
        set-style(variant: "ieee")
        vsource("vin", (0,0), (0,4), label: $V_"in"/2$)
        resistor("r1", (0,4), (4,4), label: $4 "kΩ"$)
        resistor("r5", (4,4), (8,4), label: $6 "kΩ"$)
        resistor("r4", (4,4), (4,0), label: $4 "kΩ"$)
        resistor("r7", (8,4), (8,0), label: $8 "kΩ"$)
        node("vout", (8,4), label: $V_"out"$)

        earth("gnd", (0,0))
      
        wire((0,0), (8,0))
      })

      #circuit({
        import zap: *
        set-style(variant: "ieee")
        vsource("vin", (0,0), (0,4), label: $V_"in"/4$)
        resistor("r1", (0,4), (4,4), label: $2 "kΩ"$)
        resistor("r5", (4,4), (8,4), label: $6 "kΩ"$)
        resistor("r7", (8,4), (8,0), label: $8 "kΩ"$)
        node("vout", (8,4), label: $V_"out"$)

        earth("gnd", (0,0))
      
        wire((0,0), (8,0))
      })

      This is a simple voltage divider, so:
      $
        V_"out" = V_"in"/4 * 1/2 = V_"in"/8
      $
      This confirms our earlier observation that the circuit is a high-pass filter.
    ]
  )

  #part("b",
    [
      Find the cutoff frequency in Hz and the gain in dB.
    ],
    [
      $
        tau = (10 times 10^(-12))(4 + (14(4))/(14+4)) times 10^3 = 7.11 times 10^(-8)\
        f_"3dB" = 1/(2 pi tau) = 2.24 "MHz"\
        ⍵_0 = 1/tau = 14.1 "Mrad/s"\
        20 log_10(V_"out"/V_"in") = 20 log_10 (1/8) = -18.06 "dB"
      $
    ]
  )
  
  #part("c",
    [
      If an input $V_"in" = 6 + 4 sin (400 pi t) + 8 sin (2 pi 10^9 t) "V"$ is given to this circuit, write the expression for the corresponding output voltage $V_"out"$ as a function of time.
    ],
    [
      We exclude the two low-frequency terms from the output and mulitply by the gain:
      $
        V_"out" = 1/8 (8 sin (2 pi 10^9 t)) = sin (2 pi 10^9 t) "V"
      $
    ]
  )

  \
  #part("d",
    [
      Draw the amplitude Bode plot of this filter.
    ],
    [
      #let omega0 = 14.1e6
      #let gain = -18.06
      #canvas({
        plot.plot(
          size: (10, 5),
          x-label: $omega$,
          y-label: $|H| " (dB)"$,
          y-min: (gain - 40),
          y-max: 0,
          x-mode: "log",
          x-grid: true,
          y-grid: true,
          {
            plot.add(domain: (omega0 / 100, omega0), t => gain + 20 * calc.log(t / omega0, base: 10))
            plot.add(domain: (omega0, 1e9), t => gain)
            plot.add(((omega0, gain),), mark: "o", mark-size: 0.15)
            plot.annotate({
              draw.line((omega0, gain), (omega0, gain - 3), stroke: (dash: "dashed"))
              draw.line((1e3, gain - 3), (omega0, gain - 3), stroke: (dash: "dashed"))
              draw.circle((omega0, gain - 3), radius: 0.1, fill: black)
              draw.content((omega0, gain), anchor: "south", padding: -0.5)[$omega_0 = 14.1 "Mrad/s"$]
              draw.content((3e3, gain - 3), anchor: "south", padding: 1.4)[$-3 "dB"$]
              draw.content((1.2e8, gain - 8), anchor: "east", padding: 0.2)[$+20 "dB/dec"$]
            })
          }
        )
      })
    ]
  )
]
