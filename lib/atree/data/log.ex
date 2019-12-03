defmodule Atree.Data.Log do
  @moduledoc """
  Action log.
  """

  alias Atree.Data.{Log, Guide, Report}

  defstruct action: nil, guide: nil, test: nil, report: nil, auth: true, children: []

  @type t :: %Log{
          action: atom(),
          guide: Guide.t(),
          test: any(),
          report: Report.t(),
          auth: boolean(),
          children: list(Log.t())
        }

  def skip(ctx, plan) do
    {
      ctx,
      %Log{action: plan.action, auth: false}
    }
  end
end
