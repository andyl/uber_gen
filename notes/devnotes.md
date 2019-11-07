# UberGen DevNotes

## Overview

Exploratory Code Branches

| Branch   | Created     | Contents                            |
|----------|-------------|-------------------------------------|
| master   | 2019 Oct 20 | Just a README stating overall goals |
| test     | 2019 Oct 25 | Mix-style playbook structure        |
| build    | 2019 Nov 01 | Document generation                 |
| macros   | 2019 Nov 03 | Use of macros in UberGen playbook   |
| liveview | 2019 Nov 07 | Write playbook for LiveViews        |

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

## 2019 Nov 05 Tue

Playbooks must:
- have the module-name prefix `UberGen.Playbooks`
- add the line `use UberGen.Playbook`

The `UberGen.Playbook` module provides five macros for use in Playbooks.

| Macro   | Arg(s)      | Returns            | Purpose                       |
|---------|-------------|--------------------|-------------------------------|
| run/1   | mix options | run status         | can be called from a mix task |
| call/2  | ctx, opts   | new_ctx            | executable playbook code      |
| test/2  | ctx, opts   | test status        | validation test               |
| steps/2 | ctx, opts   | list of PB Modules | list of playbook children     |
| guide/2 | ctx, opts   | guide text         | playbook documentation        |

All of these macros are optional for any given playbook.

Calling a Playbook with an 'undefined' macro returns a default value.

The `UberGen.Playbook` module provides introspection functions that show if a
method is defined in a playbook: `has_run?/0`, `has_call?/0`, `has_test?/0`,
`has_steps?/0`, `has_guide?/0`

## 2019 Nov 07 Thu

`UberGen` Mix commands

| Command             | Purpose                                   |
|---------------------|-------------------------------------------|
| mix ugen.base.help  | Display help text for a playbook          |
| mix ugen.cache.list | Show locally cached playbooks             |
| mix ugen.pb.export  | Export a static playbook to MD, HTML, PDF |
| mix ugen.pb.run     | Run a playbook on the command line        |
| mix ugen.pb.serve   | Serve a playbook for browser interaction  |

