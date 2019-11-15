# UberGen DEVLOG

## 2019 Oct 28 Mon

- [x] Make a working mixtask
- [x] Install global mix tasks
- [x] Register Playbooks - HowTo?
- [x] Create ugen.playbook task (list/run)
- [x] Load playbooks
- [x] Display playbooks (mix help)
- [x] Create a Gen.Phx playbook
- [x] Remove debug messages
- [x] Run an internal playbook 

## 2019 Nov 01 Fri

- [x] Study Elixir Formatter
- [x] Study Elixir Language Server
- [x] Code Formatting/Editing Elixir
- [x] Code Formatting/Editing JSON
- [x] Code Formatting/Editing JavaScript
- [x] Prettier Formatter

## 2019 Nov 02 Sat

- [x] Create playbook macros (run, help, call, doc, test)
- [x] Add playbook behavior (run, help, children, call, doc, test)
- [x] Build demo pipeline for LiveView

## 2019 Nov 03 Sun

- [x] Drop the `children` function
- [x] Add four playbook macros (`run`, `call`, `doc`, `test`)

## 2019 Nov 04 Mon

- [x] Add a `steps` macro - acts like `children`
- [x] Add `call`, `guide` and `test` macros
- [x] Generate sample markdown for LiveView

## 2019 Nov 05 Tue

- [x] Make run/steps/call/guide/test macros optional

## 2019 Nov 07 Thu

- [x] Generate ExDoc documentation (esp for `Playbook`)
- [x] Update README
- [x] Add mix commands (run, export, serve)

## 2019 Nov 08 Fri 

- [x] Add `UberGen.Ctx`
- [x] Add `Util.Command` playbook
- [x] Add assign and halt functions to `UberGen.Ctx`
- [x] Add `Util.Command` playbook
- [x] Add `Util.BlockInFile` playbook
- [x] LiveView: working `mix ugen.pb.export` command

## 2019 Nov 10 Sun 

- [x] Add `params` and `changeset` macros to `Playbook`
- [x] Create `Playbooks.Test.MultiText` playbook 

## 2019 Nov 11 Mon

- [x] Questions: How to configure nested playbooks?
- [x] Questions: How to expose the properties of a playbook?
- [x] Questions: Do we need a construct like `ecto_changeset`?
- [x] Questions: How to script a playbook?
- [x] Remove `run` macro from Playbook
- [x] Rename `call` macro to `run`

## 2019 Nov 12 Tue

- [x] Rename 'run' to 'work'
- [x] Rename 'changeset' to 'verify'
- [x] Add param validation to `_guide` function.
- [x] Design scripting layer
- [x] How to save a script as a playbook?
- [x] How to dynamically configure a tree of playbooks?

## 2019 Nov 13 Wed

- [x] Add children as third (optional) tuple setting
- [x] Demo recursive step definition
- [x] Write YAML interpreter
- [x] Demo YAML interprerter with nested configuration
- [x] $ ubergen myfile.yaml export  
- [x] $ ubergen myfile.yaml run     
- [x] Move to dev-branch system

## 2019 Nov 14 Thu

- [x] Tag and Consolidate Branches
- [x] Don't show playbook in `ugen.cache.list` unless `has_work?` or `--all`
- [x] Add ability to use YAML or JSON in playbook steps
- [x] Create LiveView generator
- [x] Design UberGen runner
- [x] Rename 'Playbook.work' to 'Playbook.cmd'
- [x] Create `Exec.Export.guide/1`
- [x] Create `Exec.Run.cmd/1`

## 2019 Nov 15 Fri

- [x] Create run function
- [ ] Convert macros to callbacks
- [ ] Implement run mix task
- [ ] Implement run escript

## TBD

- [ ] Convert bash generators to UberGen

- [ ] Get `mix ugen.base.help` working
- [ ] Document playbooks

## Questions

- [ ] How to manage long-running state?  (like tasks)
- [ ] Is there a datastore for UberGen?
- [ ] How to access-control for shared playbooks?
- [ ] Use-cases for playbooks with multi-parents? (listeners, chat, comments)
- [ ] What is a a URI-scheme for Playbooks?
- [ ] Can we get CRDTs working for offline access?
- [ ] How to generate event-streams?  
- [ ] Are playbooks wrappered in a manipulation API?

- [ ] Do we need to define playbook variables and default values?

- [ ] How does PragDave install templates?
- [ ] How does PragDave store templates?

## Futures

- [ ] WebUI: Design WebUI

- [ ] Registry: Create Registry
- [ ] Registry: External Playbooks - path / github deps
- [ ] Registry: Registry upload/download/search

- [ ] Website: A HowTo Blog
- [ ] Website: Learning Paths
- [ ] Website: Time to Learn
- [ ] Website: Credentialing
- [ ] Website: Metrics: Frequency/RunTime per Playbook 

- [ ] Community: who else is doing this now?
- [ ] Community: who has the most experience?
- [ ] Community: who is willing to mentor?
