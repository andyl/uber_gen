defmodule Atree.Actions.Util.TextBlockTest do
  use ExUnit.Case

  alias Atree.Actions.Util.TextBlock

  test "Hello World" do
    assert 1 == 1
  end

  test "Export Guide" do
    assert Atree.Executor.Export.with_action({TextBlock, %{header: "asdf", body: "qwer"}})
  end

  test "CtxAssign" do
    ctx = Atree.Executor.Export.with_action({TextBlock, %{header: "asdf", body: "qwer"}}) 
    log = List.first(ctx.log)
    assert log.guide.body == "qwer"
    assert log.guide.header == "asdf"
  end

  test "No props" do
    ctx = Atree.Executor.Export.with_action({TextBlock, %{}}) 
    log = List.first(ctx.log)
    refute log.report.valid?
  end
end
