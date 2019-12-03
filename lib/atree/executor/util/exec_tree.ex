defmodule Atree.Executor.Util.ExecTree do
  @moduledoc """
  Traverse the action-tree and invoke the `exec_log` callback.
  """

  use Atree.Data.Ctx
  # alias Atree.Executor.Util.Base

  @doc false
  defmacro __using__(_props) do
    quote do
      use Atree.Executor.Util.Base

      # def with_action(module) do
      #   with_action(default_ctx(), module)
      # end
      #
      # def with_action(ctx, module) when is_atom(module) do
      #   ctx
      #   |> invoke({module, %{}, Base.children(module, %{}, [])})
      #   |> package()
      # end
      #
      # def with_action(ctx, {module, props})
      #     when is_atom(module) and is_map(props) do
      #   ctx
      #   |> invoke({module, props, []})
      #   |> package()
      # end
      #
      # def with_action(ctx, {mod, props, child})
      #     when is_atom(mod) and is_map(props) and is_list(child) do
      #   ctx
      #   |> invoke({mod, props, child})
      #   |> package()
      # end
      #
      # def with_action(ctx, child_list) when is_list(child_list) do
      #   ctx
      #   |> invoke({Atree.Actions.Util.Null, %{}, child_list})
      #   |> package()
      # end
      #
      # defp invoke(ctx, {module, props, []}) do
      #   # exec_log(module, ctx, props)
      #   {ctx, %Atree.Data.Log{}}
      # end
      #
      # defp invoke(ctx, {module, props, children}) do
      #   {cx0, log} = exec_log(module, ctx, props)
      #
      #   {cx1, logs} =
      #     children
      #     |> Enum.map(&Base.action_spec/1)
      #     |> Enum.reduce({cx0, []}, &process/2)
      #
      #   {cx1, %{log | children: logs}}
      # end
      #
      # defp process(action_spec, {ctx, logs}) do
      #   {cx0, log} = invoke(ctx, action_spec)
      #   {cx0, logs ++ [log]}
      # end
      #
      # defp package({ctx, log}) do
      #   newlog = ctx.log ++ [log]
      #   %{ctx | log: newlog}
      # end

      # -------------------------------------------------------


      # -------------------------------------------------------

      alias Atree.Data.ExecPlan

      def auth_action(action) do
        default_ctx()
        |> auth_action(action)
      end

      def auth_action(ctx, action_list) when is_list(action_list) do
        plan = %ExecPlan{action: Atree.Actions.Util.Null, children: action_list}
        ctx
        |> auth_invoke(plan)
        |> auth_package()
      end

      def auth_action(ctx, action) do
        ctx
        |> auth_invoke(ExecPlan.build(action))
        |> auth_package()
      end

      defp auth_invoke(ctx, plan = %ExecPlan{children: []}) do
        exec_log(ctx, plan) 
      end

      defp auth_invoke(ctx, plan) do
        {cx0, log} = exec_log(ctx, plan)
        {cx1, logs} =
          plan.children
          |> Enum.map(&ExecPlan.build/1)
          |> Enum.reduce({cx0, []}, &auth_process/2)
        {cx1, %{log | children: logs}}
      end

      defp auth_process(plan, {ctx, logs}) do
        {cx0, log} = auth_invoke(ctx, plan)
        {cx0, logs ++ [log]}
      end

      defp auth_package({ctx, log}) do
        newlog = ctx.log ++ [log]
        %{ctx | log: newlog}
      end
    end
  end
end
