defmodule Atree.Actions.ConfigSetting do

  use Atree.Action

  @moduledoc """
  ConfigSettings Action

  Extensive text on config settings goes here.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  @doc """
  ConfigSettings Work

  asdf
  """
  def command(context, _options) do
    context
  end

  @doc """
  Test ConfigSettings

  asdf
  """
  def test(_context, _options) do
    true
  end

  @doc """
  Guide ConfigSettings

  asdf
  """
  def guide(_ctx, _opts) do
    header = "HEADER FOR #{__MODULE__}"
    body   = "BODY FOR #{__MODULE__}"
    %{header: header, body: body}
  end
end
