defmodule UberGen.Playbooks.Util.TextBlock do

  use UberGen.Playbook

  @moduledoc """
  Basic Text Block.

  Basic text block.  No code, no tests.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  params do
    field(:header, :string)
    field(:body,   :string)
  end

  changeset(params) do
    %__MODULE__{}
    |> cast(params, [:header, :body])
  end

  @doc """
  Guide text.
  """
  guide(_ctx, opts) do
    opts
  end
end
