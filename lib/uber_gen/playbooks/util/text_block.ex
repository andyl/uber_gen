defmodule UberGen.Playbooks.Util.TextBlock do

  use UberGen.Playbook

  @moduledoc """
  Basic Text Block.

  Basic text block.  No code, no tests.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  @doc """
  Guide block.

  Required option: 
  - text_block
  """
  guide(_ctx, opts) do
    Keyword.get(opts, :text_block)
  end
end
