defmodule Mix.Tasks.Ugen.Export do
  use Mix.Task

  alias UberGen.ActionUtil

  @moduledoc """
  Export a Action.

  Export a Action to Markdown, PDF, HTML, or ExDoc
  """

  @shortdoc "Export a playbook"
  def run(args) do
    arg = List.first(args)
    ActionUtil.loadpaths!()

    mod =
      UberGen.ActionMix.load_all()
      |> UberGen.ActionUtil.build_playbook_list()
      |> Enum.filter(&(elem(&1, 1) == arg))
      |> List.first()

    case mod do
      nil -> IO.puts("Action not found (#{arg})")
      {module, _label} -> IO.puts(UberGen.Executor.Export.guide(module))
      _ -> "ERROR Export"
    end
  end
end
