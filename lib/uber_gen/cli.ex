defmodule UberGen.Cli do
  def main(args \\ []) do
    opts = args |> parse_args()

    opts
    |> file_data()
    |> to_steps()
    |> process(opts.command)
  end

  # --------------------------------------------------

  def process(data, "export") do
    IO.puts(UberGen.Exec.Export.build(data, 1))
  end

  def process(_data, "run") do
    IO.puts "RUNNING DATA (UNDER CONSTRUCTION)"
  end
  
  # --------------------------------------------------

  defp parse_args(args) do
    words = args |> OptionParser.parse(strict: []) |> elem(1)
    opts = extract_opts(words)
    validate_opts(opts)
    opts
  end

  defp extract_opts(words) do
    validate_word_count(words)

    %{
      filename: Enum.at(words, 0),
      filetype: Enum.at(words, 0) |> String.split(".") |> List.last(),
      command: Enum.at(words, 1)
    }
  end

  defp validate_word_count(words) do
    if Enum.count(words) != 2, do: abort()
  end

  defp validate_opts(opts) do
    unless File.exists?(opts.filename) do
      abort("Error: file doesn't exist (#{opts.filename})")
    end

    unless Enum.member?(["json", "yaml"], opts.filetype) do
      abort("Invalid filetype (#{opts.filetype}) needs '.json' or '.yaml'")
    end

    unless Enum.member?(["export", "run"], opts.command) do
      abort()
    end
  end

  defp abort(message) do
    IO.puts(message)
    System.halt()
  end

  defp abort do
    IO.puts("Usage: uber_gen <file> [export|run]")
    System.halt()
  end

  # --------------------------------------------------

  defp file_data(opts) do
    file_data(opts.filename, opts.filetype)
    |> Util.Svc.convert_to_atom_map()
  end

  defp file_data(filename, "json") do
    filename
    |> Path.expand()
    |> File.read!()
    |> Jason.decode!()
  end

  defp file_data(filename, "yaml") do
    filename
    |> Path.expand()
    |> YamlElixir.read_from_file!()
  end

  # --------------------------------------------------

  defp to_steps(input) do
    mod = "Elixir.UberGen.Playbooks.#{input[:playbook]}" |> String.to_existing_atom()
    opt = input[:params] || %{}
    chr = input[:steps] || %{}
    to_steps(mod, opt, chr)
  end

  defp to_steps(mod, opt, []) do
    {mod, opt, []}
  end

  defp to_steps(mod, opt, children) do
    offspring = children |> Enum.map(&to_steps(&1))
    {mod, opt, offspring}
  end
end
