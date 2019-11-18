defmodule UberGen.Executor.Base do

  def command(mod, ctx, opts) do
    if(mod.has_command?(), do: apply(mod, :command, [ctx, opts]), else: ctx)
  end

  def test(mod, ctx, opts) do
    if(mod.has_test?(), do: apply(mod, :test, [ctx, opts]), else: true)
  end

  def guide(mod, ctx, opts) do
    if(mod.has_guide?(), do: apply(mod, :guide, [ctx, opts]), else: "")
  end

  def interface(mod, ctx, opts) do
    if(mod.has_interface?(), do: apply(mod, :interface, [ctx, opts]), else: [])
  end

  def sentry(mod, opts) do
    if(mod.has_sentry?(), do: apply(mod, :sentry, [opts]), else: ok(opts))
  end

  defp ok(opts)   , do: %{valid?: true, changes: opts}
end
