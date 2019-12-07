defmodule Atree.Actions.Env.Host do
  use Atree.Action

  @moduledoc """
  Saves host values to context environment.
  """

  @doc """
  Save host environment values to context.

  Test on the command-line to see generated data:

      $ mix atree export env.host
  """
  def screen(ctx, _props) do
    IO.puts(:stderr, inspect(ctx, pretty: true))
    
    new_ctx =
      ctx
      |> setenv(:os_type, inspect(:os.type()))
      |> setenv(:os_version, inspect(:os.version()))

    %Atree.Data.Report{ctx: new_ctx}
  end
end
