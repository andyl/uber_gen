defmodule Atree.Data.PlanTest do
  use ExUnit.Case

  alias Atree.Data.Plan

  describe "Action Input" do
    test "simple" do 
      assert Plan.expand(Atree.Actions.Util.Null)
    end

    test "nested" do 
      assert Plan.expand(Atree.Actions.Phx.LiveView)
    end
  end

  describe "Playbook Input" do
    test "simple" do
      assert Plan.expand("test1.yaml")
    end

    test "nested" do
      assert Plan.expand("live_view.yaml")
    end

    test "mixed" do
      assert Plan.expand("mixed1.yaml") |> IO.inspect()
    end
  end
end
