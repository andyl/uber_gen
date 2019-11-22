defmodule UberGen.Executor.Tailor do

  @moduledoc """
  Tailors an Action guide to your code-base.

  """

  use UberGen.Executor.Util.ExecTree

  defp exec_log(mod, ctx, opts) do

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
