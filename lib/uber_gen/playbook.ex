defmodule UberGen.Playbook do
  @moduledoc """
  A simple module that provides conveniences for creating,
  loading and manipulating playbooks.

  An UberGen playbook can be defined by simply using `UberGen.Playbook`
  in a module starting with `UberGen.Playbooks.` and defining
  the `run/1` function:

      defmodule UberGen.Playbooks.Echo do
        use UberGen.Playbook
        @impl UberGen.Playbook
        def run(args) do
          Mix.shell().info(Enum.join(args, " "))
        end
      end

  The `run/1` function will receive a list of all arguments passed
  to the command line.

  ## Attributes
  #
  There are a few attributes available in UberGen playbooks to
  configure them in Mix:
    * `@shortdoc`  - makes the playbook public with a short description that appears on `mix help`
    * `@recursive` - runs the playbook recursively in umbrella projects
    * `@preferred_cli_env` - recommends environment to run playbook. It is used in absence of
      a Mix project recommendation, or explicit `MIX_ENV`, and it only works for playbooks
      in the current project. `@preferred_cli_env` is not loaded from dependencies as
      we need to know the environment before dependencies are loaded.
  ## Documentation
  Users can read the documentation for public UberGen playbooks by running `mix help my_playbook`.
  The documentation that will be shown is the `@moduledoc` of the playbook's module.
  """

  @type playbook_name :: String.t() | atom
  @type playbook_module :: atom

  @doc """
  A playbook needs to implement `run` which receives
  a list of command line args.
  """
  @callback run(command_line_args :: [binary]) :: any

  @doc false
  defmacro __using__(_opts) do
    quote do
      Enum.each(
        UberGen.Playbook.supported_attributes(),
        &Module.register_attribute(__MODULE__, &1, persist: true)
      )

      @behaviour UberGen.Playbook
    end
  end

  @doc false
  def supported_attributes do
    [:shortdoc, :recursive, :preferred_cli_env]
  end

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
  Checks if the playbook should be run recursively for all sub-apps in
  umbrella projects.
  Returns `true` or `false`.
  """
  @spec recursive(playbook_module) :: boolean
  def recursive(module) when is_atom(module) do
    case List.keyfind(module.__info__(:attributes), :recursive, 0) do
      {:recursive, [setting]} -> setting
      _ -> false
    end
  end

  @doc """
  Indicates if the current playbook is recursing.
  This returns true if a playbook is marked as recursive
  and it is being executed inside an umbrella project.
  """
  @doc since: "1.8.0"
  @spec recursing?() :: boolean
  def recursing?() do
    Mix.ProjectStack.recursing() != nil
  end

  @doc """
  Gets preferred CLI environment for the playbook.
  Returns environment (for example, `:test`, or `:prod`), or `nil`.
  """
  @spec preferred_cli_env(playbook_name) :: atom | nil
  def preferred_cli_env(playbook) when is_atom(playbook) or is_binary(playbook) do
    case get(playbook) do
      nil ->
        nil

      module ->
        case List.keyfind(module.__info__(:attributes), :preferred_cli_env, 0) do
          {:preferred_cli_env, [setting]} -> setting
          _ -> nil
        end
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
  Checks if an alias called `playbook` exists.
  For more information about playbook aliasing, take a look at the "Aliasing"
  section in the docs for `Mix`.
  """
  @spec alias?(playbook_name) :: boolean
  def alias?(playbook) when is_binary(playbook) do
    alias?(String.to_atom(playbook))
  end

  def alias?(playbook) when is_atom(playbook) do
    Keyword.has_key?(Mix.Project.config()[:aliases], playbook)
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
  If there is an alias with the same name, the alias
  will be invoked instead of the original playbook.
  If the playbook or alias were already invoked, it does not
  run them again and simply aborts with `:noop`.
  It may raise an exception if an alias or a playbook can't
  be found or the playbook is invalid. Check `get!/1` for more
  information.
  """
  @spec run(playbook_name, [any]) :: any
  def run(playbook, args \\ [])

  def run(playbook, args) when is_atom(playbook) do
    run(Atom.to_string(playbook), args)
  end

  def run(playbook, args) when is_binary(playbook) do
    proj = Mix.Project.get()
    alias = Mix.Project.config()[:aliases][String.to_atom(playbook)]

    cond do
      alias && UberGen.PlaybookServer.run({:alias, playbook, proj}) ->
        res = run_alias(List.wrap(alias), args, :ok)
        UberGen.PlaybookServer.put({:playbook, playbook, proj})
        res

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

    recursive = recursive(module)

    cond do
      recursive && Mix.Project.umbrella?() ->
        Mix.ProjectStack.recur(fn ->
          recur(fn _ -> run(playbook, args) end)
        end)

      not recursive && Mix.ProjectStack.recursing() ->
        Mix.ProjectStack.on_recursing_root(fn -> run(playbook, args) end)

      true ->
        UberGen.PlaybookServer.put({:playbook, playbook, proj})

        try do
          module.run(args)
        rescue
          e in OptionParser.ParseError ->
            Mix.raise("Could not invoke playbook #{inspect(playbook)}: " <> Exception.message(e))
        end
    end
  end

  defp output_playbook_debug_info(playbook, args, proj) do
    Mix.shell().info("** Running mix " <> playbook_to_string(playbook, args) <> project_to_string(proj))
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

  defp run_alias([h | t], alias_args, _res) when is_binary(h) do
    [playbook | args] = OptionParser.split(h)
    res = UberGen.Playbook.run(playbook, join_args(args, alias_args, t))
    run_alias(t, alias_args, res)
  end

  defp run_alias([h | t], alias_args, _res) when is_function(h, 1) do
    res = h.(join_args([], alias_args, t))
    run_alias(t, alias_args, res)
  end

  defp run_alias([], _alias_playbook, res) do
    res
  end

  defp join_args(args, alias_args, []), do: args ++ alias_args
  defp join_args(args, _alias_args, _), do: args

  @doc """
  Clears all invoked playbooks, allowing them to be reinvoked.
  This operation is not recursive.
  """
  @spec clear :: :ok
  def clear do
    UberGen.PlaybookServer.clear()
  end

  @doc """
  Reenables a given playbook so it can be executed again down the stack.
  Both alias and the regular stack are reenabled when this function
  is called.
  If an umbrella project reenables a playbook, it is reenabled for all
  child projects.
  """
  @spec reenable(playbook_name) :: :ok
  def reenable(playbook) when is_binary(playbook) or is_atom(playbook) do
    playbook = to_string(playbook)
    proj = Mix.Project.get()
    recursive = (module = get(playbook)) && recursive(module)

    UberGen.PlaybookServer.delete_many([{:playbook, playbook, proj}, {:alias, playbook, proj}])

    cond do
      recursive && Mix.Project.umbrella?() ->
        recur(fn proj ->
          UberGen.PlaybookServer.delete_many([{:playbook, playbook, proj}, {:alias, playbook, proj}])
        end)

      proj = !recursive && Mix.ProjectStack.recursing() ->
        UberGen.PlaybookServer.delete_many([{:playbook, playbook, proj}, {:alias, playbook, proj}])

      true ->
        :ok
    end

    :ok
  end

  defp recur(fun) do
    # Get all dependency configuration but not the deps path
    # as we leave the control of the deps path still to the
    # umbrella child.
    config = Mix.Project.deps_config() |> Keyword.delete(:deps_path)

    for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.cached() do
      Mix.Project.in_project(app, opts[:path], config, fun)
    end
  end

  @doc """
  Reruns `playbook` with the given arguments.
  This function reruns the given playbook; to do that, it first re-enables the playbook
  and then runs it as normal.
  """
  @spec rerun(playbook_name, [any]) :: any
  def rerun(playbook, args \\ []) do
    reenable(playbook)
    run(playbook, args)
  end

  @doc """
  Returns `true` if given module is a playbook.
  """
  @spec playbook?(playbook_module) :: boolean
  def playbook?(module) when is_atom(module) do
    match?('Elixir.UberGen.Playbooks.' ++ _, Atom.to_charlist(module)) and ensure_playbook?(module)
  end

  defp ensure_playbook?(module) do
    Code.ensure_loaded?(module) and function_exported?(module, :run, 1)
  end
end

