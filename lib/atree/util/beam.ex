defmodule Atree.Util.Beam do
  @moduledoc """
  A module that provides conveniences for actions.
  """

  @type action_name :: String.t() | atom
  @type action_module :: atom

  def code_paths do
    :code.get_path() 
    |> Enum.map(&(List.to_string(&1)))
    |> Enum.concat(ebins())
    |> List.flatten() 
    |> Enum.sort() 
    |> Enum.uniq() 
  end

  def ebins(list \\ ["."]) do
    list
    |> Enum.filter(&is_binary/1)
    |> Enum.filter(&(byte_size(&1) > 0))
    |> Enum.map(&Path.expand/1)
    |> Enum.map(&(Path.wildcard("#{&1}/_build/dev/**/*ebin")))
    |> List.flatten()
  end

  def set_paths() do
    ebins()
    |> Enum.map(&(String.to_charlist(&1)))
    |> Enum.map(&(:code.add_path(&1)))
  end

  @doc """
  Loads all actions in all code paths.
  """
  @spec load_all() :: [action_module]
  def load_all do
    set_paths()
    code_paths()
    |> load_actions()
  end

  @doc """
  Loads all actions in the given `paths`.
  """
  @spec load_actions([List.Chars.t()]) :: [action_module]
  def load_actions(dirs) do
    # We may get duplicate modules because we look through the
    # entire load path so make sure we only return unique modules.
    for dir <- dirs,
      file <- safe_list_dir(to_charlist(dir)),
      mod = action_from_path(file),
        uniq: true,
        do: mod
  end

  defp safe_list_dir(path) do
    case File.ls(path) do
      {:ok, paths} -> paths
      {:error, _} -> []
    end
  end

  @prefix_size byte_size("Elixir.Atree.Actions.")
  @suffix_size byte_size(".beam")

  defp action_from_path(filename) do
    base = Path.basename(filename)
    part = byte_size(base) - @prefix_size - @suffix_size

    case base do
      <<"Elixir.Atree.Actions.", rest::binary-size(part), ".beam">> ->
        mod = :"Elixir.Atree.Actions.#{rest}"
        ensure_action?(mod) && mod

      _ ->
        nil
    end
  end

  @doc """
  Returns all loaded action modules.
  Modules that are not yet loaded won't show up.
  Check `load_all/0` if you want to preload all actions.
  """
  @spec all_modules() :: [action_module]
  def all_modules do
    for {module, _} <- :code.all_loaded(), action?(module), do: module
  end

  @doc """
  Gets the moduledoc for the given action `module`.
  Returns the moduledoc or `nil`.
  """
  @spec moduledoc(action_module) :: String.t() | nil | false
  def moduledoc(module) when is_atom(module) do
    case Code.fetch_docs(module) do
      {:docs_v1, _, _, _, %{"en" => moduledoc}, _, _} -> moduledoc
      {:docs_v1, _, _, _, :hidden, _, _} -> false
      _ -> nil
    end
  end

  @doc """
  Gets the shortdoc for the given action `module`.
  Returns the shortdoc or `nil`.
  """
  @spec shortdoc(action_module) :: String.t() | nil
  def shortdoc(module) when is_atom(module) do
    case List.keyfind(module.__info__(:attributes), :shortdoc, 0) do
      {:shortdoc, [shortdoc]} -> shortdoc
      _ -> nil
    end
  end

  @doc """
  Returns the action name for the given `module`.
  """
  @spec action_name(action_module) :: action_name
  def action_name(module) when is_atom(module) do
    Atree.Utils.module_name_to_command(module, 2)
  end

  @doc """
  Receives a action name and returns the action module if found.
  Otherwise returns `nil` in case the module
  exists, but it isn't a action or cannot be found.
  """
  @spec get(action_name) :: action_module | nil
  def get(action) do
    case fetch(action) do
      {:ok, module} -> module
      {:error, _} -> nil
    end
  end

  @doc """
  Receives a action name and retrieves the action module.
  ## Exceptions
    * `Mix.NoactionError`      - raised if the action could not be found
    * `Mix.InvalidactionError` - raised if the action is not a valid `Atree.Action`
  """
  @spec get!(action_name) :: action_module
  def get!(action) do
    case fetch(action) do
      {:ok, module} ->
        module

      {:error, :invalid} ->
        raise Atree.InvalidActionError, action: action

      {:error, :not_found} ->
        raise Atree.NoActionError, action: action
    end
  end

  defp fetch(action) when is_binary(action) or is_atom(action) do
    case Atree.Utils.command_to_module(to_string(action), Atree.Actions) do
      {:module, module} ->
        if action?(module), do: {:ok, module}, else: {:error, :invalid}

      {:error, _} ->
        {:error, :not_found}
    end
  end

  @doc """
  Clears all invoked actions, allowing them to be reinvoked.
  This operation is not recursive.
  """
  @spec clear :: :ok
  def clear do
    Atree.Util.Server.clear()
  end

  @doc """
  Returns `true` if given module is a action.
  """
  @spec action?(action_module) :: boolean
  def action?(module) when is_atom(module) do
    match?('Elixir.Atree.Actions.' ++ _, Atom.to_charlist(module)) and
      ensure_action?(module)
  end

  defp ensure_action?(module) do
    # Code.ensure_loaded?(module) and function_exported?(module, :run, 1)
    # Code.ensure_loaded?(module)
    case Code.ensure_loaded(module) do
      {:error, reason} -> inspect({module, reason}, pretty: true) |> IO.puts()
      _ -> true
    end
  end
end
