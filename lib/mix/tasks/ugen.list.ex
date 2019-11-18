defmodule Mix.Tasks.Ugen.List do
  use Mix.Task

  alias UberGen.PlaybookUtil

  @shortdoc "Prints help information for tasks"

  @moduledoc """
  Lists all playbooks.
  """

  @shortdoc "List all playbooks"
  def run(_arg) do
    PlaybookUtil.loadpaths!()
    modules = UberGen.PlaybookMix.load_all()
    aliases = PlaybookUtil.load_aliases()
    {docs, max} = PlaybookUtil.build_doc_list(modules, aliases)

    PlaybookUtil.display_doc_list(docs, max)
  end
end

