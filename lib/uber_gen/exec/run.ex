defmodule UberGen.Exec.Run do

  import UberGen.Ctx

  def cmd(module) do
    cmd(%{}, {module, %{}, module.steps(%{}, [])})
    |> String.replace(~r/\n\n[\n]+/, "\n\n")
  end

  def cmd(ctx, {module, opts, []}) do
    if module.test(ctx, opts) do
      IO.puts("PASS (#{module})")
    else
      module.cmd(ctx, opts)
    end

    unless module.test(ctx, opts) do
      IO.puts("FAIL")
      module.guide(ctx, opts) |> IO.puts()
      halt(ctx)
    end
  end

  # NOTE: the pipeline can be halted from within the command,
  # TODO: We should check for "HALT" before each test.
  
  def cmd(ctx, {module, opts, children}) do
    if module.test(ctx, opts) do
      IO.puts("PASS (#{module})")
    else
      module.cmd(ctx, opts)
    end

    if module.test(ctx, opts) do
      children
      |> Enum.map(&child_module/1)
      |> Enum.map(&(UberGen.Exec.Run.cmd(ctx, &1)))
    else
      IO.puts("FAIL")
      module.guide(ctx, opts)
      halt(ctx)
    end
  end

  # if children are defined, use them
  # otherwise, use the hard-coded steps as children
  defp child_module({module, opts, children}), do: {module, opts, children}
  defp child_module({module, opts}), do: {module, opts, module.steps(%{}, %{})}
  defp child_module(module), do: {module, %{}, []}
end
