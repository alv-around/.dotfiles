---
description: Typecheck, build, and commit the current changes
argument-hint: optional commit message
---

Get the current changes ready to commit.

1. `npm run -w backend build` and `npm run -w frontend build` — both must pass.
   If either fails, stop and fix the errors before continuing.
2. `git status` and `git diff` to see what changed.
3. Stage the relevant files and write a concise commit message (use "$ARGUMENTS"
   if provided, otherwise summarize the diff). Do **not** `git push`.
4. Report what was committed.
