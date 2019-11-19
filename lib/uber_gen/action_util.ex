defmodule UberGen.ActionUtil do

  # Loadpaths without checks because tasks may be defined in deps.
  def loadpaths! do
    args = ["--no-elixir-version-check", "--no-deps-check", "--no-archives-check"]
    Mix.Task.run("loadpaths", args)
    Mix.Task.reenable("loadpaths")
    Mix.Task.reenable("deps.loadpaths")
  end

  def load_aliases() do
    aliases = Mix.Project.config()[:aliases]

    Map.new(aliases, fn {alias_name, alias_tasks} -> {Atom.to_string(alias_name), alias_tasks} end)
  end

  def build_doc_list(modules, aliases) do
    {task_docs, task_max} = build_task_doc_list(modules)
    {alias_docs, alias_max} = build_alias_doc_list(aliases)
    {task_docs ++ alias_docs, max(task_max, alias_max)}
  end

  def build_playbook_list(modules) do
    modules
    |> Enum.map(&({&1, Mix.Task.task_name(&1)}))
  end

  def build_task_doc_list(modules) do
    Enum.reduce(modules, {[], 0}, fn module, {docs, max} ->
      if doc = Mix.Task.shortdoc(module) do
        task = "mix " <> Mix.Task.task_name(module)
        {[{task, doc} | docs], max(byte_size(task), max)}
      else
        {docs, max}
      end
    end)
  end

  def build_alias_doc_list(aliases) do
    Enum.reduce(aliases, {[], 0}, fn {alias_name, _task_name}, {docs, max} ->
      doc = "Alias defined in mix.exs"
      task = "mix " <> alias_name
      {[{task, doc} | docs], max(byte_size(task), max)}
    end)
  end

  def display_doc_list(docs, max) do
    Enum.each(Enum.sort(docs), fn {task, doc} ->
      Mix.shell().info(format_task(task, max, doc))
    end)
  end

  def format_task(task, max, doc) do
    String.pad_trailing(task, max) <> " # " <> doc
  end
end