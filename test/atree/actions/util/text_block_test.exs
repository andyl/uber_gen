defmodule Atree.Actions.Util.TextBlockTest do
  use ExUnit.Case

  alias Atree.Actions.Util.TextBlock
  alias Atree.Data.ExecPlan

  test "Hello World" do
    assert 1 == 1
  end

  test "Export Guide" do
    plan = ExecPlan.build({TextBlock, %{header: "asdf", body: "qwer"}})
    assert Atree.Executor.Export.auth_action(plan)
  end

  test "CtxAssign" do
    ctx = {TextBlock, %{header: "asdf", body: "qwer"}}
          |> ExecPlan.build()
          |> Atree.Executor.Export.auth_action() 
    log = List.first(ctx.log)
    assert log.guide.body == "qwer"
    assert log.guide.header == "asdf"
  end

  test "No props" do
    ctx = Atree.Executor.Export.auth_action({TextBlock, %{}}) 
    log = List.first(ctx.log)
    refute log.report.valid?
  end
end
