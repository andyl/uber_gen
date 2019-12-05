defmodule Atree.Actions.Util.BlockInFileTest do
  use ExUnit.Case

  alias Atree.Actions.Util.BlockInFile

  test "Hello" do
    assert true
  end

  describe "Export" do
    test "Export Guide" do
      assert Atree.Executor.Export.with_input({BlockInFile, %{text_block: "asdf", target_file: "qwer"}})
    end

    test "Bad Props" do
      ctx = Atree.Executor.Export.with_input({BlockInFile, %{header: "asdf", body: "qwer"}})
      log = List.first(ctx.log)
      refute log.report.valid?
      refute ctx.halted
    end

    test "No Props" do
      ctx = Atree.Executor.Export.with_input({BlockInFile, %{}})
      log = List.first(ctx.log)
      refute log.report.valid?
    end

    test "Good Props" do
      ctx =
        Atree.Executor.Export.with_input(
          {BlockInFile, %{text_block: "run whoami", target_file: "whoami"}}
        )

      log = List.first(ctx.log)
      assert log.report.valid?
    end
  end

  describe "Run" do
    @tgtfile "/tmp/testfile.txt"

    setup do
      if File.exists?(@tgtfile), do: File.rmdir(@tgtfile)
      :ok
    end

    test "Bad Props" do
      ctx = Atree.Executor.Run.with_input({BlockInFile, %{command: "mkdir -p #{@tgtfile}"}})
      log = List.first(ctx.log)
      assert ctx.halted
      assert log.test == {:error, ["Invalid props"]}
    end

    test "Good Props, No File" do
      ctx = Atree.Executor.Run.with_input({BlockInFile, %{text_block: "block", target_file: @tgtfile}})
      log = List.first(ctx.log)
      assert ctx.halted
      refute log.test == :ok
      assert List.first(elem(log.test, 1)) =~ "File does not exist"
    end
  end
end
