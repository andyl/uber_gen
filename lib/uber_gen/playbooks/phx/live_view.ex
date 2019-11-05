defmodule UberGen.Playbooks.Phx.LiveView do
  use UberGen.Playbook

  alias UberGen.Playbooks

  @shortdoc "ShortDoc for #{__MODULE__}"

  run(_) do
    IO.puts("RUNNING #{__MODULE__}")
  end

  steps(_ctx, _opts) do
    [
      Playbooks.ConfigSetting,
      {Playbooks.Mix.SetDeps, [a: 1, b: 2]},
      Playbooks.Phx.RouterSettings
    ]
  end

  guide(_ctx, _opts) do
    header = "LiveView Installation Guide"

    body = """
    While Phoenix LiveView is under heavy development, the installation
    instructions are also likely to change rapidly.  The instructions below
    will serve if you are installing the latest stable version from Hex.
    """

    %{header: header, body: body}
  end

  test(_ctx, _opts) do
    true
  end
end
