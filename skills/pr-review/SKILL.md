---
name: pr-review
description: Use when reviewing pull requests for tennis tournament logic, UX quality, reliability, and release risk.
---

# PR Review Skill

## Purpose
Perform consistent, risk-focused PR reviews for this repository.

## Review checklist
- Correctness of tennis/tournament rules
- Edge cases and failure handling
- UX clarity and state transitions
- Accessibility basics (labels, dynamic type, contrast intent)
- Performance risks (unnecessary recomputation/rendering)
- Test coverage for changed behavior
- Security and data handling concerns

## Output format
Return review notes in this order:
1. Findings (must fix)
2. Suggestions
3. Nits

## Review behavior
- Prioritize behavior regressions over style.
- Reference files and line numbers when possible.
- If domain rules changed without tests, report as must-fix.
- If requirements are ambiguous, call out explicitly and request spec update.
