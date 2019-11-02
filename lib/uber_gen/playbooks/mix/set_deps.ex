defmodule UberGen.Playbooks.Mix.SetDeps do

  use UberGen.Playbook

  @shortdoc "Set Mix Dependency"
  def run(args \\ []) do
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
    IO.puts "GEN PHOENIX"
    IO.inspect args
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
  end
end
