defmodule UberGen.Playbooks.ConfigSetting do

  use UberGen.Playbook

  @moduledoc """
  ConfigSettings Playbook

  Extensive text on config settings goes here.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  @doc """
  Call ConfigSettings

  asdf
  """
  call(context, _options) do
    context
  end

  @doc """
  Test ConfigSettings

  asdf
  """
  test(_context, _options) do
    true
  end

  @doc """
  Guide ConfigSettings

  asdf
  """
  guide(_context, _options) do
    header = "HEADER FOR #{__MODULE__}"
    body   = "BODY FOR #{__MODULE__}"
    %{header: header, body: body}
  end
end
