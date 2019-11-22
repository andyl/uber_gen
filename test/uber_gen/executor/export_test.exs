defmodule UberGen.Executor.ExportTest do
  use ExUnit.Case

  test "Hello World" do
    assert 1 == 1
  end

  test "Export Guide" do
    assert UberGen.Executor.Export.with(UberGen.Actions.Util.Null)
  end

  test "CtxAssign" do
    ctx = UberGen.Executor.Export.with({UberGen.Actions.Ctx.Assign, %{a: 1, b: 2}}) 
    assert ctx.assigns.a == 1
    assert ctx.assigns.b == 2
  end
end
