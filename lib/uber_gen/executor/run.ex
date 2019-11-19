defmodule UberGen.Executor.Run do

  @moduledoc """
  Runs Action commands and tests, Exports an Action guide.

  The `Export.guide` function traverses an Action tree and saves guide
  fragments into the `log` attribute of the `UberGen.Ctx`.

  To generate output, pipe the result into an `UberGen.Presentor`:

      UberGen.Executor.Export.guide(MyModule)
      |> UberGen.Presentor.Markdown.to_stdout()
  """
  use UberGen.Ctx

  alias UberGen.Executor.Base

  def command(module) when is_atom(module) do
    Base.default_ctx()
    |> run_cmd({module, %{}, Base.children(module, %{}, [])})
    |> package()
  end

  def command(child_list) when is_list(child_list) do
    Base.default_ctx()
    |> run_cmd({UberGen.Actions.Util.Null, %{}, child_list})
    |> package()
  end

  defp run_cmd(ctx, {module, opts, []}) do
    log(module, ctx, opts)
  end

  defp run_cmd(ctx, {module, opts, children}) do
    {cx0, log} = log(module, ctx, opts)

    {cx1, logs} =
      children
      |> Enum.map(&Base.child_module/1)
      |> Enum.reduce({cx0, []}, &process/2)

    {cx1, %{log | children: logs}}
  end

  defp process({mod, opts}, {ctx, logs}) do
    {cx0, log} = log(mod, ctx, opts)
    {cx0, logs ++ [log]}
  end

  defp log(mod, ctx, opts) do
    cx0 = Base.command(mod, ctx, opts)

    log = %{
      action: mod,
      test: Base.test(mod, cx0, opts),
      guide: Base.guide(mod, cx0, opts),
      children: []
    }

    cx1 = if log.test == :ok, do: cx0, else: halt(cx0)
    {cx1, log}
  end

  defp package({ctx, log}), do: %{ctx | log: log}
end
