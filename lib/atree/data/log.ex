defmodule Atree.Data.Log do

  @moduledoc """
  Action log.
  """

  alias Atree.Data.{Log, Guide}

  defstruct [action: nil, guide: nil, children: []]

  @type t :: %Log{
    action: atom(),
    guide: Guide.t,
    children: list(Log.t)
  }
end
