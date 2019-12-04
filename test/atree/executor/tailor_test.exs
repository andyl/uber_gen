defmodule Atree.Executor.TailorTest do
  use ExUnit.Case

  alias Atree.Executor.Tailor
  alias Atree.Actions
  
  test "Hello World" do
    assert 1 == 1
  end

  describe "New Runner" do
    test "short name" do
      assert Tailor.with_action(Util.Null)
    end

    test "description" do
      assert Tailor.with_action(Actions.Util.Null)
    end

    test "full qualified action name" do
      assert Atree.Executor.Tailor.with_action(Atree.Actions.Util.Null)
    end

    test "with props" do
      plan = %{action: Actions.Ctx.Assign, props: %{a: 1, b: 2}}
      assert Tailor.with_action(plan)
    end

    test "with children" do
      plan = %{action: Actions.Util.Null, children: [Actions.Util.Null]}
      assert Tailor.with_action(plan)
    end
  end

  describe "Actions" do
    test "CtxAssign" do
      plan = %{action: Actions.Ctx.Assign, props: %{a: 1, b: 2}}
      ctx = Atree.Executor.Tailor.with_action(plan)
      assert ctx.assigns[:a] == 1
      assert ctx.assigns[:b] == 2
    end
  end
end
