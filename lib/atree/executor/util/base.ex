defmodule Atree.Executor.Util.Base do
  @moduledoc """
  Function invocation for Action Callbacks with default values.

  Actions have five optional callbacks: `command`, `test`, `guide`, `children`,
  and `inspect`.  This module provides default values for Action callbacks if
  they are not defined.

  Note that Action callbacks should not be called directly.  Invoke a callback
  using `Executor.Base`:

      Atree.Executor.Base.command(module, ctx, props)

  This module is designed to be used by "high level" `Executor.*` modules:

      use Atree.Executor.Util.Base
  """

  use Atree.Data.Ctx

  @doc false
  defmacro __using__(_props) do
    quote do
      use Atree.Data.Ctx
      alias Atree.Executor.Util.Base  

      defp default_ctx do
        %Ctx{}
        |> setenv(:executor, __MODULE__)
      end
    end
  end

  def command(module, ctx, props) do
    if module.has_command?(), do: apply(module, :command, [ctx, props]), else: ctx
  end

  def test(module, ctx, props) do
    if module.has_test?(), do: apply(module, :test, [ctx, props]), else: true
  end

  def guide(module, ctx, props) do
    if module.has_guide?(), do: apply(module, :guide, [ctx, props]), else: ""
  end

  def children(module, ctx, props) do
    if module.has_children?(), do: apply(module, :children, [ctx, props]), else: []
  end

  def screen(module, params, props) do
    if module.has_screen?(),
      do: apply(module, :screen, [params, props]),
      else: %Atree.Data.Report{}
  end
end
