defmodule Mix.Tasks.Ugen.Help do
  use Mix.Task

  alias UberGen.PlaybookUtil

  @moduledoc """
  Export a Playbook.

  Export a Playbook to Markdown, PDF, HTML, or ExDoc
  """

  @shortdoc "Export a playbook"
  def run(args) do
    arg = List.first(args)
    PlaybookUtil.loadpaths!()

    mod =
      UberGen.PlaybookMix.load_all()
      |> UberGen.PlaybookUtil.build_playbook_list()
      |> Enum.filter(&(elem(&1, 1) == arg))
      |> List.first()

    case mod do
      nil -> IO.puts("Playbook not found (#{arg})")
      {module, _label} -> IO.puts(Mix.Task.moduledoc(module) || "No documentation")
      _ -> "ERROR Help"
    end
  end
end
