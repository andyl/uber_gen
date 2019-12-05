defmodule Atree.Executor.Export do
  @moduledoc """
  Exports an Action guide.

  The `Export.guide` function traverses an Action tree and saves guide
  fragments into the `log` attribute of the `Atree.Data.Ctx`.

  To generate output, pipe the result into an `Atree.Presentor`:

      Atree.Executor.Export.with_input(Atree.Actions.MyAction)
      |> Atree.Presentor.Markdown.to_stdout()

  """

  alias Atree.Data.PlanAction
  alias Atree.Executor.Util.Helpers
  use Atree.Executor.Util.ExecTree

  def exec_log(ctx, %PlanAction{action: act, props: props}) do 
    report = Base.screen(act, ctx, props)
    ctx_v2 = report.ctx || ctx
    xprops = report.props || props
    xguide = Helpers.gen_guide(report, act, ctx_v2, xprops)

    log = %{
      action: act, 
      guide: xguide, 
      report: %{report | changeset: nil},
      children: []
    }

    {ctx_v2, log}
  end
end
