defmodule Util.Steps do

  def file_data(filename) do
    file_data(filename, file_type(filename))
    |> Util.Svc.convert_to_atom_map()
  end

  defp file_data(filename, "json") do
    filename
    |> Path.expand()
    |> File.read!()
    |> Jason.decode!()
  end

  defp file_data(filename, "yaml") do
    filename
    |> Path.expand()
    |> YamlElixir.read_from_file!()
  end

  # --------------------------------------------------

  def to_steps(input) when is_map(input) do
    mod = "Elixir.UberGen.Playbooks.#{input[:playbook]}" |> String.to_existing_atom()
    opt = input[:params] || %{}
    chr = input[:steps] || %{}
    to_steps(mod, opt, chr)
  end

  def to_steps(input) when is_list(input) do
    input |> Enum.map(&to_steps/1)
  end

  defp to_steps(mod, opt, []) do
    {mod, opt, []}
  end

  defp to_steps(mod, opt, children) do
    offspring = children |> Enum.map(&to_steps(&1))
    {mod, opt, offspring}
  end

  # --------------------------------------------------

  def file_type(fname) do
      fname |> String.split(".") |> List.last()
  end
end
