defmodule Mix.Tasks.Atree do
  use Mix.Task

  @moduledoc """
  Perform all Atree actions.
  """

  @shortdoc "Atree!"

  def run(args) do
    args
    |> Atree.Cli.main()
  end
end
