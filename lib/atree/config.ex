defmodule Atree.Config do
  def action_paths do
    [
      ".",
      "~/src/uber_gen",
      "~/src/atree_shared"
    ]
    |> Enum.map(&Path.expand/1)
    |> cleanup_paths()
  end

  def playbook_paths do
    [
      "~/.atree/playbooks"
    ]
    |> Enum.concat(action_privs())
    |> List.flatten()
    |> cleanup_paths()
  end

  # ---------------------------------------

  defp cleanup_paths(list) do
    list
    |> Enum.map(&Path.expand/1)
    |> Enum.uniq() 
    |> Enum.sort()
  end

  defp action_privs do
    action_paths()
    |> Enum.map(&"#{&1}/priv/playbooks")
  end
end
