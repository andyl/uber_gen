defmodule Mix.Tasks.Ugen.Export do
  use Mix.Task

  alias UberGen.ActionUtil
  alias UberGen.Executor.Export

  @moduledoc """
  Export a Action.

  Export a Action to Markdown, PDF, HTML, or ExDoc

  Options:
    --format <format>   # output with an alternative format

  Valid formats:
    - action_tree    # show the tree of actions
    - ctx_inspect    # dump the entire raw context
    - ctx_json       # dump the entire context as json
    - guide_html     # HTML format
    - guide_markdown # markdown format
    - log_inspect    # dump the entire log
    - log_json       # dump the entire log as json

  """

  @shortdoc "Export a playbook"
  def run(argv) do
    {opts, vals, _rejects} = Mix.UberGen.Util.parse(argv)
    tgt = List.first(vals)
    presentor = Mix.UberGen.Util.presentor(opts[:format] || "guide_markdown") 

    ActionUtil.loadpaths!()

    mod =
      UberGen.ActionMix.load_all()
      |> UberGen.ActionUtil.build_playbook_list()
      |> Enum.filter(&(elem(&1, 1) == tgt))
      |> List.first()

    case mod do
      nil -> IO.puts("Action not found (#{tgt})")
      {module, _label} -> module |> Export.with() |> presentor.generate() |> IO.puts()
      _ -> "ERROR Export"
    end
  end
end
