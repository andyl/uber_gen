defmodule Atree.Actions.Env.Lang do
  use Atree.Action

  @moduledoc """
  Saves host values to context environment.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  @doc """
  Save host environment values to context.

  Test on the command-line to see generated data:

      $ mix atree export env.host
  """
  def screen(ctx, _props) do
    new_ctx =
      ctx
      |> setenv(:lang_name, "Elixir")
      |> setenv(:lang_version, System.version())

    %Atree.Data.Report{ctx: new_ctx}
  end
end
