# UberGen

UberGen is a scriptable code generator for Elixir, motivated by a thread on
[Elixir Forum][f].  Using `Readme Driven Development`, this doc contains
pseudocode for a possible implementation.  We will explore design alternatives
before committing to actually writing the code.  

[f]: https://elixirforum.com/t/what-would-you-think-about-a-new-web-framework-that-extends-phoenix-with-rails-like-or-django-like-built-in-features/26371/8

## Background

Professional Phoenix apps typically use many add-on packages like
[LiveView][lv], [Pow][pow], and [Bamboo][bb].  Add-on packages often require
manual installation.

[lv]:  https://github.com/phoenixframework/phoenix_live_view
[bb]:  https://github.com/thoughtbot/bamboo
[pow]: https://github.com/danschultzer/pow

**The problem:** manual install instructions can be hard to follow.  
**Evidence:** innumerable `HowTos` with complicated instructions.  
**Examples:**
- [How to install Bootstrap on a Phoenix 1.4 project][1] 
- [LiveView Installation][2] 
- [Phoenix Authentication with Pow - Part 1][3]

[1]: https://elixirforum.com/t/what-would-you-think-about-a-new-web-framework-that-extends-phoenix-with-rails-like-or-django-like-built-in-features/26371/8
[2]: https://github.com/phoenixframework/phoenix_live_view/blob/master/guides/introduction/installation.md
[3]: https://experimentingwithcode.com/phoenix-authentication-with-pow-part-1/

Firstly - thank you authors for your invaluable HowTo guides!  Keep them coming!

But there are problems with **HowTo Driven Generation**:

- time consuming - some installations can literally take days
- manual configuration is error-prone
- written instructions become out-of-date with tools
- no feedback mechanism for bugs and improvements
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
[Ansible][ansible], and more

UberGen extends `Mix.Generate`, and borrows ideas from other tools:
- from [Mix.Generate][mixgen]: helper functions like `copy_file` 
- from [PragDave][pdgen]: template trees, template installation and discovery
- from [Ansible][ansible]: idempotent helper functions, composable playbooks
- from [Orats][orats]: git helper functions
- from [Exercism][exer]: guided refactoring
- from [Ansible][ansible], the playbook execution model

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
[ansible]: https://www.ansible.com/

## Installing UberGen

To install `uber_gen`:

    mix archive.install github andyl/uber_gen

Configure with `.uber_gen.exs`: [DROP?]

    import UberGen

    config :uber_gen, playbooks: [
      {:live_view_gen, "~> 0.4.0"},
      {:my_codegen, path: "~/src/CG/my_lv_tweaks"}
    ]

    include_uber_gen "~/.uber_gen/phoenix_css_setup.exs"

## The UberGen Framework

### Code Style

UberGen scripts and playbooks use Plug-like pipelines:

    uber_gen_context
    |> UberGen.mix("phx.new")
    |> UberGen.Bootstrap4.apply()
    |> MyCodegen.Bootstrap4.tweak()
    |> LiveViewGen.install()
    |> UberGen.mix("deps.get")
    |> UberGen.mix("test")

### UberGen Context

The UberGen Context is a Plug-like structure:

    %{
      app_name: "TBD"
    }

### UberGen Command Helpers 

UberGen command helpers are conveniences for working with paths and generating content.

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

There probably should be refactoring functions that work on other languages:
- CSS
- JSON
- JavaScript
- etc.

### UberGen Playbooks

Playbooks are structured like Mix tasks - one module per playbook.

    defmodule UberGen.Playbooks.Myapp.Bootstrap4 do
      use UberGen.Playbook

      @depends_on [UberGen, :setup]
      @shortdoc "Install Bootstrap4 in your Phoenix project."
      task run(ctx, _opts) do
        ctx
        |> assign(tgt_file, "output.css")
        |> copy_file(ctx.source_file, ctx.tgt_file)
        |> git_commit("Add output.css to repo")
      end
    end

UberGen playbooks are packaged in a standard Elixir application.  There can be
many playbooks per application.  Playbooks can have dependencies.  UberGen will
install playbook packages using the same loading techniques that are used for
Mix tasks.

    myapp/
      lib/
        mix/
          tasks/
            mytask.ex
        uber_gen
          playbooks/
            myapp/
              bootstrap4.ex
      priv/
        playbooks/
          apps/ 
            bootstrap4/
              files/
                bootstrap_config.css
              templates/
                bootstrap.css.eex

Playbook static files and templates are stored under the `priv/playbooks`
directory.

## Using UberGen

### As a Mix Task

UberGen is accessible as a mix task:

    $ mix ugen.help
    $ mix ugen.run <playbook> <options>
    $ mix ugen.playbook list
    $ mix ugen.playbook install <playbook>
    $ mix ugen.playbook remove <playbook>
    $ mix ugen.playbook export <playbook>
    $ mix ugen.playbook run <playbook>

### The UberGen eScript

The `uber_gen` executable reads playbook configs from `yaml` or `json` files.

    $ uber_gen <playbook>.yaml export
    $ uber_gen <playbook>.yaml serve
    $ uber_gen <playbook>.yaml run

### UberGen in Elixir Source

    defmodule MyMod do
      ...
    end

## UberGen Workflow

### With a HowTo Post

Authoring a HowTo Post:

- Author writes a blog post with manual install instructions
- Author creates gist with a UberGen generator script
- Author adds the address of the UberGen script to the blog post

Reading a HowTo Post:

- Reader views the post in the browser
- From the reader terminal: `$ uber_gen run https://gist.github.com/howto_script.uber_gen`
- Instant Working App 
- Pina Coladas

## Playbook Commands

Export - Just output a static doc (Markdown, PDF, ExDoc)

Run - CLI checks your environment every run
- generates guide text
- validates each step

Serve - starts a webserver and a file watcher
