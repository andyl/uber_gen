defmodule UberGen.Executor.Export do

  @moduledoc """
  Exports an Action guide.

  The `Export.guide` function traverses an Action tree and saves guide
  fragments into the `log` attribute of the `UberGen.Ctx`.

  To generate output, pipe the result into an `UberGen.Presentor`:

      UberGen.Executor.Export.guide(MyModule)
      |> UberGen.Presentor.Markdown.to_stdout()

  """

  use UberGen.Executor.Base

  def guide(module) when is_atom(module) do
    ctx = Base.default_ctx()
    log = guide_log(ctx, {module, %{}, Base.children(module, %{}, [])})
    %{ctx | log: log}
  end

  # TODO: add function variants for tuple arg

  def guide(child_list) when is_list(child_list) do
    ctx = Base.default_ctx()
    log = guide_log(ctx, {UberGen.Actions.Util.Null, %{}, child_list})
    %{ctx | log: log}
  end

  defp guide_log(ctx, {module, opts, []}) do
    log(module, ctx, opts)
  end

  defp guide_log(ctx, {module, opts, children}) do
    base = log(module, ctx, opts)

    alt =
      children
      |> Enum.map(&Base.child_module/1)
      |> Enum.map(&guide_log(ctx, &1))

    %{base | children: alt}
  end

  defp log(mod, ctx, opts) do
    %{
      action: mod,
      guide: Base.guide(mod, ctx, opts),
      children: []
    }
  end
end
