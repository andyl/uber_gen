defmodule Atree.Presentor.CtxInspect do
  @moduledoc """
  Converts the context to an inspectable string.
  """

  alias Atree.Data.Ctx

  @doc """
  Generate markdown output.

  Raw input data is in nested map in `ctx.log` (the guide field).
  """
  @spec generate(Ctx.t()) :: String.t()
  def generate(ctx) do
    ctx
    |> inspect(pretty: true)
  end
end
