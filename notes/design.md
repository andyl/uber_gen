# DESIGN

## Notes

- a playbook is a module with `use UberGen.Playbook`
- a playbook registers itself, borrowing techniques from `Mix.Task`

## Directory Structure

    lib/
      mix/
        tasks/
          task1.ex
          task2.ex
      uber_gen/
        playbooks/
          playbook1.ex
          playbook2.ex
    priv/
      uber_gen/
        playbooks/
          playbook1/
            templates/
            files/
            docs/

## MIX CLI

mix ugen.base
mix ugen.base.help

mix ugen.cache.list                     # list all cached playbooks
mix ugen.cache.install <playbook>       # install a playbook to cache
mix ugen.cache.remove                   # remove a playbook from cache

mix ugen.registry.list                  # list playbooks in registry
mix ugen.registry.publish <playbook>    # push a local playbook to registry
mix ugen.registry.remove                # remove a playbook from registry

mix ugen.pb.run <playbook> <opts>           # run playbook on the command line
mix ugen.pb.export <playbook> [--format md] # build playbook doc
mix ugen.pb.serve <playbook>                # serve playbook doc

Run behavior - run until:
- failed test (code red)
- wait for manual input (code yellow)

## Guide Return Values

- nil
- "body"
- {"header", "body"}
- %{header: "header"}
- %{body: "body"}
- %{header: "header", body: "body"}

## .uber_gen.exs

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

## Scripting

### UberGen interpreter

Takes a YAML file as input

```yaml
---
- name: Install LivewView
  createdby: andyl
  createdon: 2019 jan 15
  playbookname: MyNewPlaybook
  version: 0.0.1
  steps:
    - name: Introduction
      playbook: TextBlock 
      params:
        header: Install LiveView
        body: We can install LiveView using UberGen.
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

It should be possible to extend `RST` or `Asciidoc` to work with UberGen.

## Use Cases

## CREATING PLAYBOOKS

- CODING: Using Text Editors and Elixir Tooling as we do now

- COMPOSER UI: Could we create an authoring UI (or scripting language) that would allow someone to Assemble/Compose/Configure/Modify/Publish custom playbooks without coding?

## USING PLAYBOOKS 

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

The ugen server detects filesystem changes and dynamically updates the
web page (using LiveView).

There are server plugins for common editors: emacs, vim, vscode.

With plugins: the server auto-opens the correct page in the editor.

When embedding sub-playbooks: make the sub-docs over-ridable.

Add a command to export docs in various formats:
- static HTML
- PDF
- dynamically served

Mix commands:
- mix ugen.build <playbook>   # write markdown to stdout
- mix ugen.server <playbook>  # start a webserver / file-listener

Questions:
- how to structure navigation for web pages?
- how to detect loops in pipeline?

Playbook / Helper
- Playbook / Helper collapsed into Playbooks
- Playbooks can omit the `run` function for leaf operation
- Helper functions can still be used - w/o Doc or Test

Playbook behavior:

- run(cmd_line_opts)                    # call from Mix (optional)
- help(cmd_line_opts)                   # Mix help
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
      use UberGen.Playbook

      def run(cmd_line_opts) do
      end

      def help(cmd_line_opts) do
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

At this point, all the supporting tech is readily at hand to build UberGen -
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

