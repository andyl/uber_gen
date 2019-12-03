defmodule Atree.Executor.Util.ExecTree do
  @moduledoc """
  Traverse the action-tree and invoke the `exec_log` callback.

  This code is only to be used in the `Executor` modules (Export, Run, etc.):

      use Atree.Executor.Util.ExecTree

  The key method `with_action` can be called by client-code:

      context1 = Atree.Executor.Export.with_action(MyAction)
      context2 = Atree.Executor.Run.with_action(MyAction)

  The `action` argument can be:
  - an action module
  - a tuple {ActionModule, %{prop1: "value", prop2: "value"}
  - an ExecPlan

  See `ExecPlan#build` for more info...

  Each `Executor` module implements a callback `exec_log` with an execution
  strategy, using the `guide`, `command` and `test` functions to achieve some
  specific purpose.
  """

  use Atree.Data.Ctx
  alias Atree.Actions
  alias Atree.Data.{ExecPlan, Log}
  alias Atree.Executor.Util.Auth

  @doc false
  defmacro __using__(_props) do
    quote do
      use Atree.Executor.Util.Base

      def with_action(action) do
        default_ctx()
        |> with_action(action)
      end

      def with_action(ctx, action_list) when is_list(action_list) do
        plan = %ExecPlan{action: Actions.Util.Null, children: action_list}

        ctx
        |> invoke(plan)
        |> package()
      end

      def with_action(ctx, action) do
        ctx
        |> invoke(ExecPlan.build(action))
        |> package()
      end

      defp invoke(ctx, plan) do
        if Auth.check(ctx, plan), do: exec(ctx, plan), else: skip(ctx, plan)
      end

      defp exec(ctx, plan = %ExecPlan{children: []}) do
        exec_log(ctx, plan)
      end

      defp exec(ctx, plan) do
        {cx0, log} = exec_log(ctx, plan)

        {cx1, logs} =
          plan.children
          |> Enum.map(&ExecPlan.build/1)
          |> Enum.reduce({cx0, []}, &process/2)

        {cx1, %{log | children: logs}}
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
