defmodule UberGen.Actions.Util.BlockInFile do

  use UberGen.Action

  @moduledoc """
  Add a text-block to a file.
  """

  # params do
  #   field(:header, :string)
  #   field(:instruction, :string)
  #   field(:text_block, :string)
  #   # field(:check_for, :map)
  #   field(:target_file, :string)
  #   field(:file_type, :string)
  # end

  # verify(params) do
  #   %__MODULE__{}
  #   |> cast(params, [:header, :instruction, :text_block, :target_file, :file_type])
  #   |> validate_required([:text_block, :target_file])
  # end
   
  @shortdoc "ShortDoc for #{__MODULE__}"
   
  @doc """
  Block in file.
  """
  def guide(_ctx, opts) do
    instruction = opts[:instruction] 
    text_block  = opts[:text_block] 
    body = """
    #{instruction}

    ```#{file_type(opts)}
    #{comment_file(opts)}

    #{text_block}
    ```
    """
    if opts[:header] do
      %{header: opts[:header], body: body}
    else
      body
    end
  end

  # ---------------------------------------------------------

  defp file_type(opts) do
    target_file = opts[:target_file] 
    file_ext    = String.split(target_file, ".") |> List.last()
    opts[:file_type] || case file_ext do
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
    fname = opts[:target_file] 
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
