defmodule Atree.Data.ExecPlan do
  @moduledoc """
  Atree ExecPlan.

  The ExecPlan is a bundle of attributes used to execute an action.

    | Attribute | Desc          | Purpose                                |
    |-----------|---------------|----------------------------------------|
    | action    | action module | specifies which action should be used  |
    | props     | action props  | passed to action for execution         |
    | auth      | auth spec     | determines if the action should be run |
    | children  | child list    | list of action children                |

  Use `ExecPlan#build` to generate an ExecPlan.
  """

  alias Atree.Data.{ExecPlan}

  @derive Jason.Encoder

  defstruct action: nil, props: nil, auth: nil, children: []

  @type t :: %ExecPlan{
          action: any(),
          props: any(),
          auth: any(),
          children: list()
        }

  @doc """
  Creates an ExecPlan.
  """
  def build(input), do: input |> to_plan()

  defp to_plan(input) when is_atom(input) do
    %ExecPlan{action: expand(input)}
  end

  defp to_plan({mod, props}) when is_atom(mod) and is_map(props) do
    %ExecPlan{
      action: mod |> expand(),
      props: props
    }
  end

  defp to_plan({mod, props, children})
       when is_atom(mod) and is_map(props) and is_list(children) do
    %ExecPlan{
      action: mod |> expand(),
      props: props,
      children: children |> Enum.map(&to_plan/1)
    }
  end

  defp to_plan(input = %ExecPlan{}), do: input

  defp to_plan(input) when is_map(input) do
    clist = input[:children] || []

    %ExecPlan{
      action: input[:action] |> expand(),
      props: input[:props] || input[:params] || %{},
      auth: input[:auths] || input[:auth] || [],
      children: Enum.map(clist, &to_plan/1)
    }
  end

  defp to_plan(input) when is_list(input) do
    input |> Enum.map(&to_plan/1)
  end

  defp expand(action) when is_atom(action) do
    action |> Atom.to_string() |> expand()
  end

  defp expand(action) do
    cleanact = action |> String.replace("Elixir.", "")

    base =
      case cleanact do
        "Atree.Actions." <> act -> act
        "Actions." <> act -> act
        act -> act
      end

    "Elixir.Atree.Actions.#{base}" |> String.to_existing_atom()
  end
end
