defmodule UberGen.Playbooks.Phx.RouterSettings do

  use UberGen.Playbook

  @shortdoc "ShortDoc for #{__MODULE__}"

  def run(_) do
    IO.puts "RUNNING #{__MODULE__}"
  end

  def help(_) do
    "HELP FOR #{__MODULE__}"
  end

  def children(_context, _options) do
    []
  end

  def call(context, _options) do
    context
  end

  def doc(_context, _options) do
    "DOCUMENTATION FOR #{__MODULE__}"
  end

  def test(_context, _options) do
    true
  end
end
