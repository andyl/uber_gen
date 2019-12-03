defmodule Atree.Actions.Util.Command do
  @moduledoc """
  Run a command.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  use Atree.Action, 
    header: [], 
    instruction: [], 
    command: [], 
    creates: [type: [:string]]

  def inspect(ctx, props) do
    %__MODULE__{}
    |> cast(props, [:header, :instruction, :command, :creates])
    |> validate_required([:command])
    |> changeset_report(ctx)
  end

  def command(ctx, props) do
    [head | args] = String.split(props.command, " ")
    Rambo.run(head, args || [])
    ctx
  end

  def test(_ctx, %{creates: tgt}) when is_list(tgt) do
    if File.exists?(tgt) do
      :ok
    else
      {:error, "Not created (#{tgt})"}
    end
  end

  def test(_ctx, %{creates: tgt}) do
    if File.exists?(tgt) do
      :ok
    else
      {:error, "Not created (#{tgt})"}
    end
  end

  def test(_ctx, _props) do
    :ok
  end

  def guide(_ctx, opts) do
    body = """
    #{opts[:instruction]}

    ```bash
    $ #{opts[:command]}
    ```
    """

    if opts[:header] do
      %{header: opts[:heaeder], body: body}
    else
      body
    end
  end
end
