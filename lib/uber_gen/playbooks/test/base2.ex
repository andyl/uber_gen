defmodule UberGen.Playbooks.Test.Base2 do

  use UberGen.Playbook

  @moduledoc """
  Base playbook for testing
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  def guide(_ctx, _opts) do
    "GUIDE FOR Base2"
  end
end
