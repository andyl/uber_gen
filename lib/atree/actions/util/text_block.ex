defmodule Atree.Actions.Util.TextBlock do
  @moduledoc """
  Basic Text Block with header and body.

  Either a body or a header must be supplied.

  Body can be any markdown text.
  """

  @shortdoc "Simple TextBlock"

  alias Atree.Data.{Guide}

  use Atree.Action, body: [], header: []

  def inspect(ctx, props) do
    %__MODULE__{}
    |> cast(props, [:header, :body])
    |> validate_one([:header, :body])
    |> changeset_report(ctx)
  end

  def guide(_ctx, props) do
    struct(Guide, props)
  end

  # ----------------------------------

  defp validate_one(changeset, props) do
    if Enum.any?(props, &present?(changeset, &1)) do
      changeset
    else
      add_error(changeset, hd(props), "One of these props must be present: #{inspect(props)}")
    end
  end

  defp present?(changeset, param) do
    value = get_field(changeset, param)
    value && value != ""
  end
end
