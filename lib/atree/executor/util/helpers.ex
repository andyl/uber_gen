defmodule Atree.Executor.Util.Helpers do
  @moduledoc false

  # ----- inspect helpers -----

  def changeset_report(changeset, ctx) do
    %Atree.Data.Report{
      ctx: ctx,
      props: changeset.changes,
      valid?: changeset.valid?,
      errors: changeset.errors,
      changeset: changeset
    }
  end

  # ----- test helpers -----

  def file_exists(err, filepath) do
    if File.exists?(filepath) do
      err
    else
      msg = "File does not exist (#{filepath})"
      err ++ [msg]
    end
  end

  def file_contains(err, _filepath, nil), do: err

  def file_contains(err, filepath, text_list) when is_list(text_list) do
    if File.exists?(filepath) do
      file_text = File.read(filepath)
      Enum.reduce(text_list, err, fn(tgt, acc) -> text_contains(acc, file_text, tgt) end)
    else
      file_exists(err, filepath)
    end
  end

  def file_contains(err, filepath, text) do
    if File.exists?(filepath) do
      text_contains(err, File.read(filepath), text)
    else
      file_exists(err, filepath)
    end
  end

  def text_contains(err, _text, nil), do: err

  def text_contains(err, text, target) do
    if text =~ target do
      err
    else
      msg = "Text not found (#{target})"
      err ++ [msg]
    end
  end


  def test_results(err) do
    case err do
      [] -> 
        :ok
      errset ->
        errlist = errset |> Enum.sort() |> Enum.uniq()
        {:error, errlist}
    end
  end
    
  # ----- guide helpers -----

  def gen_guide(report, mod, ctx, props) do
    if report.valid? do
      Atree.Executor.Util.Base.guide(mod, ctx, props)
    else
      body = """
      ```
      -----------------------------
      INVALID PROPS
      #{inspect(props)}
      -----
      #{inspect(report.errors())}
      -----------------------------
      ```
      """

      %{body: body}
    end
  end
end
