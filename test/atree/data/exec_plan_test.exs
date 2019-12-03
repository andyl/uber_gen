defmodule Atree.Data.ExecPlanTest do
  use ExUnit.Case

  alias Atree.Data.ExecPlan

  test "Hello World" do
    assert 1 == 1
  end

  describe "basic execution" do
    test "invocation" do
      assert ExecPlan.build(Util.Null) 
    end 

    test "struct" do
      assert ExecPlan.build(Util.Null) == %ExecPlan{action: Atree.Actions.Util.Null}
    end 

    test "plan" do
      plan = %ExecPlan{}
      assert ExecPlan.build(plan) == plan
    end 
  end
end
