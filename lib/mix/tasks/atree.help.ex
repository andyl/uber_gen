defmodule Mix.Tasks.Atree.Help do
  use Mix.Task

  alias Atree.Util.Util

  @moduledoc """
  Export a Action.

  Export a Action to Markdown, PDF, HTML, or ExDoc
  """

  @shortdoc "Export a playbook"
  def run(args) do
    arg = List.first(args)

    mod =
      Atree.Util.Mix.load_all()
      |> Atree.Util.Util.build_playbook_list()
      |> Enum.filter(&(elem(&1, 1) == arg))
      |> List.first()

    case mod do
      nil -> IO.puts("Action not found (#{arg})")
      {module, _label} -> IO.puts(Mix.Task.moduledoc(module) || "No documentation")
      _ -> "ERROR Help"
    end
  end
end
