defmodule UberGen.Playbooks.Phx.RouterSetting do

  use UberGen.Playbook

  @shortdoc "Phoenix Router Setting"
  def run do
    IO.puts "HELLO WORLD"
  end

  def run(_) do
    IO.puts "HIHIHI"
  end

  def doc(_context, _options) do
  end

  def call(_context, _options) do
  end

  def test(_context, _options) do
    true
  end

  def template do
    "HELLO WORLD"
  end
end
