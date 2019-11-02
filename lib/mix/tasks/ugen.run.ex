defmodule Mix.Tasks.Ugen.Run do
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

    IO.inspect("=======================================")
    IO.inspect(arg)
    IO.inspect(mod)
    IO.inspect("=======================================")

    case mod do
      nil -> IO.puts "Playbook not found (#{arg})"
      {module, label} -> module.run()
      _ -> "ERROR run"
    end
  end
end