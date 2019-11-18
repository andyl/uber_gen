defmodule UberGen.Executor.BaseTest do
  use ExUnit.Case

  test "Hello World" do
    assert 1 == 1
  end

  test "Export Guide" do
    assert UberGen.Executor.Export.guide(UberGen.Playbooks.Util.Null)
  end
end
