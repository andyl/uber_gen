defmodule Atree.Presentor.LogInspectTest do
  use ExUnit.Case

  test "Hello World" do
    assert 1 == 1
  end

  test "Run Command" do
    assert Atree.Executor.Run.with_input(Atree.Actions.Util.Null)
           |> Atree.Presentor.LogInspect.generate()
  end
end
