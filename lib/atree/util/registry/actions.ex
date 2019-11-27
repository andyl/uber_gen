defmodule Atree.Util.Registry.Actions do

  def doclist do
    modules = Atree.Util.Mix.load_all() 

    # {docs, max}
    Atree.Util.Util.build_doc_list(modules, %{}) 
  end
end
