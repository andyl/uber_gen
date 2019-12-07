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
- from [PragDave][pdgen]: template trees, installation and discovery
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

    $ git clone http://github.com/andyl/uber_gen
    $ cd uber_gen
    $ mix do deps.get, compile

Now check to see that everything runs end-to-end:

    $ mix atree        # show a help screen
    $ mix test         # run all tests
    $ mix script/all   # run example command-line scripts

Best way to get started is probably to follow the `mix atree help` pages and to
study the examples under the `script` directory.  Then read the example
playbooks in the `priv/playbooks` directory, and read the action modules in the
`lib/atree/actions` directory.

## UberGen Architecture

UberGen uses a data abstration called an "Action Tree" - an `atree`.

### Atree Actions

Atree Actions are independent modules that can be composed into trees:

    root_action
      - branch_action
        - leaf_action
        - leaf_action
      - branch_action
        - leaf_action
        - leaf_action

The structure of the Action Tree somewhat resembles the HTML document object
model.  Each node implements a type, takes properties, can be traversed and
updated dynamically.

Actions implement a behavior with standard set of callback functions:

- Screen - checks property validity
- Guide - emits a guide fragment
- Command - executes a command
- Test - tests command results
- Children - returns a list of children
    
```elixir
module Atree.Actions.Phoenix.Bootstrap4 do
  use Atree.Action

  @shortdoc "Install Bootstrap4 in your Phoenix project."
  
  def command(context, props)
    context
    |> assign(tgt_file, "output.css")
    |> copy_file(props.source_file, props.tgt_file)
    |> git_commit("Add output.css to repo")
  end
end
```

Actions can be composed into Plug-like pipelines.

    context |> Action1(props) |> Action2(props)

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

The log shows data for each action in the tree.

### Atree Presentors

Atree Presentors are modules which take a context structure and generate output
in HTML, JSON, Markdown or other useful format.

### Atree Playbooks

Atree playbooks are yaml or json files for composing Actions.

```yaml
---
- action: Util.TextBlock
  props: 
    header: Introduction
    body: |
      This is an introductory paragraph for my HowTo Guide.
  children:
    - action: Util.Command
      auth:
        when: sky=blue
      props:
        instruction: "Create a setup directory"
        command: mkdir /tmp/setup_dir
        creates: /tmp/setup_dir
      children:
        - playbook: myprocedure1.json
          auth: 
            when: sky=dark
        - playbook: myprocedure2.json
        - action: Util.Command
          auth:
            when: sky=cloudy
    - action: Util.BlockInFile
      props:
        instruction: "Add this text"
        block_text: >
          config :myapp, :key, "value"
        tgt_file: config/config.exs
        check_for:
          - myapp
          - key
          - value
```

Notes:
- you can nest playbooks as children
- nested playbooks can only be used as leaf nodes

## Using Atree

### As a Mix Task

Use Atree as a mix task:

    $ mix atree help

You can generate output in markdown, html, and other format.

### The Atree Escript

The `atree` escript can be installed in order to use atree from any location in
your filesystem.

    $ git clone https://github.com/andy/uber_gen
    $ cd uber_gen
    $ mix do deps.get, compile, escript.build, escript.install --force

You can invoke an action from the command line:

    $ atree help

You can join actions together using pipes:

    $ atree <playbook1> [options] | atree <playbook2> [options]

### Custom Commands and Playbooks

Add `atree` as a dependency to your Elixir Repo:

    # mix.exs

    {:uber_gen, path: "~/src/uber_gen"}

Then `mix deps.get`, and you can write your own Commands.

    myapp/
      lib/
        atree/
          actions/
            my_action.ex
        myapp/
      priv
        playbooks/
          myplaybook.json

Then `mix atree list` to start using your custom actions and playbooks.

## Atree Configuration

You can optionally use the `~/.atree` directory for local configuration data.

- `~/.atree/playbooks` to save your local playbooks
- `~/.atree/config.yaml` to specify action and playbook search paths.
