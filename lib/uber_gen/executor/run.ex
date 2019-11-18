defmodule UberGen.Executor.Run do

  import UberGen.Ctx
  alias UberGen.Executor.Base

  def command(module) when is_atom(module) do
    command(%{}, {module, %{}, Base.children(module, %{}, [])})
  end
  
  def command(input) when is_list(input) do
    command(%{}, {UberGen.Actions.Util.Null, %{}, input})
  end

  def command(ctx, {module, opts, []}) do
    if Base.test(module, ctx, opts) do
      IO.puts("PASS (#{module})")
    else
      Base.command(module, ctx, opts)
    end

    unless Base.test(module, ctx, opts) do
      IO.puts("FAIL")
      Base.guide(module, ctx, opts) |> IO.puts()
      halt(ctx)
    end
  end

  # NOTE: the pipeline can be halted from within the command,
  # TODO: We should check for "HALT" before each test.
  
  def command(ctx, {module, opts, children}) do
    if Base.test(module, ctx, opts) do
      IO.puts("PASS (#{module})")
    else
      Base.command(module, ctx, opts)
    end

    if Base.test(module, ctx, opts) do
      children
      |> Enum.map(&child_module/1)
      |> Enum.map(&(UberGen.Executor.Run.command(ctx, &1)))
    else
      IO.puts("FAIL")
      Base.guide(module, ctx, opts)
      halt(ctx)
    end
  end

  # if children are defined, use them
  # otherwise, use the hard-coded steps as children
  defp child_module({module, opts, children}), do: {module, opts, children}
  defp child_module({module, opts}), do: {module, opts, module.steps(%{}, %{})}
  defp child_module(module), do: {module, %{}, []}
end
