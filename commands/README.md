# Commands Index

Purpose: standardize how typical engineering tasks are executed before implementation.

## Available command playbooks
- `commands/refactor.md` - safe refactoring workflow with rollback-ready checkpoints
- `commands/write-tests.md` - test authoring workflow for domain and app logic
- `commands/add-feature.md` - feature delivery workflow from spec to implementation
- `commands/debug.md` - bug/debug workflow from reproduction to fix verification
- `commands/perf-a11y.md` - performance and accessibility pass workflow

## Usage rule for agents
Before starting a typical task category, the agent must read and follow the corresponding command file.
If multiple categories apply, run them in this order:
1. `commands/add-feature.md` or `commands/debug.md`
2. `commands/refactor.md`
3. `commands/write-tests.md`
4. `commands/perf-a11y.md`

TODO: revise order if team workflow changes after project scaffolding.
