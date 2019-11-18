defmodule UberGen.Executor.Base do

  def command(module, ctx, opts) do
    if module.has_command?(), do: apply(module, :command, [ctx, opts]), else: ctx
  end

  def test(module, ctx, opts) do
    if module.has_test?(), do: apply(module, :test, [ctx, opts]), else: true
  end

  def guide(module, ctx, opts) do
    if module.has_guide?(), do: apply(module, :guide, [ctx, opts]), else: ""
  end

  def children(module, ctx, opts) do
    if module.has_children?(), do: apply(module, :children, [ctx, opts]), else: []
  end

  def interface(module, ctx, opts) do
    if module.has_interface?(), do: apply(module, :interface, [ctx, opts]), else: %{}
  end

  def inspect(module, params, opts) do
    if module.has_inspect?(), do: apply(module, :inspect, [params, opts]), else: ok(opts)
  end

  # ----------------------------------------------------------------------------
  
  defp ok(opts)   , do: %{valid?: true, changes: opts}

end
