defmodule Atree.Data.Prop do

  @moduledoc """
  Action property.
  """

  alias Atree.Data.Prop

  defstruct [name: nil, type: nil, default: nil, required: false, format: nil]

  @type t :: %Prop{
    name: String.t,
    type: any(),
    required: boolean(),
    default: any(),
    format: any()
  }
end
