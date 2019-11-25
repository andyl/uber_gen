defmodule Atree.Cli do
  def main(args \\ []) do
    args
    |> parse_args()
    |> setup_args()
    |> process()
  end

  # --------------------------------------------------

  def process(data = %{method: "export"}) do
    Atree.Executor.Export.with_action(data.context, data.action)
    |> Atree.Presentor.CtxJson.generate()
    |> IO.puts()
  end

  def process(data = %{method: "run"}) do
    Atree.Executor.Run.with_action(data.context, data.action)
    |> Atree.Presentor.CtxJson.generate()
    |> IO.puts()
  end

  def process(data) do
    IO.inspect(data)
    IO.puts("No method found")
  end

  # --------------------------------------------------
  # TODO: 
  # - if input is a playbook, ignore the params
  # - if input is an action, use the params (if they exist)
  # - write output files
  # --------------------------------------------------

  defp setup_args(args) do
    %{
      method: args.method || "export",
      stdout: args.stdout || "ctx_json",
      context: setup_context(args),
      action: setup_action(args),
      writes: args.writes
    }
  end

  defp setup_context(%{context: nil}) do
    %Atree.Data.Ctx{}
  end

  defp setup_context(%{context: "stdin"}) do
    IO.read(:stdio, :all)
    |> Jason.decode!()
    |> Util.Svc.convert_to_atom_map()
  end

  defp setup_context(%{context: ctx_file}) do
    IO.inspect ctx_file
    ctx_file
    |> File.read()
    |> Jason.decode!()
  end

  defp setup_action(%{action: nil}) do
    Atree.Actions.Util.Null
  end

  defp setup_action(args) do
    args.action
    |> Util.Children.file_data()
    |> Util.Children.to_children()
  end

  # --------------------------------------------------

  defp parse_args(argv) do
    {switches, args, _} = extract_args(argv)

    %{
      method: get_method(args),
      action: get_action(args),
      writes: get_writes(switches),
      params: get_params(switches),
      stdout: get_stdout(switches),
      context: get_context(switches)
    }
  end

  # --------------------------------------------------

  defp extract_args(argv) do
    switches = [
      param: :keep,
      stdout: :string,
      write_file: :keep,
      context_file: :string
    ]

    aliases = [
      p: :param,
      s: :stdout,
      w: :write_file,
      c: :context_file
    ]

    OptionParser.parse(argv, switches: switches, aliases: aliases)
  end

  @target_args ["export", "run"]

  defp get_method(args) do
    args
    |> Enum.map(&String.downcase/1)
    |> Enum.find(&Enum.member?(@target_args, &1))
  end

  defp get_action(args) do
    args
    |> Enum.filter(&(!Enum.member?(@target_args, &1)))
    |> List.first()
  end

  defp breakout({_key, val}) do
    list = String.split(val, "=")
    key = Enum.at(list, 0) |> String.to_atom()
    val = Enum.at(list, 1) || "TBD"
    {key, val}
  end

  defp get_writes(switches) do
    switches
    |> Enum.filter(&(elem(&1, 0) == :write_file))
    |> Enum.map(&breakout/1)
    |> Enum.into(%{})
  end

  defp get_params(switches) do
    switches
    |> Enum.filter(&(elem(&1, 0) == :param))
    |> Enum.map(&breakout/1)
    |> Enum.into(%{})
  end

  defp get_context(switches) do
    switches
    |> Enum.filter(&(elem(&1, 0) == :context_file))
    |> Enum.map(&elem(&1, 1))
    |> List.first()
  end

  defp get_stdout(switches) do
    switches
    |> Enum.filter(&(elem(&1, 0) == :stdout))
    |> Enum.map(&elem(&1, 0))
    |> List.first()
  end
end
