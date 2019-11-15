defmodule Mix.Tasks.Ugen.Pb.Run do
  use Mix.Task

  alias UberGen.PlaybookUtil

  @moduledoc """
  Run a playbook on the command-line.

  Operates similar to Ansible - runs in the terminal, shows test status.

  Saves the context, so you can re-run and it remembers your previous actions.

  Optional: displays guide text for the failing step.
  """

  @shortdoc "Run a playbook"
  
  def run(args) do
    arg = List.first(args)
    PlaybookUtil.loadpaths!()

    mod =
      UberGen.PlaybookMix.load_all()
      |> UberGen.PlaybookUtil.build_playbook_list()
      |> Enum.filter(&(elem(&1, 1) == arg))
      |> List.first()

    case mod do
      nil -> IO.puts "Playbook not found (#{arg})"
      {module, _label} -> UberGen.Exec.Run.cmd(module)
      _ -> "ERROR Run"
    end
  end
end
