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

  defstruct [ctx: nil, props: %{}, valid?: true, errors: %{}, changeset: %{}]

  @type t :: %Report{
    ctx: Atree.Data.Ctx.t,
    props: map(),
    valid?: boolean(),
    errors: map(),
    changeset: map()
  }

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Atree.Data.Report
      alias Atree.Data.Report
    end
  end
end
