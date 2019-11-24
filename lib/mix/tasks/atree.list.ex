defmodule Mix.Tasks.Atree.List do
  use Mix.Task

  alias Atree.Util.Util

  @shortdoc "Prints help information for tasks"

  @moduledoc """
  Lists all playbooks.
  """

  @shortdoc "List all playbooks"
  def run(_arg) do
    Util.loadpaths!()
    modules = Atree.Util.Mix.load_all()
    aliases = Util.load_aliases()
    {docs, max} = Util.build_doc_list(modules, aliases)

    Util.display_doc_list(docs, max)
  end
end

