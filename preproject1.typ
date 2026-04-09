// --------------------- metadata  --------------------- 
#let course  = "Electronic Circuits"
#let name    = "Preproject 1"
#let student = "Alan Fung"
#let date    = "13 Apr. 2026"
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

#problem(breakable: true, "Part 1:")[
  To obtain a electrical voltage or current to feed into an electronic circuit we need to sense
  physical quantities. There are many type of sensors, but in this lab we use a photoresistor.
  Explain the behavior of a photoresistor. Draw a schematic of a simple circuit that uses the
  photoresistor and can help detect the presence of varying amounts of light.

  The photoresistor is a variable resistor whose resistance is inversely proportional to the light it receives. To detect varying amounts of light, using a photoresistor, we can design a simple voltage divider circuit like this:


  #circuit({
    import zap: *
    set-style(variant: "ieee")
    vsource("vs", (0,0), (0,4), label: $V_s$)
    resistor("rp", (0,4), (4,4), label: $R_p$, variable: true)
    resistor("r1", (4,4), (4,0), label: $R_"out"$)
    node("vout", (4,4), label: $V_"out"$)

    earth("gnd", (0,0))
  
    wire((0,0), (4,0))
  })

  In maximum light conditions, $R_"out"$ receives the full voltage of the source:

  #circuit({
    import zap: *
    set-style(variant: "ieee")
    vsource("vs", (0,0), (0,4), label: $V_s$)
    wire((0,4),(4,4))
    resistor("r1", (4,4), (4,0), label: $R_"out"$)
    node("vout", (4,4), label: $V_"out"$)

    earth("gnd", (0,0))
  
    wire((0,0), (4,0))
  })

  Ideally, we make $R_"out"$ very small so in minimum brightness conditions, $V_"out" << V_s$, like:


  #circuit({
    import zap: *
    set-style(variant: "ieee")
    vsource("vs", (0,0), (0,4), label: $V_s$)
    resistor("rp", (0,4), (4,4), label: $24"k"Omega$)
    resistor("r1", (4,4), (4,0), label: $1 Omega$)
    node("vout", (4,4), label: $V_"out"$)

    earth("gnd", (0,0))
  
    wire((0,0), (4,0))
  })

  $ 
    V_"out" = V_s 1/(24k) = 0.00004 V_s approx 0
  $

  This way, $V_"out" in [0, V_s]$, and we can scale $V_s$ according to our needs.
]

#problem(breakable: true, "Part 2:")[
  #part("a",
    [
      All sensor inputs sometimes have noise from the environment.
      The sensor output is a DC voltage generated from the photoresistor configured as in Part I.
      There is a noise signal in the KHz range that is interfering with the sensor data. What type of filter
      would you need that provides only the sensor output signal that is DC after removing this noise?
    ],
    [
      To keep the DC signal and remove high-frequency noise, we can use a low-pass filter.
    ]
  )

  #part("b",
    [
      If the sensory output is a result of pulsing light at a frequency in tens of Khz, but there is some low
      frequency ambient noise, what type of filter would you need that provides only the sensor output
      signal after removing this noise?
    ],
    [
      To keep the high-frequency AC signal and remove low-frequency noise, we can use a high-pass filter.
    ]
  )

]

#problem(breakable: true, "Part 3:")[
  We would like to study a flex sensor for the lab. Look up the data sheet of a flex sensor and
  explain how it works. Give a possible application for such a sensor.

  A flex sensor has a variable resistance that is directly proportional to the angle at which it is bent.
  It uses a voltage divider and an impedance buffer so that the resistance doesn't carry over to the rest
  of the circuit.

  One such application of the flex sensor would be an electrical accordion, which instead of using the acoustics
  of air being pushed back and forth, can use the flexing of the accordion to generate a voltage, which can be converted
  to an audio signal.
]
