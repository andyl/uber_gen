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
end
