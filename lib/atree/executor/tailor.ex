defmodule Atree.Executor.Tailor do

  @moduledoc """
  Tailors an Action guide to your code-base.

  """

  use Atree.Executor.Util.ExecTree

  def exec_log(mod, ctx, opts) do

    report = Base.inspect(mod, ctx, opts)
    ctx_v2 = report.ctx || ctx  

    log = %{
      action: mod,
      guide: Base.guide(mod, ctx_v2, opts),
      children: []
    }

    {ctx_v2, log}
  end

end
