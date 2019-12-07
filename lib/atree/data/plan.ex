defmodule Atree.Data.Plan do
  def expand(input = %{playbook: _}) do
    expand_playbook(input)
  end

  def expand(input) when is_binary(input) do
    cond do
      Regex.match?(~r/(\.json)$|(\.yaml)$/, input) ->
        expand_playbook(input)

      true ->
        expand_action(input)
    end
  end

  def expand(input), do: expand_action(input)

  # -----------------------------------------------------------------

  defp expand_playbook(%{playbook: playbook, auth: _auth}) do
    playbook
    |> Atree.Util.Registry.Playbooks.find()
    |> Util.Playbook.file_data()
    |> Atree.Data.PlanAction.build()
  end

  defp expand_playbook(input) when is_map(input) do
    input[:playbook]
    |> Atree.Util.Registry.Playbooks.find()
    |> Util.Playbook.file_data()
    |> Atree.Data.PlanAction.build()
  end

  defp expand_playbook(input) do
    input
    |> Atree.Util.Registry.Playbooks.find()
    |> Util.Playbook.file_data()
    |> Atree.Data.PlanAction.build()
  end

  # -----------------------------------------------------------------

  defp expand_action(input) do
    Atree.Data.PlanAction.build(input)
  end
end
