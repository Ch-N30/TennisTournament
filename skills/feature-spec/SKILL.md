---
name: feature-spec
description: Use when drafting or updating a feature specification for this project, from context to acceptance criteria, test plan, and docs/specs output.
---

# Feature Spec Skill

## Purpose
Create a structured feature specification that product and engineering can implement without hidden assumptions.

## Output format
Always produce spec sections in this exact order:
1. Context
2. User stories
3. Acceptance criteria
4. Edge cases
5. Data model impact
6. UI screens
7. Test plan

## Workflow
1. Clarify scope from issue/PRD/conversation.
2. Capture assumptions explicitly; avoid inventing tournament rule details.
3. Define user stories with clear actor + goal + outcome.
4. Write testable acceptance criteria.
5. Enumerate edge cases including tie-break and bracket corner cases.
6. Describe data model impact with new/changed entities and fields.
7. Map UI screens and transitions.
8. Create a practical test plan (unit/integration/UI where relevant).

## Repository action
At the end, create or update:
`docs/specs/<feature>.md`

Naming guidance:
- Use kebab-case feature names.
- Example: `docs/specs/create-tournament.md`.

## Quality bar
- Specs must be implementation-ready for one sprint.
- Unknowns are listed as `TODO` with owner/question.
- Keep language precise and measurable.
