defmodule Util.Svc do

  @moduledoc false

  @doc """
  Changes String Map to Map of Atoms 
    
  e.g. 

  %{"c"=> "d", "x" => %{"yy" => "zz"}} to
  %{c: "d", x: %{yy: "zz"}}

  i.e changes even the nested maps. and nested lists.
  """
  def convert_to_atom_map(map), do: to_atom_map(map)

  defp to_atom_map(map) when is_map(map) do
    map
    |> Map.new(fn {k, v} -> {String.to_atom(k), to_atom_map(v)} end)
  end
  
  defp to_atom_map(list) when is_list(list) do
    list
    |> Enum.map(&(to_atom_map(&1)))
  end

  defp to_atom_map(v), do: v
end
