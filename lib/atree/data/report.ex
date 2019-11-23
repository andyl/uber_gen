defmodule Atree.Data.Report do

  @moduledoc """
  Return data from Action#inspect/2

  Add this line to your module:

      use Atree.Data.Report

  Report fields:
  - ctx: an updated context
  - changeset: an updated changeset
  """

  alias Atree.Data.Report

  defstruct [ctx: nil, changeset: nil]

  @type t :: %Report{
    ctx: Atree.Data.Ctx.t,
    changeset: map()
  }

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Atree.Data.Report
      alias Atree.Data.Report
    end
  end
  
  # @doc """
  # Set an env value to a key in the context.
  # """
  # def setenv(%Report{env: env} = ctx, key, value) when is_atom(key) do
  #   %{ctx | env: Map.put(env, key, value)}
  # end

end
