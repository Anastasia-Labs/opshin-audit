// Set the background image for the page
#let image-background = image("images/background-1.jpg", height: 100%)
#set page(
  background: image-background,
  paper: "a4",
  margin: (left: 20mm, right: 20mm, top: 40mm, bottom: 30mm),
)

#show link: underline
// #set par(justify: true)

// Set default text style
#set text(22pt, font: "Barlow")

#v(3cm)

// Center-align the logo
#align(
  center,
)[#box(width: 75%, image("images/Logo-Anastasia-Labs-V-Color02.png"))]

#v(1cm)

// Set text style for the report title
#set text(20pt, fill: white)

// Center-align the report title
#align(center)[#strong[Audit Tracker]\
  #set text(20pt);OpShin Audit]

#v(6cm)

// Set text style for project details
#set text(13pt, fill: white)


// Reset text style to default
#set text(fill: luma(0%))

// Configure the initial page layout
#set page(
  background: none,
  header: [
    // Place logo in the header
    #place(
      right,
      dy: 12pt,
    )[#box(image(height: 75%, "images/Logo-Anastasia-Labs-V-Color01.png"))]
    #line(length: 100%) // Add a line under the header
  ],
  header-ascent: 5%,
  footer: [
    #set text(11pt)
    #line(length: 100%) // Add a line above the footer
    #align(center)[*Anastasia Labs* \ Audit Tracker Template]
  ],
  footer-descent: 20%,
  
)

#v(25pt)

#show outline.entry.where(level: 1): it => {
  v(12pt, weak: true)
  strong(it)
}
// Configure the outline depth and indentation
#outline(depth: 3, indent: 15pt)

// Initialize page counter
#counter(page).update(0)

#set page(
  footer: [
    #set text(11pt)
    #line(length: 100%) // Add a line above the footer
    #align(center)[*Anastasia Labs* \ Audit Tracker ]
    #place(right, dy:-7pt)[#counter(page).display("1/1", both: true)]
  ]
)
#pagebreak()

#set terms(separator: [: ], hanging-indent: 40pt)
#v(20pt)
/ Project Name: OpShin Audit
/ URL: #link(
    "https://projectcatalyst.io/funds/12/f12-cardano-open-developers/opshin-audit",
  )[Catalyst Proposal]

#set text(15pt, font: "Barlow")

#table(
  columns: 2,
  stroke: none,
  [*Project Name:*],
  [Opshin Language Audit],
  [*Audit Period:*],
  [Oct 27th,2024],
  [*Team Member(s) Assigned:*],
  [Suganya Raju, Eric Lee],
  [*Audit Start Date:*],
  [Oct 2024],
  [*Audit End Date:*],
  [],
)

#pagebreak()

#v(25pt)


#pagebreak()
#v(20pt)




#pagebreak()
#v(20pt)




#pagebreak()
