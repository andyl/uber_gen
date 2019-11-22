defmodule UberGen.Actions.Test.MultiText do

  use UberGen.Action
  alias UberGen.Actions

  @moduledoc """
  Test playbook contains multiple `TextBlock` children.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  def children(_ctx, _opts) do
    [
      { Actions.Util.TextBlock, %{header: "asdf", body: "HELLO BODY"}},
      { Actions.Util.TextBlock, %{header: "nonc", body: "THIRD BODY"}, [
        { Actions.Util.TextBlock, %{header: "bong1", body: "NESTED1"}},
        { Actions.Util.TextBlock, %{header: "bong2", body: "NESTED2"}}
      ]},
      { Actions.Util.TextBlock, %{header: "qwer", body: "SECOND BODY"}}
    ]
  end

  def guide(_ctx, _opts) do
    %{
      header: "MultiText",
      body: "Just a simple test of MultiText"
    }
  end
end
