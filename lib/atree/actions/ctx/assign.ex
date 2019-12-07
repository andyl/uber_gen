defmodule Atree.Actions.Ctx.Assign do

  use Atree.Action

  @moduledoc """
  Assign values from props to context.
  """

  @doc """
  Save all options in context assigns.

  Usage In Children:

      {Ctx.Assign, %{a: 1, b: 2)}

  """
  def screen(ctx, props) do
    ctx2 = Enum.reduce(props, ctx, fn({key, val}, acc) -> assign(acc, key, val) end)
    %Atree.Data.Report{ctx: ctx2}
  end
end
