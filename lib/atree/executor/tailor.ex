defmodule Atree.Executor.Tailor do

  # @moduledoc """
  # Tailors an Action guide to your code-base.
  #
  # """
  #
  # use Atree.Executor.Util.ExecTree
  #
  # def exec_log(ctx, plan) do
  #
  #   mod = plan.action
  #   props = plan.props
  #   report = Base.inspect(mod, ctx, props)
  #   ctx_v2 = report.ctx || ctx  
  #
  #   log = %{
  #     action: mod,
  #     guide: Base.guide(mod, ctx_v2, props),
  #     children: []
  #   }
  #
  #   {ctx_v2, log}
  # end

end
