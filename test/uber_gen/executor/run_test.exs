defmodule UberGen.Executor.RunTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "Hello World" do
    assert 1 == 1
  end

  test "Run Command" do
    assert UberGen.Executor.Run.with(UberGen.Actions.Util.Null)
  end

  test "CtxAssign" do
    ctx = UberGen.Executor.Run.with({UberGen.Actions.Ctx.Assign, %{a: 1, b: 2}}) 
    assert ctx.assigns.a == 1
    assert ctx.assigns.b == 2
  end
end
