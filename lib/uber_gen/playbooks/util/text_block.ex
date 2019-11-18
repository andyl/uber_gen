defmodule UberGen.Playbooks.Util.TextBlock do

  use UberGen.Playbook

  @moduledoc """
  Basic Text Block.

  Basic text block.  No code, no tests.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  # def interface(_ctx, _opts) do
  #   field(:header, :string)
  #   field(:body,   :string)
  #   %{
  #     params: %{
  #
  #   }
  # end

  # def inspect(params) do
  #   %__MODULE__{}
  #   |> cast(params, [:header, :body])
  #   |> validate_one([:header, :body])
  # end

  @doc """
  Guide text.
  """
  def guide(_ctx, opts) do
    opts
  end

  # ----------------------------------

  # defp validate_one(changeset, params) do
  #   if Enum.any?(params, &(present?(changeset, &1))) do
  #     changeset
  #   else
  #     add_error(changeset, hd(params), "One of these params must be present: #{inspect params}")
  #   end
  # end
  
  # defp present?(changeset, param) do
  #   value = get_field(changeset, param) 
  #   value && value != ""
  # end
end
