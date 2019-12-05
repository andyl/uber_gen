defmodule Atree.Data.PlanPlaybook do
  @moduledoc """
  Atree PlanPlaybook - for ingesting playbooks.

  The PlanPlaybook is a bundle of attributes used to ingest a playbook.

    | Attribute | Desc              | Purpose                                  |
    |-----------|-------------------|------------------------------------------|
    | playbook  | playbook filename | specifies the playbook file              |
    | auth      | auth spec         | determines if the playbook should be run |

  Playbooks can be in either JSON or YAML format.
  """

  alias Atree.Data.{PlanPlaybook}

  @derive Jason.Encoder

  defstruct action: nil, auth: nil

  @type t :: %PlanPlaybook{
          action: any(),
          auth: any()
        }

  def expand(playbook) do
    playbook
  end

end
