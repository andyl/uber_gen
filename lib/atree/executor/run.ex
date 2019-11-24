defmodule Atree.Executor.Run do

  @moduledoc """
  Runs Action commands and tests, Exports an Action guide.

  The `Export.guide` function traverses an Action tree and saves guide
  fragments into the `log` attribute of the `Atree.Data.Ctx`.

  To generate output, pipe the result into an `Atree.Presentor`:

      Atree.Executor.Export.guide(MyModule)
      |> Atree.Presentor.Markdown.to_stdout()
  """

  use Atree.Executor.Util.ExecTree

  alias Atree.Data.Log

  def exec_log(mod, ctx, opts) do
    report = Base.inspect(mod, ctx, opts)
    cx0 = report.ctx || ctx
    cx1 = Base.command(mod, cx0, opts)

    log = %Log{
      action: mod,
      test: Base.test(mod, cx1, opts),
      guide: Base.guide(mod, cx1, opts),
      children: []
    }

    cx2 = case log.test do
      {:error, _} -> halt(cx0)
      _ -> cx1
    end
    {cx2, log}
  end

end
