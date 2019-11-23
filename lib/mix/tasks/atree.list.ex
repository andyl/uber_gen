defmodule Mix.Tasks.Atree.List do
  use Mix.Task

  alias Atree.ActionUtil

  @shortdoc "Prints help information for tasks"

  @moduledoc """
  Lists all playbooks.
  """

  @shortdoc "List all playbooks"
  def run(_arg) do
    ActionUtil.loadpaths!()
    modules = Atree.ActionMix.load_all()
    aliases = ActionUtil.load_aliases()
    {docs, max} = ActionUtil.build_doc_list(modules, aliases)

    ActionUtil.display_doc_list(docs, max)
  end
end

