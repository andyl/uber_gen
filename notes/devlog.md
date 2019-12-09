# Atree DEVLOG

## 2019 Oct 28 Mon

- [x] Make a working mixtask
- [x] Install global mix tasks
- [x] Register Actions - HowTo?
- [x] Create atree.playbook task (list/run)
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

- [x] Generate ExDoc documentation (esp for `Action`)
- [x] Update README
- [x] Add mix commands (run, export, serve)

## 2019 Nov 08 Fri 

- [x] Add `Atree.Ctx`
- [x] Add `Util.Command` playbook
- [x] Add assign and halt functions to `Atree.Ctx`
- [x] Add `Util.Command` playbook
- [x] Add `Util.BlockInFile` playbook
- [x] LiveView: working `mix atree.pb.export` command

## 2019 Nov 10 Sun 

- [x] Add `params` and `changeset` macros to `Action`
- [x] Create `Actions.Test.MultiText` playbook 

## 2019 Nov 11 Mon

- [x] Questions: How to configure nested playbooks?
- [x] Questions: How to expose the properties of a playbook?
- [x] Questions: Do we need a construct like `ecto_changeset`?
- [x] Questions: How to script a playbook?
- [x] Remove `run` macro from Action
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
- [x] Don't show playbook in `atree.cache.list` unless `has_work?` or `--all`
- [x] Add ability to use YAML or JSON in playbook steps
- [x] Create LiveView generator
- [x] Design Atree runner
- [x] Rename 'Action.work' to 'Action.command'
- [x] Create `Executor.Export.guide/1`
- [x] Create `Executor.Run.command/1`

## 2019 Nov 15 Fri

- [x] Create run function
- [x] Start to convert macros to callbacks
- [x] Implement run mix task
- [x] Implement run escript
- [x] Get rid of warnings
- [x] Add tests
- [x] Start convert macros to callbacks

## 2019 Nov 17 Sun

- [x] Do we need to define playbook variables and default values? (yes)
- [x] Design a variable declaration callback (interface)
- [x] Figure out how to handle dynamic variables in params block
- [x] Change "Exec" to "Executor"
- [x] Get `mix atree.help` working
- [x] Migrate from macros to callbacks
- [x] Cleanup code

## 2019 Nov 18 Mon

- [x] working `interface` options (params / assigns)
- [x] working `inspect` options (params / assigns)
- [x] rename playbook to action
- [x] rename priv/scripts to playbooks

## 2019 Nov 19 Tue

- [x] Executor.Export writes to context
- [x] Executor.Run writes to context
- [x] Typespecs for Action callbacks
- [x] Run LiveView exporter
- [x] Write markdown presentor
- [x] Finish LiveView Action
- [x] Add option parser for mix tasks
- [x] Mix tasks: atree -> atree - with alias
- [x] Presentor: guide_html
- [x] Presentor: ctx_inspect
- [x] Presentor: log_inspect
- [x] Presentor: action_tree

## 2019 Nov 21 Thu

- [x] Refactor executors
- [x] Export and Run calls Base.inspect

## 2019 Nov 22 Fri

- [x] Add TAILOR executor
- [x] LvRun: ENV.ASSIGN / Create Action 

## 2019 Nov 23 Sat

- [x] Refactor UberGen -> Atree

## 2019 Nov 24 Sun

- [x] Add log struct
- [x] Executors should take context input, or generate default context
- [x] Executors should append logs to existing logs
- [x] Presentors should handle a list of logs
- [x] Add tests for log-list

## 2019 Nov 25 Mon

- [x] Create `atree` escript (with Bash pipelining)

## 2019 Nov 26 Tue

- [x] atree: fix context pipelining
- [x] atree: setup output presentors
- [x] atree: file_save presentors
- [x] atree: read context from file
- [x] atree: add LIST placeholder
- [x] atree: add HELP placeholder

## 2019 Nov 27 Wed

- [x] atree: list playbooks
- [x] atree: list actions
- [x] atree: help

## 2019 Nov 28 Thu

- [x] atree: specify action or playbook
- [x] atree: handle params
- [x] atree: help on playbooks
- [x] atree: help on actions
- [x] atree: playbooks in ~/.atree/playbooks
- [x] Playbook Lookup Function
- [x] Action Lookup Function
- [x] file path
- [x] Doc: Mix.Task.moduledoc(module)
- [x] Interface: inspect(module.interface)
- [x] Module: module 
- [x] Action Name: Mix.Task.task_name(module)
- [x] Implement interface
- [x] Implement inspect

## 2019 Nov 29 Fri

- [x] Implement `__struct__` and `__changesets__` in `Action.__using__`
- [x] LvRun: UTIL.TextBlock / Implement Inspect

## 2019 Nov 30 Sat

- [x] Add ExUnit tests for UTIL.TextBlock
- [x] LvRun: UTIL.COMMAND / Implement Command
- [x] LvRun: UTIL.COMMAND / Implement Test
- [x] Simplify Propspecs - use Keyword List
- [x] LvRun: UTIL.BlockInFile / Implement Test
- [x] Playbooks: change 'params' to 'props'

## 2019 Dec 01 Sun

- [x] Handle array of props (BlockInFile - with tests)
- [x] Design for "when" and "unless" constructs 
- [x] AUTH: add ExecPlan (action, props, auth, children)
- [x] AUTH: add ExecPlan (when, unless)

## 2019 Dec 02 Mon

- [x] AUTH: update in ToChildren

## 2019 Dec 03 Tue

- [x] AUTH: update in ExecTree
- [x] AUTH: update Run executor
- [x] AUTH: update Export executor
- [x] AUTH: update Tailor executor
- [x] AUTH: function that returns T/F (with message?) 
- [x] AUTH: add 'when' handler
- [x] AUTH: add 'unless' handler
- [x] AUTH: update documentation
- [x] Design: Playbooks as Children
- [x] Implement StockAction
- [x] Implement StockPlaybook

## 2019 Dec 04 Wed

- [x] Implement Playbooks as Children

## 2019 Dec 05 Thu

- [x] CleanUp Indentation
- [x] markdown output wrap text
- [x] markdown output preserve paragraphs & newlines
- [x] JSON output order items put children last

## 2019 Dec 06 Fri

- [x] Remove all Mix dependencies (list)
- [x] Run as Escript
- [x] Parent project actions
- [x] Add Action paths to config
- [x] Add Playbook paths to config

## 2019 Dec 07 Sat

- [x] Check stdin operation
- [x] Test env stdin
- [x] Scripts: env/all, env/host |> env/lang
- [x] Get children working
- [x] Not listing all children

## TBD

- [ ] TAILOR/LV: quit unless proper elixir env
- [ ] TAILOR/LV: quit unless in-project
- [ ] TAILOR/LV: set ElixirEnv(version), AppEnv(name, in-umbrella)
- [ ] TAILOR/LV: create Checklist/TOC w/tests

- [ ] RUN executor
- [ ] REPL executor

- [ ] children handle a single child
- [ ] Document YAML Multiline https://yaml-multiline.info/
- [ ] Sometimes not picking up elements on the action_path

- [ ] Write tests
- [ ] Documentation (Actions, Playbook comments, Action callbacks)

- [ ] Run stops on halt

- [ ] Convert bash generators to Atree

