defmodule Atree.Actions.Env.Host do
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
    {:ok, hostname} = :inet.gethostname()
    new_ctx =
      ctx
      |> setenv(:os_type, inspect(:os.type()))
      |> setenv(:os_version, inspect(:os.version()))
      |> setenv(:user_home, System.user_home())
      |> setenv(:tmp_dir, System.tmp_dir())
      |> setenv(:hostname, List.to_string(hostname))

    %Atree.Data.Report{ctx: new_ctx}
  end
end
