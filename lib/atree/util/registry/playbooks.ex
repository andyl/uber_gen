defmodule Atree.Util.Registry.Playbooks do

  @moduledoc """
  Playbook Registry
  """

  def priv_dir do
    Path.expand("priv/playbooks")
  end

  def home_dir do
    Path.expand("~/.atree/playbooks")
  end

  def path do
    [priv_dir(), home_dir()]
  end

  def full_playbooks do
    path()
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
    |> Enum.map(&({&1, String.replace(&1, path, "")}))
  end

  defp ls_r(path) do
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