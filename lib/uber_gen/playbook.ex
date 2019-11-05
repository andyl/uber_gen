defmodule UberGen.Playbook do
  @moduledoc """
  A module that provides conveniences for playbooks.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :shortdoc, persist: true)

      def has_run?   , do: has?({:_run, 1})
      def has_test?  , do: has?({:_test, 2})
      def has_call?  , do: has?({:_call, 2})
      def has_steps? , do: has?({:_steps, 2})
      def has_guide? , do: has?({:_guide, 2})

      def run(args)        , do: if has_run?()  , do: apply(mod(), :_run,   [args])      , else: nil
      def call(ctx, opts)  , do: if has_call?() , do: apply(mod(), :_call,  [ctx, opts]) , else: ctx
      def test(ctx, opts)  , do: if has_test?() , do: apply(mod(), :_test,  [ctx, opts]) , else: true
      def guide(ctx, opts) , do: if has_guide?(), do: apply(mod(), :_guide, [ctx, opts]) , else: nil
      def steps(ctx, opts) , do: if has_steps?(), do: apply(mod(), :_steps, [ctx, opts]) , else: []

      defp mod        , do: __MODULE__
      defp flist      , do: __MODULE__.__info__(:functions)
      defp has?(tuple), do: Enum.any?(flist(), &(&1 == tuple))

      import UberGen.Playbook
    end
  end

  @doc false
  defmacro run(args, do: yeild) do
    quote do
      def _run(unquote(args)) do
        unquote(yeild)
      end
    end
  end

  @doc false
  defmacro steps(ctx, opts, do: yeild) do
    quote do
      def _steps(unquote(ctx), unquote(opts)) do
        unquote(yeild)
      end
    end
  end

  @doc false
  defmacro call(ctx, opts, do: yeild) do
    quote do
      def _call(unquote(ctx), unquote(opts)) do
        # IO.inspect unquote(ctx)
        # IO.inspect unquote(opts)
        unquote(yeild)
      end
    end
  end

  @doc false
  defmacro guide(ctx, opts, do: yeild) do
    quote do
      def _guide(unquote(ctx), unquote(opts)) do
        # IO.inspect unquote(ctx)
        # IO.inspect unquote(opts)
        unquote(yeild)
      end
    end
  end

  @doc false
  defmacro test(ctx, opts, do: yeild) do
    quote do
      def _test(unquote(ctx), unquote(opts)) do
        # IO.inspect unquote(ctx)
        # IO.inspect unquote(opts)
        unquote(yeild)
      end
    end
  end

end
