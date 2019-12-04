defmodule Atree.Executor.Tailor do

  @moduledoc """
  Tailors an Action guide to your code-base.
  """

  alias Atree.Data.ExecPlan
  alias Atree.Executor.Util.Helpers
  use Atree.Executor.Util.ExecTree

  def exec_log(ctx, %ExecPlan{action: act, props: props}) do 
    report = Base.inspect(act, ctx, props)
    ctx_v2 = report.ctx || ctx  
    xprops = report.props || props
    xguide = Helpers.gen_guide(report, act, ctx_v2, xprops)

    log = %{
      action: act,
      guide: xguide,
      report: report,
      children: []
    }

    {ctx_v2, log}
  end

end
