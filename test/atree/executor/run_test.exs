defmodule Atree.Executor.RunTest do
  use ExUnit.Case

  alias Atree.Data.ExecPlan

  test "Hello World" do
    assert 1 == 1
  end

  test "Run Command" do
    assert Atree.Executor.Run.with_action(Atree.Actions.Util.Null)
  end

  test "CtxAssign" do
    plan = %ExecPlan{action: Atree.Actions.Ctx.Assign, props: %{a: 1, b: 2}}
    ctx = Atree.Executor.Run.with_action(plan)
    assert ctx.assigns.a == 1
    assert ctx.assigns.b == 2
  end

  describe "Pipelining" do
    test "Context log is a list" do
      ctx1 = Atree.Executor.Run.with_action(Atree.Actions.Util.Null)
      assert is_list(ctx1.log)
      assert Enum.count(ctx1.log) == 1
    end

    test "Appends log list" do
      ctx1 = Atree.Executor.Run.with_action(Atree.Actions.Util.Null)
      ctx2 = Atree.Executor.Run.with_action(ctx1, Atree.Actions.Util.Null)
      assert is_list(ctx2.log)
      assert Enum.count(ctx2.log) == 2
    end
  end
end
