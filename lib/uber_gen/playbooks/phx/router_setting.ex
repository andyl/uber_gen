defmodule UberGen.Playbooks.Phx.RouterSettings do

  use UberGen.Playbook

  @moduledoc """
  ConfigSettings Playbook

  Extensive text on config settings goes here.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  run(ctx, _opts) do
    ctx
  end

  steps(_ctx, _opts) do
    []
  end

  guide(_ctx, _opts) do
    header = "HEADER FOR #{__MODULE__}"
    body   = "BODY FOR #{__MODULE__}"
    %{header: header, body: body}
  end

  test(_ctx, _opts) do
    true
  end
end
