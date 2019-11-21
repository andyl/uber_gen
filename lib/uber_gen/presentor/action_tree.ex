defmodule UberGen.Presentor.ActionTree do
  @moduledoc """
  Shows an Action Tree
  """

  alias UberGen.Data.Ctx

  @doc """
  Generate markdown output.

  Raw input data is in nested map in `ctx.log` (the guide field).
  """
  @spec generate(Ctx.t()) :: String.t()
  def generate(ctx) do
    to_s(ctx.log, 1)
  end

  defp to_s(%{children: []} = log, depth) do
    output(log, depth)
  end

  defp to_s(log, depth) do
    base = output(log, depth) <> "\n"

    alt =
      log.children
      |> Enum.map(&to_s(&1, depth + 1))
      |> Enum.join("\n")

    base <> alt
  end

  defp output(log, depth) do
    mod = log.action
    hdr = String.duplicate("-", depth)
    "#{hdr} #{mod}"
  end
end
