defmodule Mix.Tasks.Ugen.Playbook do
  use Mix.Task

  @shortdoc "sayHI"
  def run(args) do
    IO.inspect "---------------------------------------"
    IO.inspect args
    IO.inspect "---------------------------------------"

    case List.first(args) do
      "list" -> IO.puts "LIST"
      "run"  -> IO.puts "RUN"
      arg -> IO.puts "Unrecognized argument (#{arg})"
    end
  end
end
