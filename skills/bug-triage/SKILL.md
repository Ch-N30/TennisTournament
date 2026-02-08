---
name: bug-triage
description: Use when investigating and stabilizing reported defects with a reproducible and test-driven triage flow.
---

# Bug Triage Skill

## Purpose
Drive bug handling from reproduction to verified fix with minimal regression risk.

## Procedure
1. Reproduce steps
2. Expected vs actual behavior
3. Scope assessment (where it breaks and where it does not)
4. Suspected cause
5. Minimal fix proposal
6. Tests to add/update
7. Regression risks

## Execution rules
- Prefer smallest fix that resolves root cause.
- Add or update tests for every confirmed bug in domain logic.
- Record any unresolved uncertainty as TODO in docs/specs when rules are unclear.

## Deliverable template
- Repro steps:
- Expected:
- Actual:
- Scope:
- Suspected cause:
- Minimal fix:
- Tests:
- Regression risks:
