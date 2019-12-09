defmodule Atree.Config do
  def action_paths do
    [
      ".",
      "~/src/uber_gen",
      "~/src/atree_shared"
    ]
    |> Enum.concat(config_action_paths())
    |> Enum.map(&Path.expand/1)
    |> cleanup_paths()
  end

  def playbook_paths do
    [
      "~/.atree/playbooks"
    ]
    |> Enum.concat(action_privs())
    |> Enum.concat(config_playbook_paths())
    |> List.flatten()
    |> cleanup_paths()
  end

  # ---------------------------------------

  defp config_data do
    file = Path.expand("~/.atree/config.yaml")
    if File.exists?(file) do
      file
      |> YamlElixir.read_from_file!()
    else
      %{}
    end
  end

  defp config_action_paths do
    config_data()[:action_paths] || []
  end

  defp config_playbook_paths do
    config_data()[:playbook_paths] || []
  end

  defp cleanup_paths(list) do
    list
    |> Enum.map(&Path.expand/1)
    |> Enum.uniq() 
    |> Enum.sort()
  end

  defp action_privs do
    action_paths()
    |> Enum.map(&"#{&1}/priv/atree/playbooks")
  end
end
