defmodule Atree.Executor.Export do

  @moduledoc """
  Exports an Action guide.

  The `Export.guide` function traverses an Action tree and saves guide
  fragments into the `log` attribute of the `Atree.Data.Ctx`.

  To generate output, pipe the result into an `Atree.Presentor`:

      Atree.Executor.Export.guide(MyModule)
      |> Atree.Presentor.Markdown.to_stdout()

  """

  use Atree.Executor.Util.ExecTree

  def exec_log(mod, ctx, props) do

    report = Base.inspect(mod, ctx, props)
    ctx_v2 = report.ctx || ctx  

    log = %{
      action: mod,
      guide: Base.guide(mod, ctx_v2, props),
      children: []
    }

    {ctx_v2, log}
  end

end
