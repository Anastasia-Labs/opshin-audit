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
  #set text(20pt);OpShin Audit]

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
    #align(center)[*Anastasia Labs* \ OpShin Audit - Milestone 1]
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

// #set page(
//   footer: [
//     #set text(11pt)
//     #line(length: 100%) // Add a line above the footer
//     #align(center)[*Anastasia Labs* \Opshin Audit - Milestone 1]
//     #place(right, dy:-7pt)[#counter(page).display("1/1", both: true)]
//   ]
// )
#pagebreak()

#set terms(separator: [: ], hanging-indent: 40pt)
#v(20pt)
/ Project Name: OpShin Audit
/ URL: #link(
    "https://projectcatalyst.io/funds/12/f12-cardano-open-developers/opshin-audit",
  )[Catalyst Proposal]

#set text(15pt, font: "Barlow")

= Signed Project Scope Document
#v(20pt)
== Project Objectives
== Project Deliverables
== Project Timelines
== Signatures

#pagebreak()

#v(25pt)
= Approved Audit Objectives
#v(25pt)
== Purpose of Audit
== Audit Objectives
=== Manual Revision

Our manual code auditing is focused on a wide range of attack vectors, including
but not limited to:

- UTXO Value Size Spam (Token Dust Attack)
- Large Datum or Unbounded Protocol Datum
- EUTXO Concurrency DoS
- Unauthorized Data Modification
- Multisig PK Attack
- Infinite Mint
- Incorrect Parameterized Scripts
- Other Redeemer
- Other Token Name
- Arbitrary UTXO Datum
- Unbounded Protocol Value
- Foreign UTXO Tokens
- Double or Multiple Satisfaction
- Locked Ada
- Locked Non-Ada Values
- Missing UTXO Authentication
- UTXO Contention
== Approvals

#pagebreak()
#v(25pt)
= Audit Timeline
== Approvals

#pagebreak()
#v(25pt)
= Operational Communication Channels
== Communication Channels
== Participation Evidence

#pagebreak()
#v(25pt)

