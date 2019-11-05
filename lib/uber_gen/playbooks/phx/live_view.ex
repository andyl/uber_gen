defmodule UberGen.Playbooks.Phx.LiveView do

  use UberGen.Playbook

  @shortdoc "ShortDoc for #{__MODULE__}"

  def run, do: run("asdf")

  def run(_) do
    IO.puts "RUNNING #{__MODULE__}"
  end

  call(ctx, opts) do
    ctx
    |> UberGen.Playbooks.ConfigSetting.call([])
    |> UberGen.Playbooks.Mix.SetDeps.call([])
    |> UberGen.Playbooks.Phx.RouterSettings.call([])
  end

  guide(ctx, opts) do
    header = "LiveView Installation Guide"
    body   = """
    While Phoenix LiveView is under heavy development, the installation
    instructions are likely to change rapidly as well.  The instructions below
    will serve if you are installing the latest stable version from Hex.
    """
    %{header: header, body: body}
  end

  test(ctx, opts) do
    true
  end
end
