defmodule Atree.Presentor.ActionTreeTest do
  use ExUnit.Case

  test "Hello World" do
    assert 1 == 1
  end

  test "Run Command" do
    assert Atree.Executor.Run.with_action(Atree.Actions.Util.Null)
           |> Atree.Presentor.ActionTree.generate()
  end
end
