# CLI Runner Design Notes

## CLI Options

Command Line:

    $ mix ugen.pb.run <playbook> [opts]

Default behavior - similar to `ansible-playbook`:

- runs commands and tests until fail
- does not re-run commands where there was success (idempotent)
- shows fail information (command to run, file to edit, etc.)

Options:

- repl - run in repl mode
- watch - watch for file changes
- force - force-run commands
- editor <type> - specify editor (nvim, vim, etc.)

## REPL Mode

Basics:

- command-line prompt 

REPL Commands:
- open file
- rerun

## Editor Integration

- use neovim and mhinz/neovim-remote
- editor and repl-runner side by side

## Exex.Run.cmd Sequence

    def Exec.Run.cmd(module)

    def Exec.Run.cmd(ctx, {module, opts, children}) do
      if module.test(ctx, opts) do
        IO.puts("PASS")
      else
        module.cmd(ctx, opts)
      end

      if test(ctx, opts) do
        children
        |> Enum.map(&cmd(ctx, &1))
      else
        IO.puts("FAIL")
        module.guide(ctx, opts) |> IO.puts()
        halt(ctx)
      end 
    end

