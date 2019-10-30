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

## CLI

mix ugen.help

mix ugen.playbook list
mix ugen.playbook install <playbook>
mix ugen.playbook remove 

mix ugen.registry list
mix ugen.registry publish <playbook>
mix ugen.registry remove

mix ugen.run <playbook> <opts>

mix ugen.doc <playbook>

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

