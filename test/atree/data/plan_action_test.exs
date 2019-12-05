defmodule Atree.Data.PlanActionTest do
  use ExUnit.Case

  alias Atree.Data.PlanAction

  test "Hello World" do
    assert 1 == 1
  end

  describe "basic execution" do
    test "invocation" do
      assert PlanAction.build(Util.Null) 
    end 

    test "struct" do
      assert PlanAction.build(Util.Null) == %PlanAction{action: Atree.Actions.Util.Null}
    end 

    test "plan" do
      plan = %PlanAction{}
      assert PlanAction.build(plan) == plan
    end 
  end
end
