defmodule UberGen.Playbooks.Mix.Deps do

  use UberGen.Playbook

  @moduledoc """
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  @doc """
  Generate guide for deps install.

  options:
  - instructions: an intro paragraph
  - deps: default dependency

  For example:

  ```elixir
  deps: [
    {:phoenix_live_view, "~> 0.3.0"},
    {:floki, ">= 0.0.0", only: :test}
  ]
  ```
  """
  guide(ctx, opts) do
    header = "Project Dependencies"
    body   = genbody(ctx, opts)
    %{header: header, body: body}
  end

  # -------------------------------------
  
  defp genbody(_ctx, opts) do
    intro_text = Keyword.get(opts, :instructions)
    dep_vals   = Keyword.get(opts, :deps, [])
    body_text = """
    ```elixir
    def deps do
    #{inspect(dep_vals) |> Code.format_string!(line_length: 40)}
    end
    ```
    """
    "#{intro_text}\n\n#{body_text}"
  end

end
