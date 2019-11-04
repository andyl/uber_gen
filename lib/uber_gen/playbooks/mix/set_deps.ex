defmodule UberGen.Playbooks.Mix.SetDeps do

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
    header = "HEADER FOR #{__MODULE__}"
    body   = "BODY FOR #{__MODULE__}"
    %{header: header, body: body}
  end

  def test(_context, _options) do
    true
  end
end
