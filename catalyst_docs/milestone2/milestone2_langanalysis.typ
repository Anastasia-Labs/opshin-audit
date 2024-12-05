// Set the background image for the page
#let image-background = image("../images/background-1.jpg", height: 100%)
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
)[#box(width: 75%, image("../images/Logo-Anastasia-Labs-V-Color02.png"))]

#v(1cm)

// Set text style for the report title
#set text(20pt, fill: white)

// Center-align the report title
#align(center)[#strong[Proof of Achievement - Milestone 1]\
  #set text(20pt);OpShin Language Analysis Report]

#v(6cm)

// Set text style for project details
#set text(13pt, fill: white)

// Display project details
#table(
  columns: 2,
  stroke: none,
  [*Project Number*],
  [1200175],
  [*Project Manager*],
  [Jonathan Rodriguez],
)

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
    )[#box(image(height: 75%, "../images/Logo-Anastasia-Labs-V-Color01.png"))]
    #line(length: 100%) // Add a line under the header
  ],
  header-ascent: 5%,
  footer: [
    #set text(11pt)
    #line(length: 100%) // Add a line above the footer
    #align(center)[*Anastasia Labs* \ OpShin Audit - Milestone 2]
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
    #align(center)[*Anastasia Labs* \ OpShin Audit - Milestone 2]
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

= Quantitative Metrics
#v(25pt)
== Introduction
#v(5pt)

OpShin is an pythonic smart contract language designed for the Cardano blockchain ecosystem. It aims to lower the barrier to entry for Cardano smart contract development by leveraging Python's syntax and ecosystem while compiling to Plutus Core. This approach allows developers to write smart contracts using familiar Python constructs while still benefiting from Cardano's robust and secure execution environment.

== Key Features 


== Limitations

1. Its primary support is for List and Dict types,Lack of native tuple support introduces workarounds.


#pagebreak()
#v(20pt)
= Code Coverage Percentage
#v(20pt)


#pagebreak()

#v(25pt)
= Number of Manual Review Findings -- divide this topic into categories
#v(25pt)

1. *Unclear Error Messages*:
When executing OpShin scripts using the command `opshin eval any filepath`, the error messages produced are not sufficiently clear or informative. This lack of clarity in error reporting can hinder developers' ability to quickly identify and resolve issues in their smart contract code.

2. *Static Type Inference Testing*: under Security
The static type inference system in OpShin lacks comprehensive testing, particularly for scenarios involving dynamically passed variables. There is a need to develop and implement additional test cases to verify how the static type system infers types for variables that are passed dynamically during runtime. This testing gap could potentially lead to unexpected behavior or type-related errors in smart contracts.

3. *Compiled Code*:

The compiled code for Minting and Spending purpose seems to be different with respect to the force-three-params tag. 

4. *UI(Some other wors) for `blueprint.json file` * :

The json file does not clearly state the title of the validator name, We can recommend the opshin team to add the title of the validator which can be used as  aredernece while writing off chain code.

5. No support for *tuple* and *generic types* 

6. To be discussed ---> (more complex unit test cases) -> Milestone4


#pagebreak()
#v(20pt)

== Recommendations for Improvements
#v(10pt)


#pagebreak()
#v(20pt)


