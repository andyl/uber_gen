# UberGen DevNotes

## Overview

Exploratory Code Branches

| Branch | Created     | Contents                            |
|--------|-------------|-------------------------------------|
| master | 2019 Oct 20 | Just a README stating overall goals |
| test   | 2019 Oct 25 | Mix-style playbook structure        |
| build  | 2019 Nov 01 | Document generation                 |
| macros | 2019 Nov 03 | Use of macros in UberGen playbook   |

## 2019 Nov 01 Fri

After some study, it is clear that it will take a very long time to acquire
robust refactoring tech.

What can work for now is for a human to follow instructions and perform manual
source-code edits.  Each step in the instructions can contain a validation
test.  Over time, as refactoring tech improves, more automation can be built
into playbooks.

So the path forward is `guided refactoring` (`guided generation`?).  The vision
would be to have an interactive web page (a guide) with instructions, and an
editor running side by side.  The coder can read instructions, make manual
edits, perform validation tests. 

## 2019 Nov 03 Sun

Desired Features:

- Construct the guide structure by introspecting the execution pipeline
- Output the guide to many formats: web/interactive, markdown, pdf

Implementation Details:

- All elements in the execution pipeline are Playbooks
- Ad-hoc playbook elements are wrapped in `UberGen.Playbook.Util.Exec`
