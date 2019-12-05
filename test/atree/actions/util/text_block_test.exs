defmodule Atree.Actions.Util.TextBlockTest do
  use ExUnit.Case

  alias Atree.Actions.Util.TextBlock
  alias Atree.Data.PlanAction

  test "Export Guide" do
    plan = PlanAction.build({TextBlock, %{header: "asdf", body: "qwer"}})
    assert Atree.Executor.Export.with_input(plan)
  end

  test "CtxAssign" do
    ctx = {TextBlock, %{header: "asdf", body: "qwer"}}
          |> PlanAction.build()
          |> Atree.Executor.Export.with_input() 
    log = List.first(ctx.log)
    assert log.guide.body == "qwer"
    assert log.guide.header == "asdf"
  end

  test "No props" do
    ctx = Atree.Executor.Export.with_input({TextBlock, %{}}) 
    log = List.first(ctx.log)
    refute log.report.valid?
  end
end
