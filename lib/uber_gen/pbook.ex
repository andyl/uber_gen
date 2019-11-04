defmodule UberGen.Pbook do

  defmacro __using__(_opts) do
    quote do
      import UberGen.Pbook
    end
  end

  defmacro bong(ctx, opts, do: yield) do
    quote do
      IO.inspect "---------------------------------------"
      IO.inspect unquote(ctx)
      IO.inspect unquote(opts)
      IO.inspect "---------------------------------------"
      unquote(yield)
    end
  end
end
