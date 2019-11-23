defmodule Mix.Tasks.Atree.Tailor do
  use Mix.Task

  alias Atree.ActionUtil
  alias Atree.Executor.Tailor

  @moduledoc """
  Taior an Action guide to your codebase.

  Tailor a Action Guide and emit to Markdown, PDF, HTML, etc.

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
    {opts, vals, _rejects} = Mix.Atree.Util.parse(argv)
    tgt = List.first(vals)
    presentor = Mix.Atree.Util.presentor(opts[:format] || "guide_markdown") 

    ActionUtil.loadpaths!()

    mod =
      Atree.ActionMix.load_all()
      |> Atree.ActionUtil.build_playbook_list()
      |> Enum.filter(&(elem(&1, 1) == tgt))
      |> List.first()

    case mod do
      nil -> IO.puts("Action not found (#{tgt})")
      {module, _label} -> module |> Tailor.with() |> presentor.generate() |> IO.puts()
      _ -> "ERROR Export"
    end
  end
end
