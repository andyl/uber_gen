defmodule Util.Children do

  @moduledoc false

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

  def file_type(fname) do
      fname |> String.split(".") |> List.last()
  end
end
