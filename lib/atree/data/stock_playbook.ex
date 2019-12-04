defmodule Atree.Data.StockPlaybook do
  @moduledoc """
  Atree StockPlaybook - for ingesting playbooks.

  The StockPlaybook is a bundle of attributes used to ingest a playbook.

    | Attribute | Desc              | Purpose                                  |
    |-----------|-------------------|------------------------------------------|
    | playbook  | playbook filename | specifies the playbook file              |
    | auth      | auth spec         | determines if the playbook should be run |

  Playbooks can be in either JSON or YAML format.
  """

  alias Atree.Data.{StockPlaybook}

  @derive Jason.Encoder

  defstruct action: nil, auth: nil

  @type t :: %StockPlaybook{
          action: any(),
          auth: any()
        }

end
