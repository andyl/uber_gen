defmodule Atree.Util.Registry.Playbooks do

  @moduledoc """
  Playbook Registry
  """

  def find(name) do
    Atree.Util.Registry.Playbooks.full_playbooks()
    |> Enum.find(&(name == elem(&1, 1)))
    |> elem(0)
  end

  def full_playbooks do
    Atree.Config.playbook_paths()
    |> ensure_created()
    |> Enum.map(&expand_all/1)
    |> List.flatten()
  end

  def playbooks do
    full_playbooks()
    |> Enum.map(&(elem(&1, 1)))
    |> Enum.sort()
    |> Enum.uniq()
  end

  defp ensure_created(path) when is_list(path) do
    path |> Enum.each(&(ensure_created(&1)))
    path
  end

  defp ensure_created(path) do
    unless File.exists?(path), do: File.mkdir(path)
  end

  defp expand_all(path) do
    path
    |> ls_r()
    |> Enum.filter(&(Regex.match?(~r/(\.json)$|(\.yaml)$/, &1)))
    |> Enum.map(&({&1, String.replace(&1, "#{path}/", "")}))
  end

  def ls_r(path) do
    cond do
      File.regular?(path) -> [path]
      File.dir?(path) ->
        File.ls!(path)
        |> Enum.map(&Path.join(path, &1))
        |> Enum.map(&ls_r/1)
        |> Enum.concat()
      true -> []
    end
  end
end
