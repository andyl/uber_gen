defmodule UberGen.Playbooks.Phx.LiveView do

  use UberGen.Playbook

  @moduledoc """
  ConfigSettings Playbook

  Extensive text on config settings goes here.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  def children(_ctx, _opts) do
    "#{:code.priv_dir(:uber_gen)}/outlines/live_view.yaml"
    |> Util.Steps.file_data()
    |> Util.Steps.to_steps()
  end

  def guide(_ctx, _opts) do
    header = "LiveView Installation Guide"
    body   = """
    While Phoenix LiveView is under heavy development, the installation
    instructions are likely to change rapidly as well.  The instructions below
    will serve if you are installing the latest stable version from Hex.
    """
    %{header: header, body: body}
  end
end
