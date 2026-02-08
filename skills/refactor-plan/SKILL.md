---
name: refactor-plan
description: Use when planning or executing non-functional refactors with strict behavior preservation and minimal diffs.
---

# Refactor Plan Skill

## Purpose
Plan and execute refactors that improve maintainability without changing externally visible behavior.

## Inputs
- Refactor target and motivation
- Current behavior constraints (tests/specs)
- Affected modules/files

## Steps
1. Define behavior contract and explicit non-goals.
2. Split refactor into small, reversible steps.
3. Identify required safety checks (tests/static checks/manual verifications).
4. Execute steps in order with frequent validation.
5. Report behavior equivalence and residual risks.

## Output format
1. Scope and non-goals
2. Refactor steps
3. Safety checks
4. Risks and mitigations
5. Final change summary

## File update locations
- Code files inside requested scope
- `Tests/*` only when needed to lock behavior or add regression safety
- `docs/specs/*` when assumptions or boundaries were clarified
