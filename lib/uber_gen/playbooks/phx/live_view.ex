defmodule UberGen.Playbooks.Phx.Deps do
  use UberGen.Playbook

  @shortdoc "ShortDoc for #{__MODULE__}"

  @moduledoc """
  Playbook for adding dependencies to a Mix project.

  This playbook takes two options:

  **intro_text** - some intro text

  **dependency_list** - a list of dependencies
  """

  guide(_ctx, _opts) do
    header = "Install Dependencies"
    intro  = "TBD"

    body = """
    #{intro}
    
    More text here.
    """

    %{header: header, body: body}
  end

  test(_ctx, _opts) do
    true
  end
end
