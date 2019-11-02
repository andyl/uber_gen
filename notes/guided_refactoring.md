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
