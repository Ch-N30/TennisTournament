# Agent Rules for TennisTournament

## Goal
Build a maintainable iOS codebase for tournament management, with deterministic tennis rules behavior and clear docs.

## Command-first workflow
Before executing a typical task, the agent must read and follow the relevant command playbook from `commands/`.

Mapping:
- Feature work -> `commands/add-feature.md`
- Bug investigation/fix -> `commands/debug.md`
- Refactoring -> `commands/refactor.md`
- Test authoring -> `commands/write-tests.md`
- Performance/accessibility pass -> `commands/perf-a11y.md`

If a task spans multiple categories, apply the primary command first and then run supporting command workflows.

## Architecture baseline
Use this flow:
`UI (SwiftUI) <-> ViewModel <-> Domain (rules/engine) <-> Persistence (later)`

Rules:
- Domain must be pure Swift and independent from UIKit/SwiftUI.
- ViewModels orchestrate UI state and domain calls.
- Persistence integration is deferred; isolate via protocol boundaries.

## Testability and quality
- Any critical scoring, ranking, and tie-break logic must have unit tests.
- Prefer deterministic, side-effect-light domain APIs.
- Add regression tests for every bug in domain rules.

## Diff discipline
- Do not modify unrelated files.
- Keep diffs minimal and focused on the task.
- Do not rewrite large files if targeted edits are enough.

## Uncertainty handling
- If tournament format details are ambiguous, do not invent behavior.
- Add TODO items in `docs/specs/*.md` and reference assumptions explicitly.

## Documentation policy
- Document architecture and product decisions in `docs/`.
- When adding or changing domain rules, update docs in the same PR.
- Keep `docs/overview.md` current with MVP boundaries.
