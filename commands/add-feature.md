# Command: Add Feature

## Goal
Deliver a feature from clear requirements to verifiable implementation.

## Inputs
- Feature request or task
- Relevant spec in `docs/specs/*` (or draft one)
- Architectural constraints from `AGENTS.md`

## Steps
1. Confirm or create feature spec (Context, Stories, AC, edge cases, tests).
2. Define minimal vertical slice and explicit out-of-scope.
3. Implement domain-first for rule-heavy logic.
4. Integrate ViewModel and UI on top of validated domain behavior.
5. Add/update tests (domain required for rule changes).
6. Update docs and PR notes with decisions and TODOs.

## Output
- Implemented feature aligned to acceptance criteria
- Tests and docs updated with traceable assumptions

## File updates
- Implementation files in feature scope
- `Tests/*`
- `docs/specs/<feature>.md`
- `docs/overview.md` only if project-level scope/terms changed
