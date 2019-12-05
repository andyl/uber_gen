defmodule Atree.Executor.ExportTest do
  use ExUnit.Case

  alias Atree.Executor.Export
  alias Atree.Actions

  describe "New Runner" do
    test "short name" do
      assert Export.with_input(Util.Null)
    end

    test "description" do
      assert Export.with_input(Actions.Util.Null)
    end

    test "full qualified action name" do
      assert Atree.Executor.Export.with_input(Atree.Actions.Util.Null)
    end

    test "with props" do
      plan = %{action: Actions.Ctx.Assign, props: %{a: 1, b: 2}}
      assert Export.with_input(plan)
    end

    test "with children" do
      plan = %{action: Actions.Util.Null, children: [Actions.Util.Null]}
      assert Export.with_input(plan)
    end
  end

  describe "Actions" do
    test "CtxAssign" do
      plan = %{action: Actions.Ctx.Assign, props: %{a: 1, b: 2}}
      ctx = Atree.Executor.Export.with_input(plan)
      assert ctx.assigns[:a] == 1
      assert ctx.assigns[:b] == 2
    end
  end

  describe "Playbooks" do
    test "test1" do
      assert Atree.Executor.Export.with_input("test1.yaml")
    end

    test "mixed1" do
      assert Atree.Executor.Export.with_input("mixed1.yaml")
    end
  end
end
