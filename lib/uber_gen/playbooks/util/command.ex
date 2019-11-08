defmodule UberGen.Playbooks.Util.Command do

  use UberGen.Playbook

  @moduledoc """
  Run a command.
  """

  @shortdoc "ShortDoc for #{__MODULE__}"

  @doc """
  Run command

  Options:
  - instruction
  - command
  - creates
  """
  guide(_ctx, _opts) do
    "RUN_COMMAND HELLO WORLD"
  end
end
