defmodule Atree.Presentor.GuideMarkdown do
  @moduledoc """
  Generates Markdown output.
  """

  alias Atree.Data.Ctx

  @doc """
  Generate Guide Markdown output.

  Raw input data is in nested map in `ctx.log` (the guide field).
  """
  @spec generate(Ctx.t()) :: String.t()
  def generate(ctx) do
    ctx.log
    |> Enum.map(&process_one_log/1)
    |> Enum.join("\n\n")
    |> String.replace(~r/\n\n[\n]+/, "\n\n")
    |> String.replace(~r/^[\n]+/, "")
  end
  
  defp process_one_log(log) do
    to_s(log, 1) || ""
    |> String.replace(~r/\n\n[\n]+/, "\n\n")
  end

  defp to_s(%{children: []} = log, depth) do
    output(log, depth)
  end

  defp to_s(log, depth) do
    base = output(log, depth) <> "\n\n"

    count = if Regex.match?(~r/Null/, Atom.to_string(log[:action])) do
      0
    else
      1
    end 

    alt =
      log.children
      |> Enum.map(&to_s(&1, depth + count))
      |> Enum.join("\n\n")

    base <> alt
  end

  defp output(log, depth) do
    doc = log.guide
    hdr = String.duplicate("#", depth)
    block_text(hdr, doc)
  end

  defp block_text(_hdr, %{header: "", body: body}), do: body
  defp block_text(_hdr, %{header: nil, body: body}), do: body
  defp block_text(hdr, %{header: header, body: body}), do: "#{hdr} #{header}\n\n#{body}"
  defp block_text(hdr, %{header: header}), do: "#{hdr} #{header}"
  defp block_text(_hdr, %{body: body}), do: body
  defp block_text(_hdr, %{}), do: ""
  defp block_text(_hdr, body), do: body
end
