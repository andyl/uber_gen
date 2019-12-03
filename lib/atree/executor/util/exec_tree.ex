defmodule Atree.Executor.Util.ExecTree do
  @moduledoc """
  Traverse the action-tree and invoke the `exec_log` callback.
  """

  use Atree.Data.Ctx

  @doc false
  defmacro __using__(_props) do
    quote do
      use Atree.Executor.Util.Base
      alias Atree.Data.ExecPlan

      def with_action(action) do
        default_ctx()
        |> with_action(action)
      end

      def with_action(ctx, action_list) when is_list(action_list) do
        plan = %ExecPlan{action: Atree.Actions.Util.Null, children: action_list}
        ctx
        |> invoke(plan)
        |> package()
      end

      def with_action(ctx, action) do
        ctx
        |> invoke(ExecPlan.build(action))
        |> package()
      end

      defp invoke(ctx, plan = %ExecPlan{children: []}) do
        exec_log(ctx, plan) 
      end

      defp invoke(ctx, plan) do
        {cx0, log} = exec_log(ctx, plan)
        {cx1, logs} =
          plan.children
          |> Enum.map(&ExecPlan.build/1)
          |> Enum.reduce({cx0, []}, &process/2)
        {cx1, %{log | children: logs}}
      end

      defp process(plan, {ctx, logs}) do
        {cx0, log} = invoke(ctx, plan)
        {cx0, logs ++ [log]}
      end

      defp package({ctx, log}) do
        newlog = ctx.log ++ [log]
        %{ctx | log: newlog}
      end
    end
  end
end
