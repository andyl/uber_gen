defmodule Atree.Actions.Util.Command do

  @moduledoc """
  Run a command.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  alias Atree.Data.{Report, Prop}
  use Atree.Action,
    [
      %Prop{ name: "header",      type: "string"},
      %Prop{ name: "instruction", type: "string"},
      %Prop{ name: "command",     type: "string"},
      %Prop{ name: "creates",     type: "string"}
    ]

  def inspect(ctx, props) do
    %__MODULE__{}
    |> cast(props, [:header, :instruction, :command, :creates])
    |> validate_required([:command])
    |> changeset_report(ctx)
  end

  def command(ctx, opts) do
    Rambo.run(opts.command)
    ctx
  end

  def test(_ctx, _opts) do

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
