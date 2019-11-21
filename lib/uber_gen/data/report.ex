defmodule UberGen.Data.Report do

  @moduledoc """
  Return data from Action#inspect/2

  Add this line to your module:

      use UberGen.Data.Report

  Report fields:
  - ctx: an updated context
  - changeset: an updated changeset
  """

  alias UberGen.Data.Report

  defstruct [ctx: nil, changeset: nil]

  @type t :: %Report{
    ctx: UberGen.Data.Ctx.t,
    changeset: map()
  }

  @doc false
  defmacro __using__(_opts) do
    quote do
      import UberGen.Data.Report
      alias UberGen.Data.Report
    end
  end
  
  # @doc """
  # Set an env value to a key in the context.
  # """
  # def setenv(%Report{env: env} = ctx, key, value) when is_atom(key) do
  #   %{ctx | env: Map.put(env, key, value)}
  # end

end
