defmodule Atree.Data.Log do

  @moduledoc """
  Action log.
  """

  alias Atree.Data.{Log, Guide, Report}

  defstruct [action: nil, guide: nil, test: nil, report: nil, children: []]

  @type t :: %Log{
    action: atom(),
    guide: Guide.t,
    test: any(),
    report: Report.t,
    children: list(Log.t)
  }
end
