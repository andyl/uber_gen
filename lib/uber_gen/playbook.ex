defmodule UberGen.Playbook do
  @moduledoc """
  A module that provides conveniences for playbooks.

  Playbooks are modules that can be composed into an application generation
  pipeline.  Each playbook can provide three major elements:

    1) installation guides
    2) software support
    3) validation tests

  Playbooks must:

  - have the module-name prefix `UberGen.Playbooks`
  - add the line `use UberGen.Playbook`

  The `UberGen.Playbook` module provides five macros for use in Playbooks.

  | Macro   | Arg(s)      | Returns            | Purpose                       |
  |---------|-------------|--------------------|-------------------------------|
  | run/1   | mix options | run status         | can be called from a mix task |
  | call/2  | ctx, opts   | new_ctx            | executable playbook code      |
  | test/2  | ctx, opts   | test status        | validation test               |
  | steps/2 | ctx, opts   | list of PB Modules | list of playbook children     |
  | guide/2 | ctx, opts   | guide text         | playbook documentation        |

  All of these macros are optional for any given playbook.

  Calling a Playbook with an 'undefined' macro returns a default value.

  The `UberGen.Playbook` module provides introspection functions that show if a
  method is defined in a playbook: `has_run?/0`, `has_call?/0`, `has_test?/0`,
  `has_steps?/0`, `has_guide?/0`
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :shortdoc, persist: true)

      @doc false
      def has_run?       , do: has?({:_run, 1})
      @doc false
      def has_test?      , do: has?({:_test, 2})
      @doc false
      def has_call?      , do: has?({:_call, 2})
      @doc false
      def has_steps?     , do: has?({:_steps, 2})
      @doc false
      def has_guide?     , do: has?({:_guide, 2})
      @doc false
      def has_changeset? , do: has?({:_changeset, 1})

      @doc false
      def run(args)        , do: if has_run?()      , do: apply(mod(), :_run,       [args])      , else: nil
      @doc false
      def call(ctx, opts)  , do: if has_call?()     , do: apply(mod(), :_call,      [ctx, opts]) , else: ctx
      @doc false
      def test(ctx, opts)  , do: if has_test?()     , do: apply(mod(), :_test,      [ctx, opts]) , else: true
      @doc false
      def guide(ctx, opts) , do: if has_guide?()    , do: apply(mod(), :_guide,     [ctx, opts]) , else: ""
      @doc false
      def steps(ctx, opts) , do: if has_steps?()    , do: apply(mod(), :_steps,     [ctx, opts]) , else: []
      @doc false
      def changeset(opts)  , do: if has_changeset?(), do: apply(mod(), :_changeset, [opts])      , else: {:ok, opts}

      defp mod        , do: __MODULE__
      defp flist      , do: __MODULE__.__info__(:functions)
      defp has?(tuple), do: Enum.any?(flist(), &(&1 == tuple))

      use Ecto.Schema
      import Ecto.Changeset
      import UberGen.Playbook
      import UberGen.Ctx
    end
  end

  @doc """
  Define Playbooks params.
  """
  defmacro params(do: yeild) do
    quote do
      embedded_schema do
        unquote(yeild)
      end
    end
  end

  @doc """
  Changeset for Playbook params.
  """
  defmacro changeset(params, do: yeild) do
    quote do
      def _changeset(unquote(params)) do
        unquote(yeild)
      end
    end
  end

  @doc """
  Run from a mix task.

  Bing bong bang.
  """
  defmacro run(args, do: yeild) do
    quote do
      def _run(unquote(args)) do
        unquote(yeild)
      end
    end
  end

  @doc """
  Execution steps.

  Bong bang bong.
  """
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
