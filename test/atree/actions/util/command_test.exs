defmodule Atree.Actions.Util.CommandTest do
  use ExUnit.Case

  alias Atree.Actions.Util.Command

  describe "Export" do
    test "Export Guide" do
      assert Atree.Executor.Export.with_action({Command, %{header: "asdf", body: "qwer"}})
    end

    test "Bad Props" do
      ctx = Atree.Executor.Export.with_action({Command, %{header: "asdf", body: "qwer"}})
      log = List.first(ctx.log)
      refute log.report.valid?
    end

    test "No Props" do
      ctx = Atree.Executor.Export.with_action({Command, %{}})
      log = List.first(ctx.log)
      refute log.report.valid?
    end

    test "Good Props" do
      ctx =
        Atree.Executor.Export.with_action(
          {Command, %{instruction: "run whoami", command: "whoami"}}
        )

      log = List.first(ctx.log)
      assert log.report.valid?
    end
  end

  describe "Run" do
    @tstdir "/tmp/testdir"

    setup do
      if File.exists?(@tstdir), do: File.rmdir(@tstdir)
      :ok
    end

    test "Good Props" do
      ctx = Atree.Executor.Run.with_action({Command, %{command: "mkdir -p #{@tstdir}", creates: @tstdir}})
      log = List.first(ctx.log)
      assert ctx.halted
      assert log.test == {:error, ["Invalid props"]}
    end

    test "Bad Props" do
      ctx = Atree.Executor.Run.with_action({Command, %{command: "_bad_command_", creates: @tstdir}})
      log = List.first(ctx.log)
      assert ctx.halted
      refute log.test == :ok
    end
  end
end
