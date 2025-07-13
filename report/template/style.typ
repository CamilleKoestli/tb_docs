#import "macros.typ": *

#import "@local/syntastica:0.1.1": syntastica, languages, themes, theme-bg, theme-fg


#let TBStyle(TBauthor, confidential, body) = {
  set heading(numbering: none)

  // Move all 1 level headings to new odd page
  show heading.where(
    level: 1
  ): it => [
    #pagebreak(weak: true, to: "odd")
    #v(2.5em)
    #it
    \
  ]

  // TODO find a way to apply this only to the main outline not the figures and the tables one
  show outline.entry.where(
    level: 1
  ): it => {
    if it.element.func() != heading {
      // Keep default style if not a heading.
      return it
    }
    
    v(20pt, weak: true)
    strong(it)
  }

  let confidentialText = [
    #if confidential{
      [*Confidentiel*]
    }
  ]

  // Set global page layout
  set page(
    paper: "a4",
    numbering: "1",
    header: context{
      if not isfirsttwopages(page){
        if isevenpage(page){
          columns(2, [
            #align(left)[#smallcaps([#currentH()])]
            #colbreak()
            #align(right)[#confidentialText]
          ])
        } else {
          columns(2, [
            #align(left)[#confidentialText]
            #colbreak()
            #align(right)[#TBauthor]
          ])
        }
        hr()
      }
    },
    footer: context{
      if not isfirsttwopages(page){
        hr()
        if isevenpage(page){
          align(left)[#counter(page).display()]
        } else {
          align(right)[#counter(page).display()]
        }
      }
    },
    margin: (
      top: 150pt,
      bottom: 150pt,
      x: 1in
    )
  )

  // LaTeX look and feel :)
  set text(font: "New Computer Modern")
  set par(justify: true)
  
  show heading: set block(above: 1.4em, below: 1em)

  // settings table
  show table : set par(justify: false) 
  show table: set align(left)
  
  show heading.where(level:1): set text(size: 25pt)

  set table.cell(breakable: true)
  
  show link: underline

  // Set the default code style
  show raw: text.with(size: 0.95em, font: "Fira Code")
  //show raw: set text(font: "New Computer Modern Mono")

  // Enable syntastica only if the build mode is "full" as it is slow
  let syntastica-enabled = read("../build.mode.txt") == "full"
  show raw: it => if syntastica-enabled { align(left)[#syntastica(it, theme: "catppuccin::latte")]} else { it }


  // Set the default style for the code blocks
  show raw.where(block: true): block.with(
    fill: luma(240),
    inset: 10pt,
    radius: 2pt,
    stroke: 1pt + luma(200),
  )

  // Set the default style for the inline code 
  show raw.where(block: false): block.with(
    fill : luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )


// If the figure contains a #raw snippet (a code block), we use "Snippet" instead of "Figure" as the supplement
show figure.where(kind: raw): set figure(
  supplement: "Code"
)

// Show the figure caption (the text below) with the correct supplement ("Figure" or "Snippet")
// Replace "Fig." by "Figure"
// Remove the dot after the supplement and after the number
// Some a small space above the caption
show figure.caption: c => context [
  #v(0.1cm)
  #text(fill: figure_supplement_color)[
    #c.supplement.text.replace("Fig.", "Figure") #c.counter.display(c.numbering)
  ]#c.separator.text.replace(".", "") #c.body
]

// Help from https://github.com/typst/typst/discussions/3871
// Show the reference to a label with the name of the supplement of this reference
// It's sadly not possible to to add the figure_supplement_color to both the supplement and the number
set ref(supplement: it => {
  if it.func() == figure {
    if type(it.body) == content {
      text(it.supplement.text.replace("Fig.", "Figure"))
    }
  }
})

  

  body
}