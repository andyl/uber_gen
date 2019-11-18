defmodule UberGen.Actions.Test.Base2 do

  use UberGen.Action

  @moduledoc """
  Base playbook for testing
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  def guide(_ctx, _opts) do
    "GUIDE FOR Base2"
  end
end
