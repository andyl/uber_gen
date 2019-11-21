defmodule UberGen.Presentor.GuideMarkdown do
  @moduledoc """
  Generates Markdown output.
  """

  alias UberGen.Data.Ctx

  @doc """
  Generate Guide Markdown output.

  Raw input data is in nested map in `ctx.log` (the guide field).
  """
  @spec generate(Ctx.t()) :: String.t()
  def generate(ctx) do
    to_s(ctx.log, 1)
    |> String.replace(~r/\n\n[\n]+/, "\n\n")
  end

  defp to_s(%{children: []} = log, depth) do
    output(log, depth)
  end

  defp to_s(log, depth) do
    base = output(log, depth) <> "\n\n"

    alt =
      log.children
      |> Enum.map(&to_s(&1, depth + 1))
      |> Enum.join("\n\n")

    base <> alt
  end

  defp output(log, depth) do
    doc = log.guide
    hdr = String.duplicate("#", depth)
    block_text(hdr, doc)
  end

  defp block_text(hdr, %{header: header, body: body}), do: "#{hdr} #{header}\n\n#{body}"
  defp block_text(hdr, %{header: header}), do: "#{hdr} #{header}"
  defp block_text(_hdr, %{body: body}), do: body
  defp block_text(_hdr, %{}), do: ""
  defp block_text(_hdr, body), do: body
end
