defmodule UberGen.Presentor.Export do

  use UberGen.Ctx

  alias UberGen.Executor.Base
  
  def guide(module) when is_atom(module) do
    guide({module, %{}, Base.children(module, %{}, [])}, 1)
    |> String.replace(~r/\n\n[\n]+/, "\n\n")
  end
  
  def guide(child_list) when is_list(child_list) do
    guide({UberGen.Actions.Util.Null, %{}, child_list}, 0)
    |> String.replace(~r/\n\n[\n]+/, "\n\n")
  end

  def guide({module, opts, []}, depth) do
    output({module, opts}, depth)
  end

  def guide({module, opts, children}, depth) do
    base = output({module, opts}, depth) <> "\n\n"

    alt =
      children
      |> Enum.map(&Base.child_module/1)
      |> Enum.map(&guide(&1, depth + 1))
      |> Enum.join("\n\n")

    base <> alt
  end

  defp output({mod, opts}, depth) do
    doc = Base.guide(mod, %{}, opts)
    hdr = String.duplicate("#", depth)
    block_text(hdr, doc) 
  end

  defp block_text(hdr,  %{header: header, body: body}), do: "#{hdr} #{header}\n\n#{body}"
  defp block_text(hdr,  %{header: header})            , do: "#{hdr} #{header}"
  defp block_text(_hdr, %{body: body})                , do: body
  defp block_text(_hdr, %{})                          , do: ""
  defp block_text(_hdr, body)                         , do: body
end
