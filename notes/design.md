# DESIGN

## Notes

- a playbook is a module with `use UberGen.Playbook`
- a playbook registers itself, borrowing techniques from `Mix.Task`

## Directory Structure

    lib/
      mix/
        tasks/
          task1.ex
          task2.ex
      uber_gen/
        playbooks/
          playbook1.ex
          playbook2.ex
    priv/
      uber_gen/
        playbooks/
          playbook1/
            templates/
            files/
            docs/

## MIX CLI

mix ugen.base
mix ugen.base.help

mix ugen.cache.list                     # list all cached playbooks
mix ugen.cache.install <playbook>       # install a playbook to cache
mix ugen.cache.remove                   # remove a playbook from cache

mix ugen.registry.list                  # list playbooks in registry
mix ugen.registry.publish <playbook>    # push a local playbook to registry
mix ugen.registry.remove                # remove a playbook from registry

mix ugen.pb.run <playbook> <opts>           # run playbook on the command line
mix ugen.pb.export <playbook> [--format md] # build playbook doc
mix ugen.pb.serve <playbook>                # serve playbook doc

Run behavior - run until:
- failed test (code red)
- wait for manual input (code yellow)

## Guide Return Values

- nil
- "body"
- {"header", "body"}
- %{header: "header"}
- %{body: "body"}
- %{header: "header", body: "body"}

## .uber_gen.exs

    playbooks = [
      
    ]

## Systems

- Registry
- Blog with HowTos

## Refactoring

Language Introspection / AST:

- code formatting
- language server

Uses:

- in playbooks and generator scripts
- in editor refactorings

Refactorings:

Rename Project
- Change project name
- Change project atoms
- Rename project files

Add Dependency

