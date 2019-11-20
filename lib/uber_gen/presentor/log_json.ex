defmodule UberGen.Presentor.LogJson do
  @moduledoc """
  Converts the context to an inspectable string.
  """

  alias UberGen.Ctx

  @doc """
  Inspect ctx log.
  """
  @spec generate(Ctx.t()) :: String.t()
  def generate(ctx) do
    ctx.log
    |> Jason.encode!(pretty: true)
  end
end
