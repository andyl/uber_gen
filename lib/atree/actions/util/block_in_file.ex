defmodule Atree.Actions.Util.BlockInFile do
  @moduledoc """
  Add a text-block to a file.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  use Atree.Action,
    header: [], 
    instruction: [], 
    text_block: [], 
    check_for: [type: [:string]], 
    target_file: [],
    file_type: []

  def inspect(ctx, props) do
    %__MODULE__{}
    |> cast(props, [:header, :instruction, :text_block, :check_for, :target_file, :file_type])
    |> validate_required([:text_block, :target_file])
    |> changeset_report(ctx)
  end

  def test(_ctx, props) do
    []
    |> file_exists(props[:target_file])
    |> file_contains(props[:target_file], props[:check_for])
    |> test_results()
  end

  def guide(_ctx, opts) do
    instruction = opts[:instruction]
    text_block = opts[:text_block]

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
    file_ext = String.split(target_file, ".") |> List.last()

    opts[:file_type] ||
      case file_ext do
        "ex" -> "elixir"
        "exs" -> "elixir"
        "json" -> "json"
        "js" -> "javascript"
        "css" -> "css"
        "sh" -> "bash"
        _ -> ""
      end
  end

  defp comment_file(opts) do
    fname = opts[:target_file]
    ftype = file_type(opts)

    case ftype do
      "bash" -> "# #{fname}"
      "elixir" -> "# #{fname}"
      "javascript" -> "// #{fname}"
      "css" -> "/* #{fname} */"
      _ -> "# #{fname}"
    end
  end
end
