defmodule UberGen.Executor.RunTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "Hello World" do
    assert 1 == 1
  end

  test "Run Command" do
    assert capture_io(fn -> UberGen.Executor.Run.with(UberGen.Actions.Util.Null) end) != nil
  end
end
