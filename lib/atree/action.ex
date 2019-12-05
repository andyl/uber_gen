defmodule Atree.Action do
  @moduledoc """
  A module that provides conveniences for actions.

      def Atree.Actions.MyAction do
        use Atree.Action
      end

  Optionally, you can supply Propspecs:

      def Atree.Actions.MyAction do
        use Atree.Action, 
          header: [type: :string],
          body: [type: :string]

      end

  The Propspecs are accessible via the Module attribute `@propspecs`. (default
  `[]`), and also the `propspecs` function.

  The `Atree.Action` behavior provides five callbacks for use in Actions.

  | Callback   | Arg(s)     | Returns  | Purpose                |
  |------------|------------|----------|------------------------|
  | screen/2   | ctx, props | report   | prop validation        |
  | command/2  | ctx, props | new_ctx  | executable action code |
  | guide/2    | ctx, props | fragment | action documentation   |
  | test/2     | ctx, props | status   | action test            |
  | children/2 | ctx, props | list     | list of children       |

  All of these callbacks are optional for any given action.
  """

  alias Atree.Data.{Ctx, Report, Guide}

  @doc """
  Action command.  

  The primary purpose of the Command method is to perform an operation that
  generates a state change in the target system.  

  Commands must be idempotent.  Use your test to determine if you need to
  re-run command code.
  """
  @callback command(Ctx.t(), map()) :: Ctx.t()

  @doc """
  Emit guide fragment.
  """
  @callback guide(Ctx.t(), map()) :: Guide.t()

  @doc """
  Run a test.
  """
  @callback test(Ctx.t(), map()) :: :ok | {:error, String.t()}

  @doc """
  Return list of default children.

  The default children can be over-ridden by Playbooks and in parent actions.
  """
  @callback children(Ctx.t(), map()) :: list()

  @doc """
  Perform casting and validation on Props.

  Primary uses: data casting, data validation, form validation.

  Validation can be done on *either* the Ctx[:assigns] values, or the Props.

  You can optionally use ecto validations.

  You can optionally update the ctx assigns.

  See the Executor modules (Run, Export) to see how the screen function is used.
  """
  @callback screen(Ctx.t(), map()) :: Report.t()

  @optional_callbacks command: 2, guide: 2, test: 2, children: 2, screen: 2

  @doc false
  defmacro __using__(props \\ []) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Atree.Executor.Util.Helpers
      import Atree.Data.Ctx

      @propspecs unquote(props)

      gentype = fn
        nil -> :string
        [type] -> {:array, type}
        type -> type
      end

      tuple_list =
        Enum.map(unquote(props), fn {name, props} ->
          {name, gentype.(Keyword.get(props, :type))}
        end)

      embedded_schema do
        Enum.each(tuple_list, fn({name, type}) ->
          field(name, type)
        end)
      end

      Module.register_attribute(__MODULE__, :shortdoc, persist: true)

      @doc false
      def propspecs, do: @propspecs

      @doc false
      def has_command?, do: has?({:command, 2})
      @doc false
      def has_guide?, do: has?({:guide, 2})
      @doc false
      def has_test?, do: has?({:test, 2})
      @doc false
      def has_children?, do: has?({:children, 2})
      @doc false
      def has_screen?, do: has?({:screen, 2})

      defp func_list, do: __MODULE__.__info__(:functions)
      defp has?(tuple), do: Enum.any?(func_list(), &(&1 == tuple))

      @behaviour Atree.Action
    end
  end
end
