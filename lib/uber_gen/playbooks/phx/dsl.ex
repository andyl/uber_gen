defmodule UberGen.Playbooks.Phx.Dsl do

  use UberGen.Playbook
  use UberGen.Pbook

  alias UberGen.Playbooks

  @shortdoc "ShortDoc for #{__MODULE__}"

  def run, do: run("asdf")

  def run(_) do
    IO.puts "RUNNING #{__MODULE__}"
    bong("ping", "pong") do
      IO.puts "INSIDE DONG"
    end
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
