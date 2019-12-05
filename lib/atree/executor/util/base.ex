defmodule Atree.Executor.Util.Base do
  @moduledoc """
  Function invocation for Action Callbacks with default values.

  Actions have five optional callbacks: `command`, `test`, `guide`, `children`,
  and `inspect`.  This module provides default values for Action callbacks if
  they are not defined.

  Note that Action callbacks should not be called directly.  Invoke a callback
  using `Executor.Base`:

      Atree.Executor.Base.command(module, ctx, opts)

  This module is designed to be used by "high level" `Executor.*` modules:

      use Atree.Executor.Util.Base
  """

  use Atree.Data.Ctx

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Atree.Data.Ctx
      alias Atree.Executor.Util.Base  

      defp default_ctx do
        %Ctx{}
        |> setenv(:executor, __MODULE__)
      end
    end
  end

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

  def screen(module, params, opts) do
    if module.has_screen?(),
      do: apply(module, :screen, [params, opts]),
      else: %Atree.Data.Report{}
  end
end
