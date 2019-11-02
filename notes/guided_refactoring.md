# Notes on Refactoring

## Challenges

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
- We have to start with manual / guided approach

## Related Tech

- credo
- elixir code formatter
- elixir macros and DSLs
- elixir language server

## Guided Refactoring

Each playbook and helper function:
- emits a guide
- emits a validation test result

The guide is written in markdown with embedded tags.

A default guide is auto-generated from the helper tasks.

There is a mix task to serve the guide on the local machine.

The ugen server detects filesystem changes and dynamically updates the
web page (LiveView).

There are server plugins for common editors: emacs, vim, vscode.

With plugins: the server auto-opens the correct page in the editor.

When embedding sub-playbooks: make the sub-guides over-ridable.

Add a command to export guides in various formats:
- static HTML
- PDF
- dynamically served

Mix commands:
- mix ugen.guide

Questions:
- how to structure navigation for web pages?
- collapse 'playbook' and 'helper module'? (root playbook / leaf playbook)

A 'playbook' behavior:

- run(context, opts) -> new_context
- guide(context, opts) -> text
- test(context, opts) -> condition

Notes:
- `guide` and `test` are invoked during `run`
- `guide` and `test` save results in the `new_context`
- `guide` can be over-ridden in parent playbooks
- guide templates can be stored in `priv/playbooks/<playbook>/guide`

Example playbook:

    defmodule RenameProject do
      def run(ctx, opts) do
      end

      def guide(ctx, opts) do
      end
    end

