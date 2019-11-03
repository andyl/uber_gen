defmodule Mix.Tasks.Ugen.Pb.Build do
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

    case mod do
      nil -> IO.puts "Playbook not found (#{arg})"
      {module, _label} -> IO.puts build(module)
      _ -> "ERROR run"
    end
  end

  defp build(module) do
    build(module, module.children(%{}, []), 1)
  end

  defp build(module, [], depth) do
    output(module, depth)
  end

  defp build(module, children, depth) do
    base = output(module, depth) <> "\n\n" 
    alt  = children
           |> Enum.map(&(build(&1, &1.children(%{}, []), depth + 1)))
           |> Enum.join("\n\n")
    base <> alt
  end

  defp output(module, depth) do
    doc = module.doc(%{}, [])
    hdr = String.duplicate("#", depth)
    "#{hdr} #{doc.header}\n\n#{doc.body}"
  end

end
