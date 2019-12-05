defmodule Atree.Executor.Util.ExecTree do
  @moduledoc """
  Traverse the action-tree and invoke the `exec_log` callback.

  This code is only to be used in the `Executor` modules (Export, Run, etc.):

      use Atree.Executor.Util.ExecTree

  The key method `with_input` can be called by client-code:

      context1 = Atree.Executor.Export.with_input(MyAction)
      context2 = Atree.Executor.Run.with_input(MyAction)

  The `action` argument can be:
  - an action module
  - a tuple {ActionModule, %{prop1: "value", prop2: "value"}
  - an PlanAction
  - a playbook
  - a PlanPlaybook

  See `Plan#expand` for more info...

  Each `Executor` module implements a callback `exec_log` with an execution
  strategy, using the `guide`, `command` and `test` functions to achieve some
  specific purpose.
  """

  use Atree.Data.Ctx
  alias Atree.Actions
  alias Atree.Data.{Plan, PlanAction, Log}
  alias Atree.Executor.Util.Auth

  @doc false
  defmacro __using__(_props) do
    quote do
      use Atree.Executor.Util.Base

      def with_input(input) do
        default_ctx()
        |> with_input(input)
      end

      def with_input(ctx, input_list) when is_list(input_list) do
        plan = %PlanAction{action: Actions.Util.Null, children: input_list}

        ctx
        |> invoke(plan)
        |> package()
      end

      def with_input(ctx, input) do
        ctx
        |> invoke(Plan.expand(input))
        |> package()
      end

      # ------------------------------------------------------------------


      # ------------------------------------------------------------------

      defp invoke(ctx, list) when is_list(list) do
        exec(ctx, %PlanAction{action: Atree.Actions.Util.Null, children: list})
      end

      defp invoke(ctx, plan_action = %PlanAction{}) do
        if Auth.check(ctx, plan_action) do
          exec(ctx, plan_action)
        else 
          skip(ctx, plan_action)
        end
      end

      defp exec(ctx, plan = %PlanAction{children: []}) do
        exec_log(ctx, plan)
      end

      defp exec(ctx, plan = %PlanAction{}) do
        {cx0, log} = exec_log(ctx, plan)

        {cx1, logs} =
          plan.children
          |> Enum.map(&Plan.expand/1)
          |> Enum.reduce({cx0, []}, &process/2)

        {cx1, %Log{log | children: logs}}
      end

      defp skip(ctx, plan) do
        {ctx, %Log{action: plan.action, auth: false}}
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
