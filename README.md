# cogen

Elixir Code Generator

## Background

This repo is to explore ideas for scriptable code generation in Elixir,
inspired by a thread on [Elixir Forum][f].  For now we're practicing "Readme
Driven Development", gathering feedback before deciding if it's worth it to
write the code.

[f]: https://elixirforum.com/t/what-would-you-think-about-a-new-web-framework-that-extends-phoenix-with-rails-like-or-django-like-built-in-features/26371/8

A professional Phoenix app typically uses many add-on packages - LiveView, Pow,
Bamboo, and the like.  Add-on packages often require manual configuration.
The problem: manual install instructions can be hard to follow.  Evidence of the
problem: innumerable `HowTos` with eye-watering detail.  Here are some
examples:

- [How to install Bootstrap on a Phoenix 1.4 project][1]
- [LiveView Installation][2]
- [Phoenix Authentication with Pow - Part 1][3]

[1]: https://elixirforum.com/t/what-would-you-think-about-a-new-web-framework-that-extends-phoenix-with-rails-like-or-django-like-built-in-features/26371/8
[2]: https://github.com/phoenixframework/phoenix_live_view/blob/master/guides/introduction/installation.md
[3]: https://experimentingwithcode.com/phoenix-authentication-with-pow-part-1/

Firstly - thank you authors for your invaluable HowTo guides!  Keep them coming!

But there are problems with "HowTo Driven Generation" (HDG):

- HDG is time consuming - some installations can literally take days
- Manual configuration is error-prone
- HDG instructions become out-of-date with tools
- HDG is a barrier to entry for new programmers
- HDG friction discourages new code exploration

@dimiarvp says: "Some of us are looking for ways to get the boring stuff out of
the way as quick as possible. I don’t get any fulfilment out of carefully
thinking about all possible states of an authentication system or file uploads.
This stuff should just be figured out once and for all, described in a
meta-programming universal language (state machines? flow diagrams?)."

Back in the old days, people did regression tests by hand.  Now we all know the
benefits of `automated tests`.

Back in the old days, we installed software dependencies by hand.  With tar
files!  Now we use `automated package management` tools.

Code generation that requires manual `HowTos` is still in stone-age.  We'd like
a world where every `HowTo` was accompanied by a generator script.  With a
single command, you could download and run the generator, then tweak and share
the generator with your friends.  

Cogen is scriptable `automated generation` for Elixir developers.

## Comparables

There are many comparables:
[Mix.Generate][mixgen],
[PragDave Generator][pdgen],
[Orats][orats],
[Exgen][exgen],
[Elixir Config][exconf], 
[Ansible][ansible], and more

Cogen extends `Mix.Generate`, and borrows ideas from other tools:
- from [Ansible][ansible] and [Mix.Generate][mixgen]: helper functions like `copy_file` and `update_line_in_file`
- from [Orats][orats]: git helper functions
- from [PragDave][pdgen]: template trees
- from [Ansible][ansible]: composable playbooks

[mixgen]:  https://hexdocs.pm/mix/Mix.Generator.html
[pdgen]:   https://pragdave.me/blog/2017/04/18/elixir-project-generator.html
[orats]:   https://github.com/nickjj/orats
[exgen]:   https://github.com/rwdaigle/exgen
[exconf]:  https://hexdocs.pm/elixir/master/Config.html
[ansible]: https://www.ansible.com/

## Installing Cogen

To install `cogen`:

    mix archive.install github andyl/cogen

Configure with `.cogen.exs`:

    import Cogen

    config :cogen, packages: [
      {:live_view_gen, "~> 0.4.0"},
      {:my_codegen, path: "~/src/CG/my_lv_tweaks"}
    ]

    include_cogen "~/.cogen/phoenix_css_setup.exs"

## The Cogen Framework

### Code Style

Cogen uses Elixir-style pipelines:

    cogen_context
    |> Cogen.mix("phx.new")
    |> Cogen.Bootstrap4.apply()
    |> MyCodegen.Bootstrap4.tweak()
    |> LiveViewGen.install()
    |> Cogen.mix("deps.get")
    |> Cogen.mix("test")

### Cogen Context

The Cogen Context is a Plug-like structure:

    %{
      app_name: "TBD"
    }

### Cogen Helpers 

Cogen helpers are conveniences for working with paths and generating content.

From Mix.Generate:

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
| config_setting | Add a setting to the application config                      |

### Cogen Playbooks

Playbooks are Elixir modules with task functions.

    defmodule MyCodegen.Bootstrap4 do
      use Codegen.Playbook

      @depends_on [Cogen, :setup]
      task tweak(ctx) do
        ctx
        |> assign(tgt_file, "output.css")
        |> copy_file(ctx.source_file, ctx.tgt_file)
        |> git_commit("Add output.css to repo")
      end
    end

### Cogen Packages

Cogen packages are Elixir dependencies.  Cogen will install the packages
on-demand, using `mix archive.install ...`

## Using Cogen

### Cogen as a Mix task

Cogen is accessible as a mix task:

    $ mix cogen --help

### Cogen Executable

Cogen is an escript that you can run on the command line or from a bash script:

    $ cogen --help

### Cogen Script 

Run Cogen directly in an executable script:

    #!/usr/bin/env cogen

    ...

### Cogen in Elixir Source

    defmodule MyMod do
      ...
    end

## Cogen Workflow

### With a HowTo Post

Authoring a HowTo Post:

- Author writes a blog post with manual install instructions
- Author creates gist with a Cogen generator script
- Author adds the address to the Cogen script to the blog post

Reading a HowTo Post:

- Reader views the post in the browser
- From the reader terminal: `$ cogen run https://gist.github.com/howto_script.cogen`
- Instant Working App 
- Pina Coladas
      
