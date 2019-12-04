defmodule Atree.Data.StockAction do

  alias Atree.Data.{StockAction}

  @derive Jason.Encoder

  defstruct action: nil, props: nil, auth: nil, children: []

  @type t :: %StockAction{
          action: any(),
          props: any(),
          auth: any(),
          children: list()
        }
end
