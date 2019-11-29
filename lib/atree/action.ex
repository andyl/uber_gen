defmodule Atree.Action do
  @moduledoc """
  A module that provides conveniences for actions.

      def MyAction do
        use Atree.Action
      end

  The `Atree.Action` behavior provides five callbacks for use in Actions.

  | Callback    | Arg(s)    | Returns  | Purpose                |
  |-------------|-----------|----------|------------------------|
  | command/2   | ctx, opts | new_ctx  | executable action code |
  | guide/2     | ctx, opts | fragment | action documentation   |
  | test/2      | ctx, opts | status   | action test            |
  | children/2  | ctx, opts | list     | list of action specs   |
  | interface/2 | ctx, opts | schema   | list of propdefs       |
  | inspect/2   | ctx, opts | report   | casting and validation |

  All of these macros are optional for any given action.

  The `Atree.Action` module provides introspection functions that show if a
  method is defined in a action: `has_command?/0`, `has_guide?/0`,
  `has_test?/0`, `has_children?/0`, `has_interface?/0`, `has_inspect?/0`.
  """

  alias Atree.Data.{Ctx, Report, Guide, Prop}

  @doc """
  Action command.  

  The primary purpose of the Command method is to perform an operation that
  generates a state change in the target system.  

  Commands must be idempotent.  Use your test to determine if you need to
  re-run command code.
  """
  @callback command(Ctx.t, map())          :: Ctx.t

  @doc """
  Emit guide text.
  """
  @callback guide(Ctx.t, map())            :: Guide.t

  @doc """
  Run a test.
  """
  @callback test(Ctx.t, map())             :: :ok | {:error, String.t}

  @doc """
  Return list of children.
  """
  @callback children(Ctx.t, map())         :: list()

  @doc """
  Define interface for action - returns a list of propdefs.

  Primary uses for the interface data: documentation, introspection and
  form-building.
  """
  @callback interface(Ctx.t, map()) :: [Prop.t]

  @doc """
  Perform casting and validation on interface data.

  Primary uses: data casting, data validation, form validation.

  This can be done on *either* the Ctx[:assigns] values, or the params.

  You can optionally use ecto validations.

  You can optionally update the ctx assigns.

  See the Executor modules (Run, Export) to see how the inspect function is used.
  """
  @callback inspect(Ctx.t, map())   :: Report.t

  @optional_callbacks command: 2, guide: 2, test: 2, children: 2, interface: 2, inspect: 2

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
      def has_interface?  , do: has?({:interface, 2})
      @doc false
      def has_inspect?    , do: has?({:inspect, 2})

      defp flist      , do: __MODULE__.__info__(:functions)
      defp has?(tuple), do: Enum.any?(flist(), &(&1 == tuple))

      use Ecto.Schema
      import Ecto.Changeset
      
      import Atree.Data.Ctx
      
      @behaviour Atree.Action
    end
  end
end
