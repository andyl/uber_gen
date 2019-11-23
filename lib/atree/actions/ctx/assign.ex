defmodule Atree.Actions.Ctx.Assign do

  use Atree.Action

  @moduledoc """
  Assign values from params to context.
  """

  @doc """
  Save all options in context assigns.

  Usage In Children:

      {Ctx.Assign, %{a: 1, b: 2), []}

  """
  def inspect(ctx, opts) do
    ctx2 = Enum.reduce(opts, ctx, fn({key, val}, acc) -> assign(acc, key, val) end)
    %Atree.Data.Report{ctx: ctx2}
  end
end
