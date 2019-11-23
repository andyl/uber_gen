defmodule Atree.Executor.Util.ExecTree do
  @moduledoc """
  Traverse the action-tree and invoke the `exec_log` callback.

  Use from within a high-level `Executor` module.  (Executor.Run or
  Executor.Export).

      use Atree.Executor.Util.ExecTree

  """

  use Atree.Data.Ctx
  alias Atree.Executor.Util.Base

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Atree.Executor.Util.Base

      @doc """
      A handler function to be called in an Executor.

      The Executor is responsible for implementing an `exec_log/3` function:

          exec_log(module, context, options) -> {new_context, log}

      """
      def with(module) when is_atom(module) do
        default_ctx()
        |> invoke({module, %{}, Base.children(module, %{}, [])})
        |> package()
      end

      def with({module, opts}) when is_atom(module) and is_map(opts) do
        default_ctx()
        |> invoke({module, opts, []})
        |> package()
      end

      def with({module, opts, children}) when is_atom(module) and is_map(opts) and is_list(children) do
        default_ctx()
        |> invoke({module, opts, children})
        |> package()
      end

      def with(child_list) when is_list(child_list) do
        default_ctx()
        |> invoke({Atree.Actions.Util.Null, %{}, child_list})
        |> package()
      end

      defp invoke(ctx, {module, opts, []}) do
        exec_log(module, ctx, opts)
      end

      defp invoke(ctx, {module, opts, children}) do
        {cx0, log} = exec_log(module, ctx, opts)

        {cx1, logs} =
          children
          |> Enum.map(&Base.action_spec/1)
          |> Enum.reduce({cx0, []}, &process/2)

        {cx1, %{log | children: logs}}
      end

      defp process(action_spec, {ctx, logs}) do
        {cx0, log} = invoke(ctx, action_spec)
        {cx0, logs ++ [log]}
      end

      defp package({ctx, log}), do: %{ctx | log: log}
    end
  end
end