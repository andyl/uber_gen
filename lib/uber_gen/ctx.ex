defmodule UberGen.Ctx do
  defstruct [assigns: %{}, halted: false]

  alias UberGen.Ctx

  @doc """
  Assigns a value to a key in the context.

  The "assigns" storage is meant to be used to store values in the context so
  that other playbooks in your playbook pipeline can access them. The assigns
  storage is a map.
  """
  def assign(%Ctx{assigns: assigns} = ctx, key, value) when is_atom(key) do
    %{ctx | assigns: Map.put(assigns, key, value)}
  end
  
  @doc """
  Halts the UberGen pipeline by preventing further playbooks downstream from
  being invoked. See the docs for `UberGen.Builder` for more information on
  halting a UberGen pipeline.
  """
  def halt(%Ctx{} = ctx) do
    %{ctx | halted: true}
  end
end
