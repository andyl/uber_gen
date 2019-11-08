defmodule UberGen.Playbooks.Phx.LiveView do

  use UberGen.Playbook

  alias UberGen.Playbooks

  @moduledoc """
  ConfigSettings Playbook

  Extensive text on config settings goes here.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  run(_) do
    IO.puts "RUNNING #{__MODULE__}"
  end

  steps(_ctx, _opts) do
    [
      { Playbooks.Mix.Deps,         dep_opts()   },
      { Playbooks.Util.TextBlock,   text_opts()  },
      { Playbooks.Util.BlockInFile, cfg_opts()   },
      { Playbooks.Util.BlockInFile, flash_opts() },
      { Playbooks.Util.BlockInFile, npm_opts()   },
      Playbooks.Phx.RouterSettings
    ]
  end

  guide(_ctx, _opts) do
    header = "LiveView Installation Guide"
    body   = """
    While Phoenix LiveView is under heavy development, the installation
    instructions are likely to change rapidly as well.  The instructions below
    will serve if you are installing the latest stable version from Hex.
    """
    %{header: header, body: body}
  end

  # -----------------------------------------------------------

  defp dep_opts do
    instruction_text = """
    installing from Hex, use the latest version from there:
    """
    [
      instructions: instruction_text,
      deps: [
        {:phoenix_live_view, "~> 0.3.0"},
        {:floki, ">= 0.0.0", only: :test}
      ]
    ]
  end
 
  defp text_opts do
    [
      text_block: """
      If you want the latest features, install from GitHub:
      
      ```elixir
      def deps do
        [
          {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
          {:floki, ">= 0.0.0", only: :test}
        ]
      ```
      """
    ]
  end

  defp cfg_opts do
    [
      instruction: """
      Once installed, update your endpoint's configuration to 
      include a signing salt.  You can generate a signing salt 
      by running `mix phx.gen.secret 32`.
      """,
      text_block: """
      config :my_app, MyAppWeb.Endpoint,
        live_view: [
          signing_salt: "SECRET_SALT"
        ]
      """,
      check_for: ["live_view", "signing_salt"],
      target_file: "config/config.exs"
    ]
  end

  defp flash_opts do
    [
      instruction: """
      Next, add the LiveView flash plug to your browser pipeline, after `:fetch_flash`:
      """,
      text_block: """
      pipeline :browser do
        ...
        plug :fetch_flash
        plug :Phoenix.LiveView.Flash
      end
      """,
      check_for: ["Phoenix.LiveView.Flash"],
      target_file: "lib/my_app_web/router.ex"
    ]
  end

  defp npm_opts do
    fname = "assets/package.json"
    [
      instruction: """
      Add LiveView NPM dependencies in your `#{fname}`. For a regular project, do:
      """,
      text_block: """
      {
        "dependencies": {
          "phoenix": "file:../deps/phoenix",
          "phoenix_html": "file:../deps/phoenix_html",
          "phoenix_live_view": "file:../deps/phoenix_live_view"
        }
      }
      """,
      check_for: ["phoenix_live_view", "phoenix_html"],
      target_file: fname
    ]
  end
end
