defmodule UberGen.Executor.Base do

  @moduledoc """
  Function invocation for Action Callbacks with default values.

  Actions have five optional callbacks: `command`, `test`, `guide`, `children`,
  `interface`, and `inspect`.  This module provides default values for Action
  callbacks.

  Note that Action callbacks should not be called directly.  Invoke a callback
  using `Executor.Base`:

      UberGen.Executor.Base.command(module, ctx, opts)

  This module is designed to be used mainly by "high level" executor modules
  (`Executor.Export` and `Executor.Run`).
  """

  alias UberGen.Executor.Base

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

  @doc """
  Cast the input param into a child-module tuple.

  The child-module tuple has the following elements:
  - the module
  - the module options
  - the module children

  If children are passed as an option, use them.  Otherwise, use the values
  that are hard-coded into the `children` callback.
  """
  def child_module({module, opts, children}), do: {module, opts, children}
  def child_module({module, opts}), do: {module, opts, Base.children(module, %{}, %{})}
  def child_module(module), do: {module, %{}, Base.children(module, %{}, %{})}

  # ----------------------------------------------------------------------------
  
  defp ok(opts)   , do: %{valid?: true, changes: opts}

end
