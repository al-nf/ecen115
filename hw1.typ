// --------------------- metadata  --------------------- 
#let course  = "Electronic Circuits"
#let name    = "Homework 1"
#let student = "Alan Fung"
#let date    = "2 Apr. 2026"
// -----------------------------------------------------

#import "@preview/zap:0.5.0"

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

// ── Problem 1 ────────────────────────────────────────
#problem(1)[
  Analyze the current divider circuit given below and determine the values of the currents $i_1$, $i_2$, and the voltage $v_o$.

  #circuit({
    import zap: *
    set-style(variant: "ieee")
    isource("i1", (0,8), (0,0), label: $6"mA"$)
    resistor("r1", (2,4), (2,0), label: $9"k"Omega$)
    resistor("r2", (2,4), (6,4), label: $1"k"Omega$)
    resistor("r3", (6,8), (6,4), label: $5"k"Omega$)
    resistor("r4", (6,4), (6,0), i: $i_2$, label: $15"k"Omega$)
    isource("i2", (8,0), (8,8), label: $15"mA"$)
    resistor("r5", (10,8), (10,0), i: $i_1$, label: $7"k"Omega$)

    wire((0,8), (11,8))
    wire((0,0), (11,0))
    earth("gnd", (0,0))

    node("vo", (10,8), label: $v_o$)

    mesh(draw, (3,6), label: $-6"mA"$)
    mesh(draw, (4,2), label: $i_a$)
    mesh(draw, (7,5), label: $i_b$)
    mesh(draw, (9,5), label: $i_c$)
  })

  We can perform a simple mesh analysis:

  $
    cases(
      9(i_a + 6) + (i_a + 6) + 15(i_a - i_b) = 0,
      5(i_b + 6) + 15(i_b -  i_a) + 7i_c = 0,
      i_c - i_b = 15
    )
  $ 

$
  mat(
    25, -15, 0;
    -15, 20, 7;
    0, -1, 1;
  )
  mat(i_a; i_b; i_c)
  =
  mat(-60; -30; 15)

$
$
  underline(i) = mat(-8.1; -9.5; 5.5); quad i_1=5.5"mA", i_2 = 1.4"mA", v_o = 7i_1 = 38.5"V".
$



]
\ \ \ \ \ \ \
// ── Problem 2 ────────────────────────────────────────
#problem(2, breakable: true)[
  Analyze the circuit given below. Show all the steps of your work clearly.

  #circuit({
    import zap: *
    set-style(variant: "ieee")
    vsource("vin", (0,0), (0,8), label: $8"V"$)
    resistor("r1", (2,8), (6,8), label: $6"k"Omega$)
    resistor("r2", (2,6), (6,6), label: $3"k"Omega$)
    wire((0,8), (2,8))
    wire((2,6),(2,8))
    wire((6,6),(6,8))
    wire((6,8),(8,8))
    wire((0,0),(8,0))
    resistor("r3", (8,0), (8,8), label: $6"k"Omega$)
    isource("iin", (10,0), (10,8), label: $4"k"Omega$)
    wire((8,8), (10,8))
    wire((8,0), (10,0))
    resistor("r3", (10,8), (13,8), i: $i_o$, label: $8.5"k"Omega$)
    wire((10,0), (13,0))
    earth("gnd", (6,0))
    node("a", (13,8), label: $a$)
    node("b", (13,0), label: $b$)
    draw.content((13,4), $v_o$)
  })

  #part("a",
    [Find the Thévenin equivalent circuit looking into a and b.],
    [
      Let us simplify this circuit using an equivalent resistor and source transformation:
      #circuit({
        import zap: *
        set-style(variant: "ieee")
        vsource("vin", (0,0), (0,8), label: $8"V"$)
        resistor("r1", (0,8), (5,8), label: $2"k"Omega$)
        wire((0,0),(8,0))
        resistor("r3", (5,8), (10,8), label: $6"k"Omega$)
        vsource("vin2", (10,0), (10,8), label: $24"V"$)
        wire((8,0), (10,0))
        resistor("r3", (10,8), (13,8), i: $i_o$, label: $8.5"k"Omega$)
        wire((10,0), (13,0))
        earth("gnd", (6,0))
        node("a", (13,8), label: $a$)
        node("b", (13,0), label: $b$)
        draw.content((13,4), $v_o$)
      })
      \ \ \
      Then:
      #circuit({
        import zap: *
        set-style(variant: "ieee")
        vsource("vin", (0,0), (0,8), label: $8"V"$)
        resistor("r1", (0,8), (10,8), label: $8"k"Omega$)
        wire((0,8), (2,8))
        wire((0,0),(8,0))
        vsource("vin2", (10,0), (10,8), label: $24"V"$)
        wire((8,0), (10,0))
        resistor("r3", (10,8), (13,8), i: $i_o$, label: $8.5"k"Omega$)
        wire((10,0), (13,0))
        earth("gnd", (6,0))
        node("a", (13,8), label: $a$)
        node("b", (13,0), label: $b$)
        draw.content((13,4), $v_o$)
      })

      After shorting a and b:
      #circuit({
        import zap: *
        set-style(variant: "ieee")
        vsource("vin", (0,0), (0,8), label: $8"V"$)
        resistor("r1", (0,8), (10,8), label: $8"k"Omega$)
        wire((0,8), (2,8))
        wire((0,0),(8,0))
        vsource("vin2", (10,0), (10,8), label: $24"V"$)
        wire((8,0), (10,0))
        resistor("r3", (13,8), (13,0), i: $i_"sc"$, label: $8.5"k"Omega$)
        wire((10,8),(13,8))
        wire((10,0), (13,0))
        earth("gnd", (6,0))
      })

      It is clear that $i_"sc" = (24)/(8.5) "mA"$. \ \ \ \ \ \

      Let us go back to find the equivalent resistance by deactivating the voltage sources:
      #circuit({
        import zap: *
        set-style(variant: "ieee")
        resistor("r1", (0,0), (0,8), label: $8"k"Omega$)
        wire((0,8), (10,8))
        wire((0,0),(8,0))
        wire((10,0), (10,8), label: $24"V"$)
        wire((8,0), (10,0))
        resistor("r3", (10,8), (13,8), i: $i_o$, label: $8.5"k"Omega$)
        wire((10,0), (13,0))
        earth("gnd", (6,0))
        node("a", (13,8), label: $a$)
        node("b", (13,0), label: $b$)
        draw.content((13,4), $v_o$)
      })
      The 8k$Omega$ resistor is shorted, so $R_"th" = 8.5"k"Omega$.

      $v_"th" = i_"sc" R_"th" = (24 times 8.5)/8.5 "V"= 24"V"$.

      \ \
      Thus, the Thévenin equivalent circuit is:
      #circuit({
        import zap: *
        set-style(variant: "ieee")
        vsource("vth", (0,0), (0,4), label: $24"V"$)
        resistor("rth", (0,4), (4,4), label: $8.5"k"Omega$)
        wire((0,0),(4,0))
        node("a", (4,4), label: $a$)
        node("b", (4,0), label: $b$)
      })
    ]
  )
  \ \ \ \ \ \ \ \ \
  #part("b",
    [A load is connected across terminals a and b. Find the output voltage $v_o$ and the output current $i_o$],
    [
      #part("i",
        [For an open circuit load:],
        [
          #circuit({
            import zap: *
            set-style(variant: "ieee")
            vsource("vth", (0,0), (0,4), label: $24"V"$)
            resistor("rth", (0,4), (4,4), i: $i_o$, label: $8.5"k"Omega$)
            wire((0,0),(4,0))
            node("n", (4,4))
            node("n", (4,0))
            draw.content((4,2), $v_o$)
          })
          The open circuit voltage is simply the Thévenin voltage, so $v_o = 24"V"$.\
          Since the circuit is open, no current flows through the resistor, so $i_o = 0"A"$.
        ]
      )
      #part("ii",
        [For a short circuit load:],
        [
          #circuit({
            import zap: *
            set-style(variant: "ieee")
            vsource("vth", (0,0), (0,4), label: $24"V"$)
            resistor("rth", (0,4), (4,4), i: $i_o$,label: $8.5"k"Omega$)
            wire((0,0),(4,0))
            wire((4,4),(4,0))
            draw.content((3,2), $v_o$)
          })
          The voltage over any short circuit is 0, so $v_o = 0"V"$.\
          $i_o = (24"V")/(8.5"k"Omega)$ = 2.82mA.
        ]
      )
      \ \
      #part("iii",
        [For a 10 k$Omega$ load:],
        [
          #circuit({
            import zap: *
            set-style(variant: "ieee")
            vsource("vth", (0,0), (0,4), label: $24"V"$)
            resistor("rth", (0,4), (4,4), i: $i_o$,label: $8.5"k"Omega$)
            wire((0,0),(4,0))
            resistor("rl", (4,4),(4,0), label: $10"k"Omega$)
            draw.content((3,2), $v_o$)
          })
          We can use voltage division to find $v_o = 24 times (10)/(18.5) = 12.97"V"$.\
          $i_o = (24"V")/(18.5"k"Omega) = 1.30"mA"$.
        ]
      )
    ]
  )
]
