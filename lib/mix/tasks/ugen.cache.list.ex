defmodule Mix.Tasks.Ugen.Cache.List do
  use Mix.Task
  # use UberGen.Playbook 

  alias UberGen.PlaybookUtil

  @shortdoc "Prints help information for tasks"

  @moduledoc """
  Lists all playbooks.

  """

  @shortdoc "List all playbooks"
  def run(arg \\ []) do
    PlaybookUtil.loadpaths!()
    modules = UberGen.Playbook.load_all()
    aliases = PlaybookUtil.load_aliases()
    {docs, max} = PlaybookUtil.build_doc_list(modules, aliases)

    IO.inspect "---------------------------------------"
    IO.inspect arg
    IO.inspect modules
    IO.inspect "---------------------------------------"

    PlaybookUtil.display_doc_list(docs, max)
  end

  # def run(["--names"]) do
  #   loadpaths!()
  #
  #   tasks = Enum.map(load_tasks(), &Mix.Task.task_name/1)
  #
  #   aliases =
  #     Enum.map(Mix.Project.config()[:aliases], fn {alias_name, _} ->
  #       Atom.to_string(alias_name)
  #     end)
  #
  #   for info <- Enum.sort(aliases ++ tasks) do
  #     Mix.shell().info(info)
  #   end
  # end

  # def run(["--search", pattern]) do
  #   loadpaths!()
  #
  #   modules = Enum.filter(load_tasks(), &String.contains?(Mix.Task.task_name(&1), pattern))
  #   aliases = Enum.filter(load_aliases(), fn {name, _} -> String.contains?(name, pattern) end)
  #
  #   {docs, max} = build_doc_list(modules, aliases)
  #   display_doc_list(docs, max)
  # end

  # def run(["--search"]) do
  #   Mix.raise("Unexpected arguments, expected \"mix help --search PATTERN\"")
  # end

  # def run([task]) do
  #   loadpaths!()
  #
  #   opts = Application.get_env(:mix, :colors)
  #
  #   opts =
  #     if ansi_docs?(opts) do
  #       [width: width()] ++ opts
  #     else
  #       opts
  #     end
  #
  #   for doc <- verbose_doc(task) do
  #     print_doc(task, doc, opts)
  #   end
  # end

  # def run(_) do
  #   Mix.raise("Unexpected arguments, expected \"mix help\" or \"mix help TASK\"")
  # end

  defp print_doc(task, {doc, location, note}, opts) do
    if ansi_docs?(opts) do
      opts = [width: width()] ++ opts
      IO.ANSI.Docs.print_heading("mix #{task}", opts)
      IO.ANSI.Docs.print(doc, opts)
      IO.puts("Location: #{location}")
      note && IO.puts("") && IO.ANSI.Docs.print(note, opts)
    else
      IO.puts("# mix #{task}\n")
      IO.puts(doc)
      IO.puts("\nLocation: #{location}")
      note && IO.puts([?\n, note, ?\n, ?\n])
    end
  end
  
  defp load_tasks() do
    Enum.filter(Mix.Task.load_all(), &(Mix.Task.moduledoc(&1) != false))
  end

  defp ansi_docs?(opts) do
    Keyword.get(opts, :enabled, IO.ANSI.enabled?())
  end

  defp width() do
    case :io.columns() do
      {:ok, width} -> min(width, 80)
      {:error, _} -> 80
    end
  end

  defp where_is_file(module) do
    case :code.where_is_file(Atom.to_charlist(module) ++ '.beam') do
      :non_existing ->
        "not available"

      location ->
        location
        |> Path.dirname()
        |> Path.expand()
        |> Path.relative_to_cwd()
    end
  end

  defp display_default_task_doc(max) do
    message = "Runs the default task (current: \"mix #{Mix.Project.config()[:default_task]}\")"
    Mix.shell().info(PlaybookUtil.format_task("mix", max, message))
  end

  defp display_iex_task_doc(max) do
    Mix.shell().info(PlaybookUtil.format_task("iex -S mix", max, "Starts IEx and runs the default task"))
  end

  defp verbose_doc(task) do
    aliases = PlaybookUtil.load_aliases()

    has_alias? = Map.has_key?(aliases, task)
    has_task? = Mix.Task.get(task)

    cond do
      has_alias? and has_task? ->
        note = "There is also a task named \"#{task}\". The documentation is shown next."
        [alias_doc(aliases[task], note), task_doc(task)]

      has_alias? ->
        [alias_doc(aliases[task], nil)]

      true ->
        [task_doc(task)]
    end
  end

  defp alias_doc(task_name, note) do
    {"Alias for " <> inspect(task_name), "mix.exs", note}
  end

  defp task_doc(task) do
    module = Mix.Task.get!(task)
    doc = Mix.Task.moduledoc(module) || "There is no documentation for this task"
    {doc, where_is_file(module), nil}
  end
end

