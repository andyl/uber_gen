defmodule Mix.Tasks.Ugen.Build do
  use Mix.Task
  # use UberGen.Playbook

  alias UberGen.PlaybookUtil

  @shortdoc "Build a playbook"
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
      {module, label} -> module.build()
      _ -> "ERROR run"
    end
  end
end
