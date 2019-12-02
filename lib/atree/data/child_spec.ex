defmodule Atree.Data.ChildSpec do
  @moduledoc """
  Atree ChildSpec.
  """

  alias Atree.Data.{AuthSpec, ChildSpec}

  @derive Jason.Encoder

  defstruct action: nil, props: nil, auth: nil, children: nil

  @type t :: %ChildSpec{
          action: any(),
          props: any(),
          auth: AuthSpec.t,
          children: any()
        }

  # --------------------------------------------------

  def to_childspec(input) when is_map(input) do
    mod = "Elixir.Atree.Actions.#{input[:action]}" |> String.to_existing_atom()
    props = input[:props] || input[:params] || %{}
    auths = input[:auths] || input[:auth] || []
    clist = input[:children] || []

    to_childspec(mod, props, auths, clist)
  end

  def to_childspec(input) when is_list(input) do
    input |> Enum.map(&to_childspec/1)
  end

  defp to_childspec(act, props, auths, []) do
    %ChildSpec{action: act, props: props, auth: auths, children: []}
  end

  defp to_childspec(act, props, auths, children) do
    offspring = children |> Enum.map(&to_childspec(&1))
    %ChildSpec{action: act, props: props, auth: auths, children: offspring}
  end

end
