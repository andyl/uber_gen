defmodule Mix.Tasks.Ugen.Pb.Serve do
  use Mix.Task

  alias UberGen.PlaybookUtil

  @moduledoc """
  Serves a Playbook - similar to Jekyll serve.

  Watches the filesystem & updates status when files change.
  """

  @shortdoc "Serves a playbook"
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
      {module, _label} -> module.run([])
      _ -> "ERROR run"
    end
  end
end
