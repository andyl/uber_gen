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
  def command(context, _props) do
    context
  end

  @doc """
  ConfigSettings Interface
  """
  def interface(_ctx, _props) do
    []
  end

  @doc """
  Test ConfigSettings
  """
  def test(_context, _props) do
    true
  end

  @doc """
  Guide ConfigSettings
  """
  def guide(_ctx, _opts) do
    header = "HEADER FOR #{__MODULE__}"
    body   = "BODY FOR #{__MODULE__}"
    %{header: header, body: body}
  end
end
