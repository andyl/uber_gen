defmodule Atree.Actions.Env.All do
  use Atree.Action

  alias Atree.Actions.Env

  @moduledoc """
  Saves all env values to context.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  @doc """
  Generate all environment values.
  """
  def children(_ctx, _props) do
    [
      Env.Exec,
      Env.Host,
      Env.Lang
    ]
  end
end
