---
name: test-author
description: Use when creating or improving tests for domain rules, view-model logic, and regressions in this repository.
---

# Test Author Skill

## Purpose
Produce reliable tests that validate domain rules and prevent regressions.

## Inputs
- Feature/bug context
- Public API or behavior under test
- Critical edge cases and expected outcomes

## Steps
1. Extract test scenarios from acceptance criteria and bug history.
2. Prioritize Domain unit tests for rules/scoring/tie-break logic.
3. Add integration tests for cross-layer behavior when needed.
4. Ensure deterministic setup and explicit assertions.
5. Verify failure-before-fix for bug regressions where feasible.
6. Summarize coverage and known test gaps.

## Output format
1. Scenario matrix
2. Tests added/updated
3. Coverage intent
4. Deferred cases (TODO)

## File update locations
- `Tests/*` (primary)
- `docs/specs/*` for any ambiguous rule uncovered during test design
