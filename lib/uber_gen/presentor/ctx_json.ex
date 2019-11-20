defmodule UberGen.Presentor.CtxJson do
  @moduledoc """
  Converts the context to an inspectable string.
  """

  alias UberGen.Ctx

  @doc """
  Generate JSON output for the Context.

  Raw input data is in nested map in `ctx.log` (the guide field).
  """
  @spec generate(Ctx.t()) :: String.t()
  def generate(ctx) do
    ctx
    |> Jason.encode!(pretty: true)
  end
end
