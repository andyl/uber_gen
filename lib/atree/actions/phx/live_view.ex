defmodule Atree.Actions.Phx.LiveView do

  use Atree.Action

  @moduledoc """
  ConfigSettings Action

  Extensive text on config settings goes here.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  def children(_ctx, _opts) do
    [
      "live_view.yaml"
    ]
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
