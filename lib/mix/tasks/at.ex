defmodule Mix.Tasks.At do
  use Mix.Task

  alias Atree.Util.Util

  @moduledoc """
  Perform all Atree actions.
  """

  @shortdoc "Atree!"

  def run(args) do
    args
    |> Atree.Cli.main()
  end
end
