# DESIGN

## Notes

- a playbook is a module with `use Atree.Action`
- a playbook registers itself, borrowing techniques from `Mix.Task`

## Directory Structure

    lib/
      mix/
        tasks/
          task1.ex
          task2.ex
      atree/
        playbooks/
          playbook1.ex
          playbook2.ex
    priv/
      atree/
        playbooks/
          playbook1/
            templates/
            files/
            docs/

## MIX CLI

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

## Escript

Usage:

    atree [<method>] [<target>] [--ctx_src <filename>] ...

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

## Guide Return Values

- nil
- "body"
- {"header", "body"}
- %{header: "header"}
- %{body: "body"}
- %{header: "header", body: "body"}

## .atree.exs

    playbooks = [
      
    ]

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

## Orchestration and Scripting

### Atree Interpreter

Takes a YAML file as input

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

Using the Command-Line Interpreter

```
$ ubergen myfile.yaml export  # writes markdown to stdout
$ ubergen myfile.yaml run     # start the ubergen runner
$ ubergen myfile.yaml serve   # start the ubergen server
$ ubergen myfile.yaml save    # save as reusable playbook in the registry
$ ubergen myfile.yaml gen     # generate an elixir module from the yaml 
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

### Command-Line Invocation

Using Actions on the command line or in a bash script: 
- each action should act as a standalone executable
- context comes from STDIN or command-line param
- params are command-line options

    atree run | atree Util.TextBlock -header "asdfasdf" | atree Util.Command -command "ps"

## Use Cases

### CREATING PLAYBOOKS

- CODING: Using Text Editors and Elixir Tooling as we do now

- COMPOSER UI: Could we create an authoring UI (or scripting language) that would allow someone to Assemble/Compose/Configure/Modify/Publish custom playbooks without coding?

### USING PLAYBOOKS 

- STATIC OUTPUT: Right now I’m generating Markdown. PDF and HTML output ought to be straightforward.  We also need ExDoc integration.

- DIRECTOR UI: Could we create a Web-UI for guided refactoring that reruns the playbook tests every time the code-base was updated?

## UPDATING PLAYBOOKS

- What is the best way to report playbook issues, to fork/clone/pr/version, etc. How would we support updates in the Composer/Director UI?


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

At this point, all the supporting tech is readily at hand to build Atree -
except one.  Refactoring.  We need flexible, robust, easy to use functions to
refactor Elixir code.  

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
