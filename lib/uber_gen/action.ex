defmodule UberGen.Action do
  @moduledoc """
  A module that provides conveniences for actions.

      def MyAction do
        use UberGen.Action
      end

  The `UberGen.Action` behavior provides five callbacks for use in Actions.

  | Callback    | Arg(s)    | Returns     | Purpose                 |
  |-------------|-----------|-------------|-------------------------|
  | command/2   | ctx, opts | new_ctx     | executable action code  |
  | guide/2     | ctx, opts | new_ctx     | action documentation    |
  | test/2      | ctx, opts | test status | action test             |
  | children/2  | ctx, opts | child list  | list of action children |
  | interface/3 | ctx, opts | schema      | params/assigns schema   |
  | inspect/3   | TBD       | changeset   | casting and validation  |

  All of these macros are optional for any given action.

  The `UberGen.Action` module provides introspection functions that show if a
  method is defined in a action: `has_command?/0`, `has_guide?/0`,
  `has_test?/0`, `has_children?/0`, `has_interface?/0`, `has_inspect?/0`.
  """

  @callback command(any(), any())          :: any()
  @callback guide(any(), any())            :: any()
  @callback test(any(), any())             :: any()
  @callback children(any(), any())         :: any()
  @callback interface(any(), any(), any()) :: any()
  @callback inspect(any(), any(), any())   :: any()

  @optional_callbacks command: 2, guide: 2, test: 2, children: 2, interface: 3, inspect: 3

  @doc false
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :shortdoc, persist: true)

      @doc false
      def has_command?    , do: has?({:command, 2})
      @doc false
      def has_guide?      , do: has?({:guide, 2})
      @doc false
      def has_test?       , do: has?({:test, 2})
      @doc false
      def has_children?   , do: has?({:children, 2})
      @doc false
      def has_interface?  , do: has?({:interface, 3})
      @doc false
      def has_inspect?    , do: has?({:inspect, 3})

      defp flist      , do: __MODULE__.__info__(:functions)
      defp has?(tuple), do: Enum.any?(flist(), &(&1 == tuple))

      use Ecto.Schema
      import Ecto.Changeset
      
      import UberGen.Ctx
      
      @behaviour UberGen.Action
    end
  end
end
