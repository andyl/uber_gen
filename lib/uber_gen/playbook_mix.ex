defmodule UberGen.PlaybookMix do
  @moduledoc """
  A module that provides conveniences for playbooks.
  """

  @type playbook_name :: String.t() | atom
  @type playbook_module :: atom

  @doc """
  Loads all playbooks in all code paths.
  """
  @spec load_all() :: [playbook_module]
  def load_all, do: load_playbooks(:code.get_path())

  @doc """
  Loads all playbooks in the given `paths`.
  """
  @spec load_playbooks([List.Chars.t()]) :: [playbook_module]
  def load_playbooks(dirs) do
    # We may get duplicate modules because we look through the
    # entire load path so make sure we only return unique modules.
    for dir <- dirs,
        file <- safe_list_dir(to_charlist(dir)),
        mod = playbook_from_path(file),
        uniq: true,
        do: mod
  end

  defp safe_list_dir(path) do
    case File.ls(path) do
      {:ok, paths} -> paths
      {:error, _} -> []
    end
  end

  @prefix_size byte_size("Elixir.UberGen.Playbooks.")
  @suffix_size byte_size(".beam")

  defp playbook_from_path(filename) do
    base = Path.basename(filename)
    part = byte_size(base) - @prefix_size - @suffix_size

    case base do
      <<"Elixir.UberGen.Playbooks.", rest::binary-size(part), ".beam">> ->
        mod = :"Elixir.UberGen.Playbooks.#{rest}"
        ensure_playbook?(mod) && mod

      _ ->
        nil
    end
  end

  @doc """
  Returns all loaded playbook modules.
  Modules that are not yet loaded won't show up.
  Check `load_all/0` if you want to preload all playbooks.
  """
  @spec all_modules() :: [playbook_module]
  def all_modules do
    for {module, _} <- :code.all_loaded(), playbook?(module), do: module
  end

  @doc """
  Gets the moduledoc for the given playbook `module`.
  Returns the moduledoc or `nil`.
  """
  @spec moduledoc(playbook_module) :: String.t() | nil | false
  def moduledoc(module) when is_atom(module) do
    case Code.fetch_docs(module) do
      {:docs_v1, _, _, _, %{"en" => moduledoc}, _, _} -> moduledoc
      {:docs_v1, _, _, _, :hidden, _, _} -> false
      _ -> nil
    end
  end

  @doc """
  Gets the shortdoc for the given playbook `module`.
  Returns the shortdoc or `nil`.
  """
  @spec shortdoc(playbook_module) :: String.t() | nil
  def shortdoc(module) when is_atom(module) do
    case List.keyfind(module.__info__(:attributes), :shortdoc, 0) do
      {:shortdoc, [shortdoc]} -> shortdoc
      _ -> nil
    end
  end

  @doc """
  Returns the playbook name for the given `module`.
  """
  @spec playbook_name(playbook_module) :: playbook_name
  def playbook_name(module) when is_atom(module) do
    Mix.Utils.module_name_to_command(module, 2)
  end

  @doc """
  Receives a playbook name and returns the playbook module if found.
  Otherwise returns `nil` in case the module
  exists, but it isn't a playbook or cannot be found.
  """
  @spec get(playbook_name) :: playbook_module | nil
  def get(playbook) do
    case fetch(playbook) do
      {:ok, module} -> module
      {:error, _} -> nil
    end
  end

  @doc """
  Receives a playbook name and retrieves the playbook module.
  ## Exceptions
    * `Mix.NoplaybookError`      - raised if the playbook could not be found
    * `Mix.InvalidplaybookError` - raised if the playbook is not a valid `UberGen.Playbook`
  """
  @spec get!(playbook_name) :: playbook_module
  def get!(playbook) do
    case fetch(playbook) do
      {:ok, module} ->
        module

      {:error, :invalid} ->
        raise UberGen.InvalidPlaybookError, playbook: playbook

      {:error, :not_found} ->
        raise UberGen.NoPlaybookError, playbook: playbook
    end
  end

  defp fetch(playbook) when is_binary(playbook) or is_atom(playbook) do
    case Mix.Utils.command_to_module(to_string(playbook), UberGen.Playbooks) do
      {:module, module} ->
        if playbook?(module), do: {:ok, module}, else: {:error, :invalid}

      {:error, _} ->
        {:error, :not_found}
    end
  end

  @doc """
  Runs a `playbook` with the given `args`.
  If the playbook was not yet invoked, it runs the playbook and
  returns the result.
  """
  @spec run(playbook_name, [any]) :: any
  def run(playbook, args \\ [])

  def run(playbook, args) when is_atom(playbook) do
    run(Atom.to_string(playbook), args)
  end

  def run(playbook, args) when is_binary(playbook) do
    proj = Mix.Project.get()

    cond do
      UberGen.PlaybookServer.run({:playbook, playbook, proj}) ->
        run_playbook(proj, playbook, args)

      true ->
        :noop
    end
  end

  defp run_playbook(proj, playbook, args) do
    if Mix.debug?(), do: output_playbook_debug_info(playbook, args, proj)

    # 1. If the playbook is available, we run it.
    # 2. Otherwise we compile and load dependencies
    # 3. Finally, we compile the current project in hope it is available.
    module =
      get_playbook_or_run(proj, playbook, fn -> UberGen.Playbook.run("deps.loadpaths") end) ||
        get_playbook_or_run(proj, playbook, fn -> Mix.Project.compile([]) end) ||
        get!(playbook)

    UberGen.PlaybookServer.put({:playbook, playbook, proj})

    try do
      module.run(args)
    rescue
      e in OptionParser.ParseError ->
        Mix.raise("Could not invoke playbook #{inspect(playbook)}: " <> Exception.message(e))
    end
  end

  defp output_playbook_debug_info(playbook, args, proj) do
    Mix.shell().info(
      "** Running mix " <> playbook_to_string(playbook, args) <> project_to_string(proj)
    )
  end

  defp project_to_string(nil), do: ""
  defp project_to_string(proj), do: " (inside #{inspect(proj)})"

  defp playbook_to_string(playbook, []), do: playbook
  defp playbook_to_string(playbook, args), do: playbook <> " " <> Enum.join(args, " ")

  defp get_playbook_or_run(proj, playbook, fun) do
    cond do
      module = get(playbook) ->
        module

      proj ->
        fun.()
        nil

      true ->
        nil
    end
  end

  @doc """
  Clears all invoked playbooks, allowing them to be reinvoked.
  This operation is not recursive.
  """
  @spec clear :: :ok
  def clear do
    UberGen.PlaybookServer.clear()
  end

  @doc """
  Returns `true` if given module is a playbook.
  """
  @spec playbook?(playbook_module) :: boolean
  def playbook?(module) when is_atom(module) do
    match?('Elixir.UberGen.Playbooks.' ++ _, Atom.to_charlist(module)) and
      ensure_playbook?(module)
  end

  defp ensure_playbook?(module) do
    Code.ensure_loaded?(module) and function_exported?(module, :run, 1)
  end
end
