defmodule Atree.Executor.Util.Auth do
  @moduledoc """
  Authorization checks.

  Auth options:
  - when
  - unless
  """

  def check(ctx, plan = %Atree.Data.PlanAction{auth: auth}) do
    validate(ctx, plan, auth)
  end

  defp validate(_ctx, _plan, %{when: nil, unless: nil}), do: true 

  defp validate(_ctx, _plan, %{when: expression}) do
    inspect(expression, pretty: true) |> IO.puts()
    true
  end

  defp validate(_ctx, _plan, _auth), do: true
end
