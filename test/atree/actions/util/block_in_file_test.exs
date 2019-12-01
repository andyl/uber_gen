defmodule Atree.Actions.Util.BlockInFileTest do
  use ExUnit.Case

  alias Atree.Actions.Util.BlockInFile

  test "Hello" do
    assert true
  end

  describe "Export" do
    test "Export Guide" do
      assert Atree.Executor.Export.with_action({BlockInFile, %{text_block: "asdf", target_file: "qwer"}})
    end

    test "Bad Props" do
      ctx = Atree.Executor.Export.with_action({BlockInFile, %{header: "asdf", body: "qwer"}})
      log = List.first(ctx.log)
      refute log.report.valid?
    end

    test "No Props" do
      ctx = Atree.Executor.Export.with_action({BlockInFile, %{}})
      log = List.first(ctx.log)
      refute log.report.valid?
    end

    test "Good Props" do
      ctx =
        Atree.Executor.Export.with_action(
          {BlockInFile, %{text_block: "run whoami", target_file: "whoami"}}
        )

      log = List.first(ctx.log)
      assert log.report.valid?
    end
  end

  # describe "Run" do
  #   @tstdir "/tmp/testdir"
  #
  #   setup do
  #     if File.exists?(@tstdir), do: File.rmdir(@tstdir)
  #     :ok
  #   end
  #
  #   test "Good Props" do
  #     ctx = Atree.Executor.Run.with_action({BlockInFile, %{command: "mkdir -p #{@tstdir}", creates: @tstdir}})
  #     log = List.first(ctx.log)
  #     refute ctx.halted
  #     assert log.test == :ok
  #   end
  #
  #   test "Bad Props" do
  #     ctx = Atree.Executor.Run.with_action({BlockInFile, %{command: "_bad_command_", creates: @tstdir}})
  #     log = List.first(ctx.log)
  #     assert ctx.halted
  #     refute log.test == :ok
  #   end
  # end
end
