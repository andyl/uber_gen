defmodule UberGen.Playbooks.Phx.LiveView do

  use UberGen.Playbook

  alias UberGen.Playbooks

  @shortdoc "ShortDoc for #{__MODULE__}"

  def run(_) do
    IO.puts "RUNNING #{__MODULE__}"
  end

  def help(_) do
    "HELP FOR #{__MODULE__}"
  end

  def children(_context, _options) do
    [
      Playbooks.ConfigSetting, 
      Playbooks.Mix.SetDeps, 
      Playbooks.Phx.RouterSettings
    ]
  end

  def call(context, _options) do
    context
  end

  def doc(_context, _options) do
    header = "LiveView Installation Guide"
    body   = """
    While Phoenix LiveView is under heavy development, the installation
    instructions are likely to change rapidly as well.  The instructions below
    will serve if you are installing the latest stable version from Hex.
    """
    %{header: header, body: body}
  end

  def test(_context, _options) do
    true
  end
end
