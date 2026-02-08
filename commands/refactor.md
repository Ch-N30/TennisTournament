# Command: Refactor

## Goal
Improve structure/readability without changing behavior.

## Inputs
- Target scope (files/modules)
- Existing behavior contract (tests/spec/docs)
- Known constraints from `AGENTS.md`

## Steps
1. Define refactor boundary and non-goals.
2. Confirm existing behavior via tests/docs; add missing baseline test if needed.
3. Apply smallest structural changes first (rename/extract/simplify).
4. Re-run relevant checks after each chunk.
5. Verify no behavior drift and no unrelated file edits.
6. Document rationale in PR summary.

## Output
- Minimal diff with unchanged behavior
- Updated tests only when needed to preserve/clarify behavior
- Short risk note: what could still break

## File updates
- Code files in task scope
- `Tests/*` for baseline/regression coverage if required
- `docs/specs/*` only if behavior assumptions were clarified
