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

#set page(footer: [
  #set text(11pt)
  #line(length: 100%) // Add a line above the footer
  #align(center)[*Anastasia Labs* \ Audit Tracker ]
  #place(right, dy: -7pt)[#counter(page).display("1/1", both: true)]
])
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
= Milestone1 - Project Kickoff and Planning
#v(25pt)

The milestone1 was approved in November 2024.

#v(20pt)
= Milestone2 - Language Analysis Report

As part of Milestone2 we are required to submit a detailed analysis report on
the OpShin Language.

== Topics to cover

1. UPLC debugging Architectural Decisions 
  -  How types are mapped to UPLC types
  -  Static type Inferencer-> How ATI is implemented within OpShin 
  -  Mapping of Python -> Pluto -> UPLC
  -  Storage of variables in statemonads

2. Opshin compiler pipeline 
  - rewrites - how effective it is written and area of improvement 
  - optimization - how effective it is written and area of improvement 
  - conversion -> pluto
3. Performance and script size testing
4. Overall language constructs
#pagebreak()
#v(20pt)
== Areas Covered
1. UPLC debugger through Gastronomy

2. Tested Language constructs -- output of opshin eval, eval_uplc,

3. Code Coverage - using Pytest -cov tool

4. Checked build artifacts

5. Tried to replicate aiken acceptance tests in opshin(only first 20 test cases)
   - Challenge - opshin supports only a limited language constructs, its a challenge to replicate most of the aiken acceptance tests.

== Hunting Critical Security vulnerabilities
The compiler pipeline consists of the following steps:

Tokenization -> AST building -> Type checking and type inference -> Code generation (Pluto)

(Pluto-to-UPLC is out of scope)

Each of these steps can potentially introduce Critical errors into the final validator output. The step which is most likely to contain such vulnerabities is the Pluto-to-UPLC conversion step, but that step isnt in this audits scope.

=== Tokenization step

- Not throwing an error when a bytearray literal has odd length
- Not throwing an error when mixing tabs and spaces for the indentation
- Not throwing an error when encountering inconsistent indentation

=== AST building

- Collecting build errors but not throwing them at the end
- Incorrect grouping of tokens, leading to unexpected behavior

=== Type checking

- Not throwing an error when a type is wrong

=== Type inference

- Infering the wrong type, leading to the wrong Pluto code being generated

=== Code generation

- Code omitted
- If the generated code is textual: missing tokens (e.g. missing quotes for literal strings)
