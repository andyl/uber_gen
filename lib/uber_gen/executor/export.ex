defmodule UberGen.Executor.Export do

  @moduledoc """
  Exports an Action guide.

  The `Export.guide` function traverses an Action tree and saves guide
  fragments into the `log` attribute of the `UberGen.Ctx`.

  To generate output, pipe the result into an `UberGen.Presentor`:

      UberGen.Executor.Export.guide(MyModule)
      |> UberGen.Presentor.Markdown.to_stdout()

  """

  use UberGen.Ctx

  alias UberGen.Executor.Base
  
  def guide(module) when is_atom(module) do
    guide({module, %{}, Base.children(module, %{}, [])})
  end
  
  def guide(child_list) when is_list(child_list) do
    guide({UberGen.Actions.Util.Null, %{}, child_list})
  end

  def guide({module, opts, []}) do
    log(module, opts)
  end

  def guide({module, opts, children}) do
    base = log(module, opts)

    alt =
      children
      |> Enum.map(&Base.child_module/1)
      |> Enum.map(&guide(&1))

    %{base | children: alt}
  end

  defp log(mod, opts) do
    %{
      action: mod,
      guide: Base.guide(mod, %{}, opts),
      children: []
    }
  end
end
