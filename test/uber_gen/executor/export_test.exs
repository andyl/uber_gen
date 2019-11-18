defmodule UberGen.Executor.ExportTest do
  use ExUnit.Case

  test "Hello World" do
    assert 1 == 1
  end

  test "Export Guide" do
    assert UberGen.Executor.Export.guide(UberGen.Actions.Util.Null)
  end
end
