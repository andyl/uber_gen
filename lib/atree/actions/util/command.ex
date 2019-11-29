defmodule Atree.Actions.Util.Command do
  use Atree.Action

  @moduledoc """
  Run a command.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  def interface(_ctx, _opts) do
    %{
      header: :string,
      instruction: :string,
      command: :string,
      creates: [:string]
    }
  end

  def inspect(_ctx, _opts) do
    #%__MODULE__{}
    #|> cast(params, [:header, :instruction, :command, :creates])
    #|> validate_required([:command])
   %Atree.Data.Report{} 
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
