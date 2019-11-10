defmodule UberGen.Playbooks.Util.BlockInFile do

  use UberGen.Playbook

  @moduledoc """
  Add a text-block to a file.

  Options:
  - instruction
  - text_block
  - check_for
  - target_file
  - file_type 
  """

  # params do
  #   field(:instruction, :string)
  #   field(:text_block, :string)
  #   field(:check_for, :string)
  #   field(:target_file, :string)
  #   field(:file_type, :string)
  # end

  @shortdoc "ShortDoc for #{__MODULE__}"

  @doc """
  Block in file.
  """
  guide(_ctx, opts) do
    instruction = Keyword.get(opts, :instruction)
    text_block  = Keyword.get(opts, :text_block)
    """
    #{instruction}
    
    ```#{file_type(opts)}
    #{comment_file(opts)}

    #{text_block}
    ```
    """
  end

  # ---------------------------------------------------------

  defp file_type(opts) do
    target_file = Keyword.get(opts, :target_file)
    file_ext    = String.split(target_file, ".") |> List.last()
    Keyword.get(opts, :file_type) || case file_ext do
      "ex"   -> "elixir"
      "exs"  -> "elixir"
      "json" -> "json"
      "js"   -> "javascript"
      "css"  -> "css"
      "sh"   -> "bash"
      _      -> ""
    end
  end

  defp comment_file(opts) do
    fname = Keyword.get(opts, :target_file)
    ftype = file_type(opts)
    case ftype do
      "bash"       -> "# #{fname}"
      "elixir"     -> "# #{fname}"
      "javascript" -> "// #{fname}"
      "css"        -> "/* #{fname} */"
      _            -> "# #{fname}"
    end
  end

end
