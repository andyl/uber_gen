defmodule UberGen.Playbooks.Test.Parent1 do

  use UberGen.Playbook
  alias UberGen.Playbooks

  @moduledoc """
  Test playbook contains multiple `TextBlock` steps.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  steps(_ctx, _opts) do
    [
      { Playbooks.Util.TextBlock, %{header: "asdf", body: "HELLO BODY"}},
      { Playbooks.Util.TextBlock, %{header: "nonc", body: "THIRD BODY"}, [
        { Playbooks.Util.TextBlock, %{header: "bong1", body: "NESTED1"}},
        { Playbooks.Util.TextBlock, %{header: "bong2", body: "NESTED2"}}
      ]},
      { Playbooks.Util.TextBlock, %{header: "qwer", body: "SECOND BODY"}}
    ]
  end

  guide(ctx, opts) do
    %{
      header: "MultiText",
      body: "Just a simple test of MultiText"
    }
  end
end
