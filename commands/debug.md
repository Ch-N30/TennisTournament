# Command: Debug

## Goal
Resolve a bug with reproducible evidence and low regression risk.

## Inputs
- Bug report (steps, environment, expected/actual)
- Logs/traces/screenshots if available
- Existing related tests/specs

## Steps
1. Reproduce the issue consistently.
2. Capture expected vs actual behavior.
3. Narrow scope and isolate failing path.
4. Identify root cause hypothesis and validate it.
5. Implement minimal root-cause fix.
6. Add regression tests and run impacted checks.
7. Document regression risks and follow-ups.

## Output
- Verified fix with reproducible before/after evidence
- Regression test coverage

## File updates
- Bugfix code files
- `Tests/*` (regression tests required for domain bugs)
- `docs/specs/*` for unresolved rule ambiguity (TODO)
