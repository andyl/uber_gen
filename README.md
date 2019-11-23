# UberGen

UberGen is a scriptable code generator for Elixir, motivated by a thread on
[Elixir Forum][f].  

UberGen is pre-Alpha - not yet ready for live use.

[f]: https://elixirforum.com/t/what-would-you-think-about-a-new-web-framework-that-extends-phoenix-with-rails-like-or-django-like-built-in-features/26371/8

## Background

Professional Phoenix apps typically use many add-on packages like
[LiveView][lv], [Pow][pow], and [Bamboo][bb].  Add-on packages often require
manual installation.

[lv]:  https://github.com/phoenixframework/phoenix_live_view
[bb]:  https://github.com/thoughtbot/bamboo
[pow]: https://github.com/danschultzer/pow

**The problem:** manual install instructions can be hard to follow.  

**Evidence:** innumerable `HowTos` with complicated instructions.  Here are some examples:

- [How to install Bootstrap on a Phoenix 1.4 project][1] 
- [LiveView Installation][2] 
- [Phoenix Authentication with Pow - Part 1][3]

[1]: https://elixirforum.com/t/what-would-you-think-about-a-new-web-framework-that-extends-phoenix-with-rails-like-or-django-like-built-in-features/26371/8
[2]: https://github.com/phoenixframework/phoenix_live_view/blob/master/guides/introduction/installation.md
[3]: https://experimentingwithcode.com/phoenix-authentication-with-pow-part-1/

Firstly - thank you authors for these invaluable HowTo guides!  Keep them coming!

But there are problems with **HowTo Driven Generation**:

- some installations can literally take days
- manual configuration is error-prone
- written instructions become out-of-date with tools
- no feedback mechanism for bugs and improvements
- no systematic usage metrics for HowTo authors
- barrier to entry for new programmers
- friction discourages new code exploration

We'd like a world where every `HowTo` was accompanied by a generator script.
With a single command, you could download and run the generator, then tweak and
share the generator with your friends.  

We know the value of `automated tests` and `automated package managers`.
UberGen is scriptable `automated generation` for Elixir developers.

## Comparables

There are many comparables:
[Mix.Generate][mixgen],
[PragDave Generator][pdgen],
[Orats][orats],
[Rails Composer][railcom],
[Exgen][exgen],
[Elixir Config][exconf], 
[Elixir Language Server][exls],
[Elixir Code Formatter][excf],
[Literate Programming][litpro], 
[ExDoc][exdoc],
[Visual Basic][vbas],
[Exercism][exer],
[Linux Pipes][pipe],
[Ansible][ansible], and more

UberGen extends `Mix.Generate`, and borrows ideas from other tools:
- from [Mix.Generate][mixgen]: helper functions like `copy_file` 
- from [PragDave][pdgen]: template trees, template installation and discovery
- from [Orats][orats]: git helper functions
- from [Exercism][exer]: guided refactoring
- from [Ansible][ansible], the playbook execution model
- from [Linux Pipes][pipe], small, composable actions

[mixgen]:  https://hexdocs.pm/mix/Mix.Generator.html
[pdgen]:   https://pragdave.me/blog/2017/04/18/elixir-project-generator.html
[orats]:   https://github.com/nickjj/orats
[railcom]: https://github.com/RailsApps/rails-composer
[exgen]:   https://github.com/rwdaigle/exgen
[exconf]:  https://hexdocs.pm/elixir/master/Config.html
[exls]:    https://github.com/elixir-lsp 
[excf]:    https://hexdocs.pm/elixir/master/Code.html#format_string!/2
[exdoc]:   https://github.com/elixir-lang/ex_doc
[vbas]:    https://en.wikipedia.org/wiki/Visual_Basic
[litpro]:  https://en.wikipedia.org/wiki/Literate_programming
[exer]:    https://exercism.io/
[pipe]:    https://en.wikipedia.org/wiki/Pipeline_(Unix)
[ansible]: https://www.ansible.com/

## Installing UgerGen

To install `uber_gen`:

    mix archive.install github andyl/uber_gen

Configure with `.uber_gen.exs`: [DROP?]

    import UberGen

    config :uber_gen, playbooks: [
      {:live_view_gen, "~> 0.4.0"},
      {:my_codegen, path: "~/src/CG/my_lv_tweaks"}
    ]

    include_uber_gen "~/.uber_gen/phoenix_css_setup.exs"

## UberGen Architecture

UberGen is built on a data abstration called an "Action Tree" (`atree`).

### Atree Actions

Actions are composable modules that implement a standard behavior with three
key callbacks:

- Command - executes a command
- Guide - emits a guide fragment
- Test - executes a test
    
```elixir
module Atree.Actions.Phoenix.Bootstrap4 do
  use Atree.Action

  @shortdoc "Install Bootstrap4 in your Phoenix project."
  
  def command(context, options)
    context
    |> assign(tgt_file, "output.css")
    |> copy_file(ctx.source_file, ctx.tgt_file)
    |> git_commit("Add output.css to repo")
  end
end
```

Actions can be composed into Plug-like pipelines.

    context |> Action1(opts) |> Action2(opts)

### Atree Context

The Atree Context is a Plug-like structure:

    %{
      env: %{
        app: %{
          name: "TBD"
        },
        host: %{
          name: "myhost",
          arch: "x86_64"
        }
      }
      assigns: %{
        variable1: 42
      },
      log: [
        %{
          action: Atree.Actions.Phoenix.Bootstrap4,
          guide: %{header: "Install Bootstrap", body: "body text"},
          test: :ok,
          children: []
        }
      ]
        
    }

### Atree Command Helpers 

Atree command helpers are conveniences for working with paths and generating content.

From Mix.Generator:

| Function         | Description                                                  |
|------------------|--------------------------------------------------------------|
| copy_file        | Copies source to target.                                     |
| copy_template    | Evaluates and copy templates at source to target.            |
| create_directory | Creates a directory if one does not exist yet.               |
| create_file      | Creates a file with the given contents.                      |
| embed_template   | Embeds a template given by contents into the current module. |
| embed_text       | Embeds a text given by contents into the current module.     |
| overwrite?       | Prompts the user to overwrite the file if it exists.         |

Other helpers - some inspired by Ansible:

| Function       | Description                                                  |
|----------------|--------------------------------------------------------------|
| assign         | Set a key-value pair in the context                          |
| command        | Execute shell command                                        |
| mix            | Execute mix task                                             |
| lineinfile     | Manage lines in text files                                   |
| blockinfile    | Insert/update/remove a text block surrounded by marker lines |
| git_commit     | Commit changes to git repository                             |
| git_branch     | Checkout / create a git branch                               |
| template_tree  | Copy an entire file tree as a template                       |
| mix_dependency | Ensure dependency in a `mix.exs` file                        |
| npm_package    | Ensure package setting in a `packages.json` file             |
| npm_install    | Install NPM packages                                         |
| webpack_config | Add a webpack config                                         |

Refactoring functions - some inspired by JetBrains.  These functions require
AST analysis and manipulation (which don't yet exist!):

| Function         | Description                         |
|------------------|-------------------------------------|
| rename_project   | Rename a project                    |
| rename_module    | Rename a module and all callers     |
| rename_function  | Rename a function and all callers   |
| rename_variable  | Rename all instances of a variable  |
| extract_variable | Extract an expression to a variable |
| extract_function | Extract an expression to a function |
| ensure_config    | Set a config value                  |

### Atree Playbooks

Atree playbooks are yaml or json files for composing Actions.

    ---
    - action: Util.TextBlock
      params: 
        header: Introduction
        body: >
          This is an introductory paragraph for my HowTo Guide.
        children:
          - action: Util.Command
            params:
              instruction: "Create a setup directory"
              command: mkdir /tmp/setup_dir
              creates: /tmp/setup_dir
          - action: Util.BlockInFile
            params:
              instruction: "Add this text"
              block_text: >
                config :myapp, :key, "value"
              tgt_file: config/config.exs
              check_for:
                - myapp
                - key
                - value

## Using Atree

### As a Mix Task

Use Atree as a mix task:

    $ mix atree.help

    $ mix atree.export <action>
    $ mix atree.tailor <action>
    $ mix atree.run <action>
    $ mix atree.serve <action>

    $ mix atree.action list
    $ mix atree.action install <action>
    $ mix atree.action remove <action>

You can generate output in markdown, html, and other format.

### The Atree Escript

The `atree` executable reads playbook configs from `yaml` or `json` files.
You can invoke an action from the command line:

    $ atree <playbook>.yaml export
    $ atree <playbook>.yaml tailor
    $ atree <playbook>.yaml serve
    $ atree <playbook>.yaml run

You can join actions together using pipes:

    $ atree <playbook1> [options] | atree <playbook2> [options]

### Atree in Elixir Source

    defmodule MyMod do
      ...
    end

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

