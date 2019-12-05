defmodule Atree.Data.Log do
  @moduledoc """
  Action log.
  """

  alias Atree.Data.{Log, Guide, Report}
  
  @derive {Jason.Encoder, only: [:action, :auth, :test, :guide, :report, :children]}

  defstruct action: nil, guide: nil, test: nil, report: nil, auth: true, children: []

  @type t :: %Log{
          action: atom(),
          auth: boolean(),
          test: any(),
          guide: Guide.t(),
          report: Report.t(),
          children: list(Log.t())
        }

end
