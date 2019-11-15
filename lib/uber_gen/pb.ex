defmodule UberGen.Pb do
  @moduledoc """
  A module that provides conveniences for playbooks.

  Playbooks are modules that can be composed into an application generation
  pipeline.  Each playbook can provide three major elements:

    1) installation guides
    2) software support
    3) validation tests

  Playbooks must:

  - have the module-name prefix `UberGen.Playbooks`
  - add the line `use UberGen.Playbook`

  The `UberGen.Playbook` module has five optional for use in Playbooks.

  | Callback | Arg(s)    | Returns                     | Purpose                   |
  |----------|-----------|-----------------------------|---------------------------|
  | cmd/2    | ctx, opts | new_ctx                     | executable playbook code  |
  | test/2   | ctx, opts | test status                 | validation test           |
  | guide/2  | ctx, opts | guide text                  | playbook documentation    |
  | steps/2  | ctx, opts | list of PB Modules & params | list of playbook children |
  | params/x | TBD       | TBD                         | declare playbook params   |
  | verify/2 | TBD       | TBD                         | param cast and validation |

  All of these macros are optional for any given playbook.

  Calling a Playbook with an 'undefined' macro returns a default value.

  The `UberGen.Playbook` module provides introspection functions that show if a
  method is defined in a playbook: `has_cmd?/0`, `has_call?/0`, `has_test?/0`,
  `has_steps?/0`, `has_guide?/0`
  """

  @callback cmd(any()   , any()) :: any()
  @callback test(any()  , any()) :: any()
  @callback steps(any() , any()) :: any()
  @callback guide(any() , any()) :: any()
  @callback params(any(), any()) :: any()
  @callback verify(any(), any()) :: any()

  @optional_callbacks cmd: 2, test: 2, steps: 2, guide: 2, params: 2, verify: 2

  @doc false
  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :shortdoc, persist: true)

      @doc false
      def has_cmd?    , do: has?({:cmd, 2})
      @doc false
      def has_test?   , do: has?({:test, 2})
      @doc false
      def has_steps?  , do: has?({:steps, 2})
      @doc false
      def has_guide?  , do: has?({:guide, 2})
      @doc false
      def has_verify? , do: has?({:verify, 1})

      defp ok(opts)   , do: %{valid?: true, changes: opts}
      defp mod        , do: __MODULE__
      defp flist      , do: __MODULE__.__info__(:functions)
      defp has?(tuple), do: Enum.any?(flist(), &(&1 == tuple))

      use Ecto.Schema
      import Ecto.Changeset
      import UberGen.Playbook
      import UberGen.Ctx
    end
  end
end
