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
    |> generate_outputs(data)
  end

  def process(data = %{method: "run"}) do
    Atree.Executor.Run.with_action(data.context, data.action)
    |> generate_outputs(data)
  end

  def process(data = %{method: "help"}) do
    Atree.Util.Help.output(data)
  end

  def process(data = %{method: "list"}) do
    list(data, data.action)
  end

  def process(data) do
    IO.inspect(data)
    IO.puts("No method found")
  end

  # --------------------------------------------------

  def list(_data, "playbooks") do
    Atree.Util.Registry.Playbooks.playbooks()
    |> Enum.join("\n")
    |> IO.puts()
  end

  def list(_data, "actions") do
    {docs, max} = Atree.Util.Registry.Actions.doclist()

    Atree.Util.Util.display_doc_list(docs, max)
  end

  def list(data, nil) do
    IO.puts("PLAYBOOKS")
    list(data, "playbooks")
    IO.puts("\nACTIONS")
    list(data, "actions")
  end

  def generate_outputs(ctx, data) do
    data.writes
    |> Enum.each(&write_file(&1, ctx))

    ctx
    |> data.output.generate()
    |> IO.puts()
  end

  def write_file({processor, filename}, ctx) do
    process_module = setup_output(processor)
    data = ctx |> process_module.generate()
    File.write(filename, data)
  end

  defp setup_args(args) do
    method = args.method || "help"

    %{
      method: method,
      writes: args.writes,
      output: setup_output(args.output),
      action: setup_action(method, args),
      context: setup_context(args)
    }
  end

  defp setup_context(%{context: nil}) do
    %Atree.Data.Ctx{}
  end

  defp setup_context(%{context: "stdin"}) do
    :stdio
    |> IO.read(:all)
    |> Jason.decode!()
    |> Util.Svc.convert_to_atom_map()
  end

  defp setup_context(%{context: ctx_file}) do
    ctx_file
    |> File.read()
    |> elem(1)
    |> Jason.decode!()
    |> Util.Svc.convert_to_atom_map()
  end

  defp setup_action("help", args) do
    args.action
  end

  defp setup_action("list", args) do
    args.action
  end

  defp setup_action(_, %{action: nil}) do
    Atree.Actions.Util.Null
  end

  defp setup_action(_, %{method: "help"}) do
    Atree.Actions.Util.Null
  end

  defp setup_action(_, args) do
    args.action
    |> Util.Children.file_data()
    |> Util.Children.to_children()
  end

  def setup_output(nil), do: setup_output("ctx_json")

  def setup_output(item) when is_atom(item), do: Atom.to_string(item) |> setup_output()

  def setup_output(format) do
    case format do
      "action_tree" -> Atree.Presentor.ActionTree
      "ctx_inspect" -> Atree.Presentor.CtxInspect
      "ctx_json" -> Atree.Presentor.CtxJson
      "guide_html" -> Atree.Presentor.GuideHtml
      "guide_markdown" -> Atree.Presentor.GuideMarkdown
      "log_inspect" -> Atree.Presentor.LogInspect
      "log_json" -> Atree.Presentor.LogJson
      _ -> Atree.Presentor.CtxJson
    end
  end

  # --------------------------------------------------

  defp parse_args(argv) do
    {switches, args, _} = extract_args(argv)

    %{
      method: get_method(args),
      action: get_action(args),
      writes: get_writes(switches),
      params: get_params(switches),
      output: get_output(switches),
      context: get_context(args, switches)
    }
  end

  # --------------------------------------------------

  defp extract_args(argv) do
    # :keep means keep multiple instances (string type)
    switches = [
      param: :keep,
      output: :string,
      write_file: :keep,
      context_src: :string
    ]

    aliases = [
      p: :param,
      o: :output,
      w: :write_file,
      c: :context_src
    ]

    OptionParser.parse(argv, switches: switches, aliases: aliases)
  end

  @target_args ["export", "tailor", "run", "serve", "help", "list"]

  defp get_method(args) do
    if Enum.member?(args, "help") do
      "help"
    else
      args
      |> Enum.map(&String.downcase/1)
      |> Enum.find(&Enum.member?(@target_args, &1))
    end
  end

  defp get_action(args) do
    if Enum.member?(args, "help") do
      args
      |> Enum.filter(&(&1 != "-"))
      |> Enum.filter(&(&1 != "help"))
      |> List.first()
    else
      args
      |> Enum.filter(&(&1 != "-"))
      |> Enum.filter(&(!Enum.member?(@target_args, &1)))
      |> List.first()
    end
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

  defp get_context(args, switches) do
    if Enum.member?(args, "-") do
      "stdin"
    else
      switches
      |> Enum.filter(&(elem(&1, 0) == :context_src))
      |> Enum.map(&elem(&1, 1))
      |> Enum.map(&if "-" == &1, do: "stdin", else: &1)
      |> List.first()
    end
  end

  defp get_output(switches) do
    switches
    |> Enum.filter(&(elem(&1, 0) == :output))
    |> Enum.map(&elem(&1, 1))
    |> List.first()
  end
end
