defmodule UberGen.Playbooks.Gen.Phx do

  use UberGen.Playbook

  @shortdoc "Gen phoenix project"
  def run(args \\ []) do
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
    IO.puts "GEN PHOENIX"
    IO.inspect args
    IO.inspect "+++++++++++++++++++++++++++++++++++++++"
  end
end
