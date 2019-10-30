defmodule UberGenTest do
  use ExUnit.Case
  doctest UberGen

  test "greets the world" do
    assert UberGen.hello() == :world
  end
end
