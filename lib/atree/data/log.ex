defmodule Atree.Data.Log do

  @moduledoc """
  Action log.
  """

  alias Atree.Data.{Log, Guide}

  defstruct [action: nil, guide: nil, test: nil, children: []]

  @type t :: %Log{
    action: atom(),
    guide: Guide.t,
    test: any(),
    children: list(Log.t)
  }
end
