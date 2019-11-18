defmodule UberGen.Pb do
  @moduledoc """
  A module that provides conveniences for playbooks.

  Playbooks must:

  - have the module-name prefix `UberGen.Playbooks`
  - add the line `use UberGen.Playbook`

  The `UberGen.Playbook` module provides five macros for use in Playbooks.

  | Callback    | Arg(s)    | Returns     | Purpose                   |
  |-------------|-----------|-------------|---------------------------|
  | command/2   | ctx, opts | new_ctx     | executable playbook code  |
  | guide/2     | ctx, opts | new_ctx     | playbook documentation    |
  | test/2      | ctx, opts | test status | validation test           |
  | children/2  | ctx, opts | child list  | list of playbook children |
  | interface/2 | ctx, opts | schema      | params/assigns schema     |
  | sentry/2    | TBD       | changeset   | casting and validation    |

  All of these macros are optional for any given playbook.

  The `UberGen.Playbook` module provides introspection functions that show if a
  method is defined in a playbook: `has_command?/0`, `has_guide?/0`,
  `has_test?/0`, `has_children?/0`, `has_interface?/0`, `has_sentry?/0`.
  """

  @callback command(any(), any())   :: any()
  @callback guide(any(), any())     :: any()
  @callback test(any(), any())      :: any()
  @callback children(any(), any())  :: any()
  @callback interface(any(), any()) :: any()
  @callback sentry(any(), any())    :: any()

  @optional_callbacks command: 2, guide: 2, test: 2, children: 2, interface: 2, sentry: 2

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
      def has_interface?  , do: has?({:interface, 1})
      @doc false
      def has_sentry?     , do: has?({:sentry, 1})

      defp flist      , do: __MODULE__.__info__(:functions)
      defp has?(tuple), do: Enum.any?(flist(), &(&1 == tuple))

      use Ecto.Schema
      import Ecto.Changeset
      
      import UberGen.Ctx
      
      import UberGen.Pb
      @behaviour UberGen.Pb  
    end
  end
end
