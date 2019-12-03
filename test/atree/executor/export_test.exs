defmodule Atree.Executor.ExportTest do
  use ExUnit.Case

  alias Atree.Executor.Export
  alias Atree.Actions


  test "Hello World" do
    assert 1 == 1
  end

  describe "New Runner" do
    test "short name" do
      assert Export.auth_action(Util.Null)
    end

    test "description" do
      assert Export.auth_action(Actions.Util.Null)
    end

    test "full qualified action name" do
      assert Atree.Executor.Export.auth_action(Atree.Actions.Util.Null)
    end

    test "with props" do
      plan = %{action: Actions.Ctx.Assign, props: %{a: 1, b: 2}}
      assert Export.auth_action(plan)
    end

    test "with children" do
      plan = %{action: Actions.Util.Null, children: [Actions.Util.Null]}
      assert Export.auth_action(plan)
    end
  end

  describe "Actions" do
    test "CtxAssign" do
      plan = %{action: Actions.Ctx.Assign, props: %{a: 1, b: 2}}
      ctx = Atree.Executor.Export.auth_action(plan)
      assert ctx.assigns[:a] == 1
      assert ctx.assigns[:b] == 2
    end
  end
end
