# Contributing

## Branching
- `feature/*` for new functionality
- `fix/*` for bug fixes
- Keep branch scope focused and small

## Pull requests
Each PR must include:
- Clear summary of what changed and why
- Linked issue/task (if available)
- Screenshots or screen recording for UI changes
- Tests for business logic changes (or explanation if not applicable)

## Code review
- At least one reviewer approval from the team
- Address all must-fix comments before merge
- Keep discussions in PR for traceability

## Definition of done
- Scope implemented according to accepted requirements
- Domain rules covered by unit tests when behavior changes
- No obvious regressions in UX, accessibility, or core flows
- Documentation updated when behavior or rules changed

## Commit style
Use Conventional Commits:
- `feat: ...`
- `fix: ...`
- `refactor: ...`
- `test: ...`
- `docs: ...`
- `chore: ...`

Examples:
- `feat: add tournament participant seeding model`
- `fix: correct tie-break score validation`
