defmodule Mix.Tasks.Ugen.Pb.Run do
  use Mix.Task
  # use UberGen.Playbook

  alias UberGen.PlaybookUtil

  @shortdoc "Run a playbook"
  def run(args) do
    arg = List.first(args)
    PlaybookUtil.loadpaths!()

    mod =
      UberGen.Playbook.load_all()
      |> UberGen.PlaybookUtil.build_playbook_list()
      |> Enum.filter(&(elem(&1, 1) == arg))
      |> List.first()

    case mod do
      nil -> IO.puts "Playbook not found (#{arg})"
      {module, _label} -> module.run()
      _ -> "ERROR run"
    end
  end
end
