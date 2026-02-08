# Command: Write Tests

## Goal
Add deterministic, maintainable tests for behavior-critical logic.

## Inputs
- Behavior definition (issue/spec/doc)
- Target module/API
- Edge cases and previous bugs

## Steps
1. Identify behavior invariants and failure conditions.
2. Prefer unit tests for Domain; add integration/UI tests only when necessary.
3. Use Arrange-Act-Assert structure and explicit naming.
4. Add edge cases (tie-break, ranking ties, invalid scores, state transitions).
5. Ensure tests fail before fix (when writing bug regression tests).
6. Keep tests isolated, deterministic, and fast.

## Output
- New or updated test suite with clear scenario coverage
- Gap list for any intentionally deferred cases

## File updates
- `Tests/*` (primary)
- `docs/specs/*` when uncovered ambiguity is found (add TODO)
