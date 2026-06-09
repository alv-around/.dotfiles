---
description: Review the current uncommitted diff for bugs and TS issues
---

Review the working-tree changes in this repo.

1. Run `git diff` (and `git diff --staged`) to see all pending changes.
2. Review for: type-safety holes (`any`, unchecked `req.body`), missing input
   validation or error `return`s in Express handlers, `Task`-interface drift
   between frontend and backend, unhandled fetch failures, and React state bugs.
3. Run `npm run -w backend build` and `npm run -w frontend build` to confirm both
   typecheck.
4. Report findings as a short list ordered by severity. For each: file:line, the
   problem, and the concrete fix. Don't rewrite code unless asked — just review.
