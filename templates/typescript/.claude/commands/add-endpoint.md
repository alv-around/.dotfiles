---
description: Scaffold a REST endpoint in the backend and wire it into the frontend
argument-hint: <method> <path> — e.g. "PUT /api/tasks/:id/title"
---

Add a new REST endpoint end-to-end: **$ARGUMENTS**

1. In `backend/src/index.ts`, add the route next to the existing `/api/...`
   handlers. Validate every input and `return` after any error response, exactly
   like `POST /api/tasks` does. Use proper status codes (400/404/201/204).
2. If it changes the `Task` shape, update the `Task` interface in **both**
   `backend/src/index.ts` and `frontend/src/App.tsx`.
3. Wire the matching `fetch` call into `frontend/src/App.tsx` and update React
   state on success, mirroring the existing handlers.
4. Typecheck both: `npm run -w backend build` and `npm run -w frontend build`.
5. Smoke-test with `curl` against `localhost:3000` and report the actual output.

Keep edits minimal and match the surrounding style.
