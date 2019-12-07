defmodule Atree.Actions.Env.All do
  use Atree.Action

  alias Atree.Actions.Env

  @moduledoc """
  Saves all env values to context.
  """

  @doc """
  Generate all environment values.
  """
  def children(_ctx, _props) do
    IO.inspect("ALL")
    [
      Env.Host,
      Env.Lang
    ]
  end
end
