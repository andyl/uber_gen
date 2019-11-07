defmodule UberGen.Playbooks.Mix.Deps do

  use UberGen.Playbook

  @moduledoc """
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  call(ctx, opts) do
    ctx
  end

  test(_context, _options) do
    true
  end

  guide(_context, _options) do
    header = "HEADER FOR #{__MODULE__}"
    body   = "BODY FOR #{__MODULE__}"
    %{header: header, body: body}
  end
end
