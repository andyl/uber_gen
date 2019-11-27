defmodule Mix.Tasks.Atree.List do
  use Mix.Task

  alias Atree.Util.Util

  @shortdoc "Prints help information for tasks"

  @moduledoc """
  Lists all playbooks.
  """

  @shortdoc "List all playbooks"
  def run(_arg) do
    {docs, max} = Atree.Util.Registry.Actions.doclist()
    Util.display_doc_list(docs, max)
  end
end
