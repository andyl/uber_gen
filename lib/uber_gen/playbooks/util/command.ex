defmodule UberGen.Playbooks.Util.Command do
  # use UberGen.Playbook
  #
  # @moduledoc """
  # Run a command.
  # """
  #
  # params do
  #   field(:header, :string)
  #   field(:instruction, :string)
  #   field(:command, :string)
  #   field(:creates, :string)
  # end
  #
  # verify(params) do
  #   %__MODULE__{}
  #   |> cast(params, [:header, :instruction, :command, :creates])
  #   |> validate_required([:command])
  # end
  #
  # @shortdoc "ShortDoc for #{__MODULE__}"
  #
  # @doc """
  # Run command
  # """
  # guide(ctx, opts) do
  #   body = """
  #   #{opts[:instruction]}
  #
  #   ```bash
  #   $ #{opts[:command]}
  #   ```
  #   """
  #
  #   if opts[:header] do
  #     %{header: opts[:heaeder], body: body}
  #   else
  #     body
  #   end
  # end
end
