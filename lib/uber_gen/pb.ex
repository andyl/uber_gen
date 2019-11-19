# defmodule UberGen.Action do
#   @moduledoc """
#   A module that provides conveniences for playbooks.
#
#   Actions must:
#
#   - have the module-name prefix `UberGen.Actions`
#   - add the line `use UberGen.Action`
#
#   The `UberGen.Action` module provides five macros for use in Actions.
#
#   | Macro    | Arg(s)    | Returns     | Purpose                   |
#   |----------|-----------|-------------|---------------------------|
#   | command/2    | ctx, opts | new_ctx     | executable playbook code  |
#   | test/2   | ctx, opts | test status | validation test           |
#   | guide/2  | ctx, opts | guide text  | playbook documentation    |
#   | steps/2  | ctx, opts | child list  | list of playbook children |
#   | params/x | TBD       | TBD         | declare playbook params   |
#   | verify/2 | TBD       | TBD         | param cast and validation |
#
#   All of these macros are optional for any given playbook.
#
#   Calling a Action with an 'undefined' macro returns a default value.
#
#   The `UberGen.Action` module provides introspection functions that show if a
#   method is defined in a playbook: `has_command?/0`, `has_call?/0`, `has_test?/0`,
#   `has_steps?/0`, `has_guide?/0`
#   """
#
#   @doc false
#   defmacro __using__(_opts) do
#     quote do
#       Module.register_attribute(__MODULE__, :shortdoc, persist: true)
#
#       @doc false
#       def has_command?    , do: has?({:_command, 2})
#       @doc false
#       def has_test?   , do: has?({:_test, 2})
#       @doc false
#       def has_steps?  , do: has?({:_steps, 2})
#       @doc false
#       def has_guide?  , do: has?({:_guide, 2})
#       @doc false
#       def has_verify? , do: has?({:_verify, 1})
#
#       @doc false
#       def command(ctx, opts)  , do: if has_command?()   , do: apply(mod(), :_command,    [ctx, opts]) , else: ctx
#       @doc false
#       def test(ctx, opts) , do: if has_test?()  , do: apply(mod(), :_test,   [ctx, opts]) , else: true
#       @doc false
#       def guide(ctx, opts), do: if has_guide?() , do: apply(mod(), :_guide,  [ctx, opts]) , else: ""
#       @doc false
#       def steps(ctx, opts), do: if has_steps?() , do: apply(mod(), :_steps,  [ctx, opts]) , else: []
#       @doc false 
#       def verify(opts)    , do: if has_verify?(), do: apply(mod(), :_verify, [opts])      , else: ok(opts)
#
#       defp ok(opts)   , do: %{valid?: true, changes: opts}
#       defp mod        , do: __MODULE__
#       defp flist      , do: __MODULE__.__info__(:functions)
#       defp has?(tuple), do: Enum.any?(flist(), &(&1 == tuple))
#
#       use Ecto.Schema
#       import Ecto.Changeset
#       import UberGen.Action
#       import UberGen.Ctx
#     end
#   end
#
#   @doc """
#   Define Actions params.
#   """
#   defmacro params(do: yeild) do
#     quote do
#       embedded_schema do
#         unquote(yeild)
#       end
#     end
#   end
#
#   @doc """
#   Verify Action params.
#   """
#   defmacro verify(params, do: yeild) do
#     quote do
#       def _verify(unquote(params)) do
#         unquote(yeild)
#       end
#     end
#   end
#
#   @doc false
#   defmacro command(ctx, opts, do: yeild) do
#     quote do
#       def _command(unquote(ctx), unquote(opts)) do
#         unquote(yeild)
#       end
#     end
#   end
#
#   @doc false
#   defmacro guide(ctx, opts, do: yeild) do
#     quote do
#       def _guide(unquote(ctx), unquote(opts)) do
#         changeset = verify(unquote(opts))
#         if changeset.valid? do
#           fn (cx, op) -> unquote(yeild) end.(unquote(ctx), changeset.changes)
#         else
#           """
#           ---
#           Action Error: Invalid Params (#{__MODULE__})
#
#           ```
#           #{inspect(changeset.errors)}
#           ```
#           ---
#           """
#         end
#       end
#     end
#   end
#
#   @doc false
#   defmacro test(ctx, opts, do: yeild) do
#     quote do
#       def _test(unquote(ctx), unquote(opts)) do
#         unquote(yeild)
#       end
#     end
#   end
#
#   @doc """
#   Action steps.
#
#   Bong bang bong.
#   """
#   defmacro steps(ctx, opts, do: yeild) do
#     quote do
#       def _steps(unquote(ctx), unquote(opts)) do
#         unquote(yeild)
#       end
#     end
#   end
# end
