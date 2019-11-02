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

mix ugen.help

mix ugen.playbook list                     # list all local playbooks
mix ugen.playbook install <playbook>       # install a playbook
mix ugen.playbook remove                   # remove a playbook 

mix ugen.registry list                     # list playbooks in registry
mix ugen.registry publish <playbook>       # push a local playbook to registry
mix ugen.registry remove                   # remove a playbook from the registry

mix ugen.run <playbook> <opts>             # run playbook
mix ugen.build <playbook> [--format md]    # build docs
mix ugen.serve <playbook>                  # serve docs

Run behavior - run until:
- failed test (code red)
- wait for manual input (code yellow)

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

