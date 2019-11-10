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

## TBD

- [ ] Add param validation to `_guide` function.
- [ ] Remove `run` macro from Playbook
- [ ] Rename `call` macro to `run`

- [ ] LiveView: working `mix ugen.pg.run` command (run validation tests)

- [ ] Get `Playbooks.Util.Command` working (execute run task)

- [ ] Design `Compser` UI
- [ ] Design `Director` UI

- [ ] Get `mix ugen.base.help` working
- [ ] Don't show playbook in `ugen.cache.list` unless `has_run?` or `--all`
- [ ] Document playbooks

- [ ] Create an exec playbook (`util.exec`)

## Questions

- [ ] How to configure nested playbooks?
- [ ] How to expose the properties of a playbook?
- [ ] Do we need a construct like `ecto_changeset`?
- [ ] How to script a playbook?
- [ ] Can someone save a script as a playbook?
- [ ] How does PragDave install templates?
- [ ] How does PragDave store templates?

## Playbook Registry

- [ ] External Playbooks - path / github deps

- [ ] Create Registry
- [ ] Registry upload/download/search

## Website 

- [ ] A HowTo Blog
- [ ] Learning Paths
- [ ] Time to Learn
- [ ] Credentialing
- [ ] Metrics: Frequency/RunTime per Playbook 
- [ ] Community: who else is doing this now?
- [ ] Community: who has the most experience?
- [ ] Community: who is willing to mentor?
