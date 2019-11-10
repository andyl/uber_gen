defmodule Mix.Tasks.Ugen.Pb.Export do
  use Mix.Task

  alias UberGen.PlaybookUtil

  @moduledoc """
  Export a Playbook.

  Export a Playbook to Markdown, PDF, HTML, or ExDoc
  """

  @shortdoc "Export a playbook"
  def run(args) do
    arg = List.first(args)
    PlaybookUtil.loadpaths!()

    mod =
      UberGen.PlaybookMix.load_all()
      |> UberGen.PlaybookUtil.build_playbook_list()
      |> Enum.filter(&(elem(&1, 1) == arg))
      |> List.first()

    case mod do
      nil -> IO.puts("Playbook not found (#{arg})")
      {module, _label} -> IO.puts(build(module))
      _ -> "ERROR run"
    end
  end

  defp build(module) do
    build({module, []}, module.steps(%{}, []), 1)
    |> String.replace(~r/\n\n[\n]+/, "\n\n")
  end

  defp build({module, opts}, [], depth) do
    output({module, opts}, depth)
  end

  defp build({module, opts}, children, depth) do
    base = output({module, opts}, depth) <> "\n\n"

    alt =
      children
      |> Enum.map(&child_module/1)
      |> Enum.map(&build(&1, elem(&1, 0).steps(%{}, []), depth + 1))
      |> Enum.join("\n\n")

    base <> alt
  end

  defp child_module({module, opts}), do: {module, opts}
  defp child_module(module), do: {module, []}

  defp output({module, opts}, depth) do
    doc = module.guide(%{}, opts)
    hdr = String.duplicate("#", depth)
    block_text(hdr, doc) 
  end

  defp block_text(hdr,  %{header: header, body: body}), do: "#{hdr} #{header}\n\n#{body}"
  defp block_text(hdr,  %{header: header})            , do: "#{hdr} #{header}"
  defp block_text(_hdr, %{body: body})                , do: body
  defp block_text(hdr,  [header: header, body: body]) , do: "#{hdr} #{header}\n\n#{body}"
  defp block_text(hdr,  [header: header])             , do: "#{hdr} #{header}"
  defp block_text(_hdr, [body: body])                 , do: body
  defp block_text(_hdr, body)                         , do: body
end
