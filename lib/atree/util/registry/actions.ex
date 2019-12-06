defmodule Atree.Util.Registry.Actions do
  def doclist do
    modules = Atree.Util.Beam.load_all()

    Atree.Util.Cli.build_doc_list(modules, %{})
  end

  def find(task_name) do
    Atree.Util.Beam.load_all()
    |> Atree.Util.Cli.build_playbook_list()
    |> Enum.filter(&(elem(&1, 1) == task_name))
    |> List.first()
  end
end
