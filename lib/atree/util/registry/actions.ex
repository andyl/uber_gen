defmodule Atree.Util.Registry.Actions do
  def doclist do
    modules = Atree.Util.Mix.load_all()

    Atree.Util.Util.build_doc_list(modules, %{})
  end

  def find(task_name) do
    Atree.Util.Mix.load_all()
    |> Atree.Util.Util.build_playbook_list()
    |> Enum.filter(&(elem(&1, 1) == task_name))
    |> List.first()
  end
end
