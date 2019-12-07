defmodule Atree.Actions.Env.Exec do
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
    {:ok, cwd} = File.cwd()
    new_ctx =
      ctx
      |> setenv(:utc_time, inspect(Time.utc_now()))
      |> setenv(:cwd, cwd)

    %Atree.Data.Report{ctx: new_ctx}
  end
end
