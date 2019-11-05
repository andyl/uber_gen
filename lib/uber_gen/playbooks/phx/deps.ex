defmodule UberGen.Playbooks.Phx.Deps do
  use UberGen.Playbook

  @shortdoc "ShortDoc for #{__MODULE__}"

  alias UberGen.Playbooks

  def run(_) do
    IO.puts("RUNNING #{__MODULE__}")
  end

  steps do
    []
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
