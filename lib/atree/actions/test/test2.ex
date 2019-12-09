defmodule Atree.Actions.Test.Test2 do

  use Atree.Action

  @moduledoc """
  Base playbook for testing
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  def children(_ctx, _opts) do
    "#{:code.priv_dir(:uber_gen)}/atree/playbooks/test2.yaml"
    |> Util.Playbook.file_data()
    |> Atree.Data.PlanAction.build()
  end

  def guide(_ctx, _opts) do
    header = "TEST2 HEADER"
    body   = """
    This is the TEST2 body.
    """
    %{header: header, body: body}
  end


end
