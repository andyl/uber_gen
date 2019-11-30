defmodule Atree.Executor.Export do
  @moduledoc """
  Exports an Action guide.

  The `Export.guide` function traverses an Action tree and saves guide
  fragments into the `log` attribute of the `Atree.Data.Ctx`.

  To generate output, pipe the result into an `Atree.Presentor`:

      Atree.Executor.Export.guide(MyModule)
      |> Atree.Presentor.Markdown.to_stdout()

  """

  use Atree.Executor.Util.ExecTree

  def exec_log(mod, ctx, props) do
    report = Base.inspect(mod, ctx, props)
    new_ctx = report.ctx || ctx
    new_props = report.props || props

    guide = gen_guide(report, mod, new_ctx, new_props)

    log = %{action: mod, guide: guide, report: %{report|changeset: %{}}, children: []}

    {new_ctx, log}
  end

  defp gen_guide(report, mod, ctx, props) do
    if report.valid? do
      Base.guide(mod, ctx, props)
    else
      body = """
      ```
      -----------------------------
      INVALID PROPS
      #{inspect(props)}
      -----
      #{inspect(report.errors())}
      -----------------------------
      ```
      """

      %{body: body}
    end
  end
end
