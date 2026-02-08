# Command: Performance and Accessibility

## Goal
Raise baseline UX quality for responsiveness and accessibility.

## Inputs
- Target screen/flow
- Current UX behavior and bottlenecks
- A11y and performance constraints

## Steps
1. Identify hot paths (re-render loops, expensive computations, blocking calls).
2. Apply minimal performance improvements with measurable impact.
3. Verify accessibility basics: labels, traits, focus order, dynamic type readiness.
4. Check interaction clarity and error states.
5. Record trade-offs and remaining debt as TODO.

## Output
- Focused improvement list with implemented changes
- Validation notes for perf and accessibility checks

## File updates
- UI/ViewModel files in scope
- `docs/specs/*` or feature notes for deferred improvements (TODO)
