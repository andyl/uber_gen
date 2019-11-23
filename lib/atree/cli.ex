defmodule Atree.Cli do
  def main(args \\ []) do
    opts = args |> parse_args()

    opts.filename 
    |> Util.Children.file_data()
    |> Util.Children.to_children()
    |> process(opts.command)
  end

  # --------------------------------------------------

  def process(data, "export") do
    Atree.Executor.Export.with(data)
    |> Atree.Presentor.GuideMarkdown.generate()
    |> IO.puts()
  end

  def process(data, "run") do
    Atree.Executor.Run.with(data)
    |> Atree.Presentor.GuideMarkdown.generate()
    |> IO.puts()
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
      filetype: Enum.at(words, 0) |> Util.Children.file_type(),
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
    IO.puts("Usage: atree <file> [export|run]")
    System.halt()
  end
end
