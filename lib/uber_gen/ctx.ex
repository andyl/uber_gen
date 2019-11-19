defmodule UberGen.Ctx do

  @moduledoc """
  Context data for UberGen Actions.

  Add this line to your module:

      use UberGen.Ctx

  Ctx fields:
  - env: environment data - executor / host / os / lang / et.
  - assigns: dynamic variables
  - log: Action results (command / test / guide) - stored as nested map
  - halted: set to true if pipeline-error occurs
  """

  alias UberGen.Ctx

  defstruct [env: %{}, assigns: %{}, log: [], halted: false]

  @type t :: %Ctx{
    env: map(),
    assigns: map(),
    log: list(),
    halted: boolean()
  }

  @doc false
  defmacro __using__(_opts) do
    quote do
      import UberGen.Ctx
      alias UberGen.Ctx
    end
  end
  
  @doc """
  Set an env value to a key in the context.
  """
  def setenv(%Ctx{env: env} = ctx, key, value) when is_atom(key) do
    %{ctx | env: Map.put(env, key, value)}
  end

  @doc """
  Get an env value to a key in the context.
  """
  def getenv(%Ctx{} = ctx, key) when is_atom(key) do
    ctx.env.key
  end

  @doc """
  Assign a value to a key in the context.

  The "assigns" storage is meant to be used to store values in the context so
  that other actions in your action pipeline can access them. The assigns
  storage is a map.
  """
  def assign(%Ctx{assigns: assigns} = ctx, key, value) when is_atom(key) do
    %{ctx | assigns: Map.put(assigns, key, value)}
  end
  
  @doc """
  Halt the UberGen pipeline.

  Halts the UberGen pipeline by preventing further actions downstream from
  being invoked. 
  """
  def halt(%Ctx{} = ctx) do
    %{ctx | halted: true}
  end
end
