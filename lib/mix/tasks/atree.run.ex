defmodule Mix.Tasks.Atree.Run do
  use Mix.Task

  alias Atree.ActionUtil
  alias Atree.Executor.Run

  @moduledoc """
  Run a playbook on the command-line.

  Operates similar to Ansible - runs in the terminal, shows test status.

  Saves the context, so you can re-run and it remembers your previous actions.

  Optional: displays guide text for the failing step.
  """

  @shortdoc "Run a playbook"
  
  def run(argv) do
    {opts, vals, _rejects} = Mix.Atree.Util.parse(argv)
    tgt = List.first(vals)
    presentor = Mix.Atree.Util.presentor(opts[:format] || "ctx_inspect")

    ActionUtil.loadpaths!()

    mod =
      Atree.ActionMix.load_all()
      |> Atree.ActionUtil.build_playbook_list()
      |> Enum.filter(&(elem(&1, 1) == tgt))
      |> List.first()

    case mod do
      nil -> IO.puts "Action not found (#{tgt})"
      {module, _label} -> Run.with(module) |> presentor.generate() |> IO.puts()
      _ -> "ERROR Run"
    end
  end
end
