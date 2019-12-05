require Protocol
Protocol.derive(Jason.Encoder, Ecto.Changeset)
Protocol.derive(Jason.Encoder, Atree.Actions.Util.TextBlock)

defmodule Atree do

  @moduledoc false
  
  def hello do
    :world
  end
end
