# defmodule UberGen.Presentor.Run do
#
#   use UberGen.Ctx
#
#   alias UberGen.Executor.Base
#
#   def command(module) when is_atom(module) do
#     default_ctx()
#     |> command({module, %{}, Base.children(module, %{}, [])})
#   end
#   
#   def command(child_list) when is_list(child_list) do
#     default_ctx()
#     |> command({UberGen.Actions.Util.Null, %{}, child_list})
#   end
#
#   def command(ctx, {module, opts, []}) do
#     if Base.test(module, ctx, opts) do
#       IO.puts("PASS (#{module})")
#     else
#       Base.command(module, ctx, opts)
#     end
#
#     unless Base.test(module, ctx, opts) do
#       IO.puts("FAIL")
#       Base.guide(module, ctx, opts) |> IO.puts()
#       halt(ctx)
#     end
#   end
#
#   # NOTE: the pipeline can be halted from within the command,
#   # TODO: We should check for "HALT" before each test.
#   
#   def command(ctx, {module, opts, children}) do
#     if Base.test(module, ctx, opts) do
#       IO.puts("PASS (#{module})")
#     else
#       Base.command(module, ctx, opts)
#     end
#
#     if Base.test(module, ctx, opts) do
#       children
#       |> Enum.map(&Base.child_module/1)
#       |> Enum.map(&(UberGen.Executor.Run.command(ctx, &1)))
#     else
#       IO.puts("FAIL")
#       Base.guide(module, ctx, opts)
#       halt(ctx)
#     end
#   end
#
#   # ---------------------------------------------------------
#
#   defp default_ctx do
#     %Ctx{}
#     |> setenv(:executor, __MODULE__)
#   end
# end
