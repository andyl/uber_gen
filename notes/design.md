# DESIGN

## Roadmap

### Questions

- [ ] Do actions get an instance ID?

- [ ] How to manage long-running state?  (like tasks)
- [ ] Is there a datastore for Atree?
- [ ] How to access-control for shared playbooks?
- [ ] Use-cases for playbooks with multi-parents? (listeners, chat, comments)
- [ ] What is a a URI-scheme for Actions?
- [ ] Can we get CRDTs working for offline access?
- [ ] How to generate event-streams?  
- [ ] Are playbooks wrappered in a manipulation API?

- [ ] Does this work with Sockets / GenStage / Broadway?

- [ ] What are the use-cases for Transformations?
- [ ] What are the atomic Transformation operations?
- [ ] How to capture Transformation history?
- [ ] How to version an Atree?

- [ ] What is the best term for MultiParent trees? (polytrees?)
- [ ] What are the use-cases for polytrees (monitoring, alerting)
- [ ] What are the outside systems could reference an Atree? (bidding)

- [ ] How can atrees be integrated with social media?
- [ ] How can atrees be a form of media?

### Futures

- [ ] WebUI: Design WebUI

- [ ] Registry: Create Registry
- [ ] Registry: External Actions - path / github deps
- [ ] Registry: Registry upload/download/search
- [ ] Registry: How does PragDave install templates?
- [ ] Registry: How does PragDave store templates?

- [ ] Website: A HowTo Blog
- [ ] Website: Learning Paths
- [ ] Website: Time to Learn
- [ ] Website: Credentialing
- [ ] Website: Metrics: Frequency/RunTime per Action 

- [ ] LiveView: LiveView components

- [ ] Community: who else is doing this now?
- [ ] Community: who has the most experience?
- [ ] Community: who is willing to mentor?

- [ ] Server: AWS Lambda design
- [ ] Server: docker design
- [ ] Server: SAAS design

- [ ] Identity: team use-cases
- [ ] Identity: multi-team use-cases

- [ ] Interop: calendar and events
- [ ] Interop: IAM

## Escript, Registry, Use in Projects

Notes:
- Mix isn't included in Escript
- `:case.get_path()` unpredictable

Study:
- how does hex work?
- how does hex do versioning?
- how does mix work?
- how do archives work?
- how does archive.install work?

Questions:
- how to version playbooks?
- how to version actions?
- is there a "lock file" for playbooks?
- can versions be specified in the childspec?

Workflows:
- finding a bug in a playbook
- finding a bug in an action

Supports:
- versioning repos
- versioning playbooks
- installing repos
- installing playbooks

Scenarios:
- Local use
- Distribution / sharing

Paths:
- playbooks
- action repos

UseCases:
- Use from within Atree repo
- use from within another repo
- Use as Escript anywhere in the FS
- Use from within a docker container
- Use as a standalone server

Handling Beam Files - comparables:
- Mix: from within a repo
- Mix: installing a global archive
- Mix releases

## Intermixing Actions and Playbooks

Playbook Source:

    action: TextBlock
    props: 
      header: INTRO TEXT
      body: BODY TEXT
    children:
      - playbook: bingo.json
        auth:
          when: SKY=BLUE
      - action: TextBlock
        props:
          header: INTRO
          body: BODY

Children Sources:

    [
      {TextBlock, %{header: INTRO, body: TEXT}, [ bingo.json, TextBlock]},
      bongo.yaml,
      %{playbook: "bingo.yaml", auth: %{when: SKY=BLUE}},
      Command
    ]

CLI Sources:

    atree export bongo.yaml
    atree export TextBlock

Dataflow:

- StockAction
- StockPlaybook
- expand
    
Refactoring Points:

- cli.ex
- ExecPlan#build
- ExecTree
- ExecPlan

## CLI

### MIX 

mix atree.base
mix atree.base.help

mix atree.cache.list                     # list all cached playbooks
mix atree.cache.install <playbook>       # install a playbook to cache
mix atree.cache.remove                   # remove a playbook from cache

mix atree.registry.list                  # list playbooks in registry
mix atree.registry.publish <playbook>    # push a local playbook to registry
mix atree.registry.remove                # remove a playbook from registry

mix atree.pb.run <playbook> <opts>           # run playbook on the command line
mix atree.pb.serve <playbook>                # serve playbook in a browser
mix atree.pb.export <playbook> [--format md] # build playbook guide

Run behavior - run until:
- failed test (code red)
- wait for manual input (code yellow)

### Escript 

Standalone Usage:

    $ atree [<method>] [<target>] [--ctx_src <filename>] ...

Usage in Pipes:

    $ atree EXPORT playbook1.json | 
      atree util.text_block -p body="Thanks for reading!" |
      atree -s ctx_json=/tmp/context.json --output guide_html

Elements:
- method: EXPORT | TAILOR | RUN | SERVE
- target: playbook | action
- ctxsrc: stdin | saved_file [default: stdin]
- output: PresentorName [default: ctx_json]
- params: -p KEY=VAL -p KEY=VAL
- save:   -s PRESENTOR1=FILENAME -s PRESENTOR2=FILENAME

Guidelines:
- ctxsrc: read context from STDIN -or- saved file
- target: give playbook name *or* action name
- write context to stdout *or* saved file
- write output to stdout *or* saved file

TODO:
- Append to log with existing entries
- Generate outputs from log-list not from one entry

Notes:
- don't allow updating the method in a pipeline
- default method is EXPORT(?)
- issue a warning if the method updates

Future:
- bash completion 

Questions:
- how to LIST actions, query registry, download/save

Using Actions on the command line or in a bash script: 
- each action should act as a standalone executable
- context comes from STDIN or command-line param
- params are command-line options

    atree run | atree Util.TextBlock -header "asdfasdf" | atree Util.Command -command "ps"

## Validation / Interface / Inspect / Screen

Uses Cases
- validating assigns and params 
- providing data for form-builders

Design Comparables  
- elixir structs
- vex
- ecto

Design Considerations
- language-independence
- default values
- setting context assigns

## Guide Return Values

- nil
- "body"
- {"header", "body"}
- %{header: "header"}
- %{body: "body"}
- %{header: "header", body: "body"}

## Systems

- Registry
- Blog with HowTos

## Refactoring

Language Introspection / AST:

- code formatting
- language server

Uses:

- in playbooks and generator scripts
- in editor refactorings

Refactorings:

Rename Project
- Change project name
- Change project atoms
- Rename project files

Add Dependency

## Playbooks, Orchestration and Scripting

### Atree Interpreter

Takes a Playbook as a YAML file:

```yaml
---
- name: Install LivewView
  createdby: andyl
  createdon: 2019 jan 15
  playbookname: MyNewAction
  version: 0.0.1
  steps:
    - name: Introduction
      playbook: TextBlock 
      params:
        header: Install LiveView
        body: We can install LiveView using Atree.
      steps:
        - playbook: TextBlock
          params:
            header: Do something else
            body: Now do something else.
        - playbook: Command
          params:
            command: "ps aux | grep"
            creates: "/tmp/asdf.txt"
```

### Markdown-Embedded Tags

Comparables: Gatsby, React-Components Markdown, MDX, ReactStatic

```
# Sample Markdown - How to install X

<Pb.Command instruction="Now run 'cat /etc/passwd | grep asdf' > /tmp/output.txt" creates="/tmp/output.txt" />

more markdown ...
```

### Other Markup Formats

It should be possible to extend `RST` or `Asciidoc` to work with Atree.

## Use Cases

### CREATING PLAYBOOKS

- CODING: Using Text Editors and Elixir Tooling as we do now

- COMPOSER UI: Could we create an authoring UI (or scripting language) that
  would allow someone to Assemble/Compose/Configure/Modify/Publish custom
  playbooks without coding?

### USING PLAYBOOKS 

- STATIC OUTPUT: Right now I’m generating Markdown. PDF and HTML output ought
  to be straightforward.  We also need ExDoc integration.

- DIRECTOR UI: Could we create a Web-UI for guided refactoring that reruns the
  playbook tests every time the code-base was updated?

## UPDATING PLAYBOOKS

- What is the best way to report playbook issues, to fork/clone/pr/version,
  etc. How would we support updates in the Composer/Director UI?

# Guided Refactoring

## Refactoring Challenges

It would be great to have a set of robust refactoring libraries.

Challenge - many languages:
- elixir
- css
- javascript
- json

Challenge - many configuration sub-systems:
- mix deps
- webpack
- npm packages
- elixir config settings

Conclusion:
- Building Refactoring tools for all use cases will take years
- We have to start with manual approach

## Related Tech

- credo
- elixir code formatter
- elixir macros and DSLs
- elixir language server

## Guided Refactoring

Each playbook:
- emits a document fragment
- emits a validation test

Document fragments are assembled into an overall guide.

The doc is written in markdown with embedded tags.

A default doc is auto-generated from the playbooks.

There is a mix task to serve the doc on the local machine.

The atree server detects filesystem changes and dynamically updates the
web page (using LiveView).

There are server plugins for common editors: emacs, vim, vscode.

With plugins: the server auto-opens the correct page in the editor.

When embedding sub-playbooks: make the sub-docs over-ridable.

Add a command to export docs in various formats:
- static HTML
- PDF
- dynamically served

Mix commands:
- mix atree.export <playbook>   # write markdown to stdout
- mix atree.serve <playbook>    # start a webserver / file-listener

Questions:
- how to structure navigation for web pages?
- how to detect loops in pipeline?

Action / Helper
- Action / Helper collapsed into Actions
- Actions can omit the `run` function for leaf operation
- Helper functions can still be used - w/o Doc or Test

Action behavior:

- run(command_line_opts)                    # call from Mix (optional)
- help(command_line_opts)                   # Mix help
- children()           -> [children]    # List Children
- call(context, opts)  -> new_context   # execute pipeline until fail
- doc(context, opts)   -> text          # generate documentation
- test(context, opts)  -> condition     # run test

Notes:
- `doc` and `test` are invoked during `run`
- `doc` and `test` save results in the `new_context`
- `doc` can be over-ridden in parent playbooks
- doc templates can be stored in `priv/playbooks/<playbook>/doc`

Example playbook:

    defmodule RenameProject do
      use Atree.Action

      def run(command_line_opts) do
      end

      def help(command_line_opts) do
      end

      def children do
      end

      def call(ctx, opts) do
      end

      def doc(ctx, opts) do
      end

      def test(ctx, opts) do
      end
    end

If guided refactoring works, then we can build it straight away, and add
code-refactoring helpers over time.

## Refactoring Tech

We need flexible, robust, easy to use functions to refactor Elixir code.  

Refactoring works in many IDEs - especially for Java.  Refactoring libraries
exist for JavaScript [CLI][cli] and [Editors][edi].  The [Language Server
Protocol][lsp] supports refactorings via [Code Action Request][car] messages.  

[cli]: https://www.graspjs.com/
[edi]: https://github.com/cmstead/js-refactor
[lsp]: https://langserver.org/
[car]: https://microsoft.github.io//language-server-protocol/specifications/specification-3-14/#textDocument_codeAction

But I haven't been able to find libraries that supply the Elixir refactoring
functions that we would need.

If we can't find a good refactoring library, then perhaps we could write our
own, borrowing techniques from the Elixir Code Formatter or other tech.  Or
perhaps we could hack together some Refactoring functions that are not based on
AST manipulation.  Or perhaps we could pass on the whole project for now, wait
awhile and see if some supporting tech emerges.

## Action Server & CGI-style Interface

New Features:
- a CGI-style protocol definition
- a server that serves playbooks (methods: command, guide, test)
- Actions identified via Module name OR URL

Goals:
- decentralized playbook management
- language-independent implementation of playbooks

## Considerations

Use Cases:
- Generator
- HowTo Guides
- Training Manuals
- Wikis
- Tasks & Checklists
- Composite Contracts

Questions:
- can a task be part of multiple checklists?

## CLI Runner

### CLI Options

Command Line:

    $ mix atree.pb.run <playbook> [opts]

Default behavior - similar to `ansible-playbook`:

- runs commands and tests until fail
- does not re-run commands where there was success (idempotent)
- shows fail information (command to run, file to edit, etc.)

Options:

- repl - run in repl mode
- watch - watch for file changes
- force - force-run commands
- editor <type> - specify editor (nvim, vim, etc.)

### REPL Mode

Basics:
- command-line prompt 

REPL Commands:
- open file
- rerun

### Editor Integration

- use neovim and mhinz/neovim-remote
- editor and repl-runner side by side

## Context and Variables

- context has an env block (host, app, elixir, orchestrator(command))
- create env playbooks (host, elixir, node)

- variable declaration

    name, type, default: "xxx", required: true/false, description: ""

TODO:
- figure out how to use the '@' convention (for assigns)
- create an `env` function

## Architectural Elements

| Element      | Description              | Embodyments                    |
|--------------|--------------------------|--------------------------------|
| Orchestrator | composition/execution UI | mix, xt                        |
| Playbook     | Pipeline of actions      | yaml/json files, shell pipes   |
| Presentor    | CONTEXT -> OUTPUT        | TBD                            |
| Executor     | Runs a playbook          | export, run                    |
| Action       | Processing element       | Util.BlockInFile, Util.Command |
| Helper       | Command helper           | create_directory, etc.         |

## Atree Workflow

### With a HowTo Post

Authoring a HowTo Post:

- Author writes a blog post with manual install instructions
- Author creates gist with a Atree generator script
- Author adds the address of the Atree script to the blog post

Reading a HowTo Post:

- Reader views the post in the browser
- From the reader terminal: `$ atree run https://gist.github.com/howto_script.atree`
- Instant Working App 
- Pina Coladas

