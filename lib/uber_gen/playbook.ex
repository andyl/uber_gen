defmodule UberGen.Playbook do
  @moduledoc """
  A module that provides conveniences for playbooks.
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :shortdoc, persist: true)
      import UberGen.Playbook, only: [steps: 1, call: 3, guide: 3, test: 3]
    end
  end

  @doc false
  defmacro steps(do: yeild) do
    quote do
      def steps do
        unquote(yeild)
      end
    end
  end

  @doc false
  defmacro call(ctx, opts, do: yeild) do
    quote do
      def call(unquote(ctx), unquote(opts)) do
        # IO.inspect unquote(ctx)
        # IO.inspect unquote(opts)
        unquote(yeild)
      end
    end
  end

  @doc false
  defmacro guide(ctx, opts, do: yeild) do
    quote do
      def guide(unquote(ctx), unquote(opts)) do
        # IO.inspect unquote(ctx)
        # IO.inspect unquote(opts)
        unquote(yeild)
      end
    end
  end

  @doc false
  defmacro test(ctx, opts, do: yeild) do
    quote do
      def test(unquote(ctx), unquote(opts)) do
        # IO.inspect unquote(ctx)
        # IO.inspect unquote(opts)
        unquote(yeild)
      end
    end
  end

end
