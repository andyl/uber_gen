defmodule Atree.Executor.Util.Helpers do
  @moduledoc false

  def changeset_report(changeset, ctx) do
    %Atree.Data.Report{
      ctx: ctx,
      props: changeset.changes,
      valid?: changeset.valid?,
      errors: changeset.errors,
      changeset: changeset
    }
  end

  def gen_guide(report, mod, ctx, props) do
    if report.valid? do
      Atree.Executor.Util.Base.guide(mod, ctx, props)
    else
      body = """
      ```
      -----------------------------
      INVALID PROPS
      #{inspect(props)}
      -----
      #{inspect(report.errors())}
      -----------------------------
      ```
      """

      %{body: body}
    end
  end
end
