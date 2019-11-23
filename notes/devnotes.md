# Atree DevNotes

## Overview

Exploratory Code  

| Tag         | Created     | Contents                            |
|-------------|-------------|-------------------------------------|
| x1_master   | 2019 Oct 20 | Just a README stating overall goals |
| x2_test     | 2019 Oct 25 | Mix-style playbook structure        |
| x3_guide    | 2019 Nov 01 | Document generation                 |
| x4_macros   | 2019 Nov 03 | Use of macros in Atree playbook   |
| x5_liveview | 2019 Nov 07 | Write playbook for LiveViews        |
| x6_schemas  | 2019 Nov 10 | Action schemas, nested playbooks  |

## 2019 Nov 01 Fri

After some study, it is clear that it will take a very long time to acquire
robust refactoring tech.

What can work for now is for a human to follow instructions and perform manual
source-code edits.  Each step in the instructions can contain a validation
test.  Over time, as refactoring tech improves, more automation can be built
into playbooks.

So the focus will be to optimize the `guided refactoring` process.  The vision
would be to have an interactive web page (a guide) with instructions, and an
vim-like code editor running side by side.  The coder can read instructions,
make manual edits, perform validation tests. 

## 2019 Nov 03 Sun

Desired Features:

- Construct the guide structure by introspecting the execution pipeline
- Output the guide to many formats: web/interactive, markdown, pdf

Implementation Details:

- All elements in the execution pipeline are Actions
- Ad-hoc playbook elements are wrapped in `Atree.Action.Util.Exec`

## 2019 Nov 05 Tue

Actions must:
- have the module-name prefix `Atree.Actions`
- add the line `use Atree.Action`

The `Atree.Action` module provides callbacks for use in Actions.

| Callbacks   | Arg(s)            | Returns         | Purpose                       |
|-------------|-------------------|-----------------|-------------------------------|
| command/2   | ctx, opts         | new_ctx         | executable playbook code      |
| test/2      | ctx, opts         | test status     | validation test               |
| guide/2     | ctx, opts         | guide text      | playbook documentation        |
| children/2  | ctx, opts         | {mod, opts, []} | default children              |
| interface/3 | type, ctx, opts   | params          | schema for params and assigns |
| inspect/3   | params, ctx, opts | status          | cast and validate params      |

All of these macros are optional for any given playbook.

Calling a Action with an 'undefined' macro returns a default value.

The `Atree.Action` module provides introspection functions that show if a
method is defined in a playbook: `has_run?/0`, `has_call?/0`, `has_test?/0`,
`has_steps?/0`, `has_guide?/0`

## 2019 Nov 07 Thu

`Atree` Mix commands

| Command         | Purpose                                   |
|-----------------|-------------------------------------------|
| mix ugen.help   | Display help text for a playbook          |
| mix ugen.list   | Show locally cached playbooks             |
| mix ugen.export | Export a static playbook to MD, HTML, PDF |
| mix ugen.run    | Run a playbook on the command line        |
| mix ugen.serve  | Serve a playbook for browser interaction  |

## 2019 Nov 10 Sun

After writing our first playbooks it becomes evident that each playbook needs
schemas that behave like Ecto changesets with validation and introspection.

In the long term, schemas will be used for:
- coder documentation
- parameter validation
- guiding the editor interfaces of composer UIs
- validating playbook scripts

The structure of the Atree toolchain would borrow themes from VisualBasic.

VisualBasic has **components** (created by C-coders with c-coding tools)
assembled into **applications** (by VB Developers using the VB UI) that are
distributed to End Users.

Atree has **playbooks** (created by Elixir-coders with elixir-coding tools)
assembled into **guides** (by authors using the Atree UI) that are distriuted
to End Users.

Actions are assembled into trees.  Branches for a playbook are specified as
steps.  Each step takes configuration options - Ecto.Schemas and changesets!

To setup an entire playbook tree with a single config file, we'll borrow ideas
from the `embeds_one` and `embeds_many` constructs provided by Ecto.

## 2019 Nov 14 Thu

New features:
- Ecto-style schemas and option validation
- Ability to configure nested trees of playbooks
- Ability to specify tree configuration in YAML or JSON docs
- A standalone executable `uber_gen` that reads config files.

New possibilities:
- HTTP-like playbook protocol with CGI 
- IP-addressible Action Servers
- Language-independent playbook implementation
- CLI invocation and action pipelining

Next step:
- CLI interaction design for running playbooks
- running playbooks (mix and escript)
- passing context during run (fail points, default values for variables)
- envision the design for specifying and using `assigns`

## 2019 Nov 19 Tue

Changes:
- Playbook renamed to Action
- Each action now returns a `Ctx`
- Context struct contains a log field
- Guide and Test output is stored in the log
- Added an `Executor` layer with `Export` and `Run` modules.
- Added a `Presentor` layer to convert Ctx to Markdown, PDF, etc.

The core design is done.  Next steps are to write tests, docs, actions and playbooks.

