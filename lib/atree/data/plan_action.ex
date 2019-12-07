defmodule Atree.Data.PlanAction do
  @moduledoc """
  Atree PlanAction.

  The PlanAction is a bundle of attributes used to execute an action.

    | Attribute | Desc          | Purpose                                |
    |-----------|---------------|----------------------------------------|
    | action    | action module | specifies which action should be used  |
    | props     | action props  | passed to action for execution         |
    | auth      | auth spec     | determines if the action should be run |
    | children  | child list    | list of action children                |

  Use `PlanAction#build` to generate an PlanAction.
  """

  alias Atree.Data.{Plan, PlanAction}

  @derive Jason.Encoder

  defstruct action: nil, props: nil, auth: nil, children: []

  @type t :: %PlanAction{
          action: any(),
          props: any(),
          auth: any(),
          children: list()
        }

  @doc """
  Creates an PlanAction.
  """
  def build(input), do: input |> to_plan()

  defp to_plan(input) when is_atom(input) do
    mod = expand_action(input)
    lst = get_children(mod)
    %PlanAction{action: mod, children: lst}
  end

  defp to_plan({action, props}) when is_atom(action) and is_map(props) do
    mod = expand_action(action)
    lst = get_children(mod, props)
    %PlanAction{action: mod, props: props, children: lst}
  end

  defp to_plan({mod, props, children})
       when is_atom(mod) and is_map(props) and is_list(children) do
    %PlanAction{
      action: mod |> expand_action(),
      props: props,
      children: children |> Enum.map(&to_plan/1)
    }
  end

  defp to_plan(input = %PlanAction{}), do: input

  defp to_plan(input) when is_map(input) do
    mod = expand_action(input[:action])
    prp = input[:props] || input[:params] || %{}
    lst = case input[:children] do
      nil -> get_children(mod, prp)
      [] -> get_children(mod, prp)
      val -> val
    end

    %PlanAction{
      action: input[:action] |> expand_action(),
      props: input[:props] || input[:params] || %{},
      auth: input[:auths] || input[:auth] || [],
      children: Enum.map(lst, &Plan.expand/1)
    }
  end

  defp to_plan(input) when is_list(input) do
    input |> Enum.map(&to_plan/1)
  end

  defp expand_action(action) when is_atom(action) do
    action |> Atom.to_string() |> expand_action()
  end

  defp expand_action(action) do
    cleanact = action |> String.replace("Elixir.", "")

    base =
      case cleanact do
        "Atree.Actions." <> act -> act
        "Actions." <> act -> act
        act -> act
      end

    "Elixir.Atree.Actions.#{base}" |> String.to_existing_atom()
  end

  defp get_children(module, props \\ %{}) do
    Atree.Executor.Util.Base.children(module, %{}, props)
  end
end
