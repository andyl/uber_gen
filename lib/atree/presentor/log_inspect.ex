defmodule Atree.Presentor.LogInspect do
  @moduledoc """
  Converts the context to an inspectable string.
  """

  alias Atree.Data.Ctx

  @doc """
  Inspect ctx log.
  """
  @spec generate(Ctx.t()) :: String.t()
  def generate(ctx) do
    ctx.log
    |> inspect(pretty: true)
  end
end
