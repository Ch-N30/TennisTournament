---
name: migration-helper
description: Use for future data/schema migration planning and execution once persistence technology is selected.
---

# Migration Helper Skill (Future)

## Purpose
Support safe, incremental data or schema migrations after persistence architecture is finalized.

## Inputs
- Current schema/model version
- Target schema/model version
- Backward-compatibility requirements
- Rollout and rollback constraints

## Steps
1. Define source and target schema contracts.
2. Classify migration type: additive, transformational, or breaking.
3. Draft migration strategy with rollback plan.
4. Add validation and integrity checks.
5. Implement migration code and verification tests.
6. Document operational runbook and risks.

## Output format
1. Migration context
2. Strategy and phases
3. Validation plan
4. Rollback plan
5. Risks and mitigations
6. Implementation checklist

## File update locations
- `docs/specs/*` for migration spec and rollout notes
- `Tests/*` for migration integrity/regression checks
- Future persistence modules once selected

TODO: finalize concrete file paths and tooling after choosing SwiftData/CoreData migration approach.
