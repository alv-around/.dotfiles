# Project guide for AI agents

TypeScript full-stack monorepo: **React (Vite) frontend + Express backend**, npm
workspaces, Nix dev shell. Read this before making changes.

## Stack & layout

| Area     | Tech                          | Path        |
| -------- | ----------------------------- | ----------- |
| Frontend | React 18 + Vite, TypeScript   | `frontend/` |
| Backend  | Express 4 + tsx, TypeScript   | `backend/`  |
| Tooling  | npm workspaces, Nix flake     | root        |

- `backend/src/index.ts` — Express server + REST routes. State is **in-memory**
  (a `tasks` array); there is no database. Restarting resets data.
- `frontend/src/App.tsx` — the whole UI: fetches `/api/health` and CRUDs
  `/api/tasks`.
- Vite proxies `/api/*` to the backend, so the frontend calls relative URLs
  (`fetch('/api/tasks')`) — never hardcode `localhost:3000` in frontend code.

## Commands (run from the repo root)

```bash
npm install              # install all workspaces
npm run dev              # start frontend + backend together (concurrently)
npm run build            # typecheck + build both workspaces
npm run -w backend build # == tsc; use this to TYPECHECK the backend
npm run -w frontend build
```

There is **no test runner or linter configured yet**. If you add tests, use
Vitest (it pairs with Vite) and wire a root `test` script. Don't claim tests
pass when none exist.

### Verifying a change

- Backend: `npm run -w backend build` must succeed (this is the typecheck).
- API: `curl -s localhost:3000/api/health` and `curl -s localhost:3000/api/tasks`.
- Frontend: `npm run -w frontend build` (runs `tsc` then `vite build`).

Ports: frontend **5173**, backend **3000**.

## Conventions

- **TypeScript everywhere**, ESM (`"type": "module"`). Keep the strict tsconfig
  settings — no `any`, no `@ts-ignore` to silence real errors.
- Express handlers validate input and `return` after sending an error response
  (see the existing `POST /api/tasks`). Match that pattern: validate → respond →
  `return`.
- Keep the `Task` interface in sync between `backend/src/index.ts` and
  `frontend/src/App.tsx` — they must agree on the shape.
- Frontend uses plain CSS variables from `index.css`; no CSS framework. Reuse the
  existing `.card`, `.badge`, `.status-row` classes rather than inventing styles.

## When asked to "add an endpoint"

1. Add the route in `backend/src/index.ts` next to the other `/api/...` routes,
   with input validation.
2. Wire the corresponding `fetch` call in `frontend/src/App.tsx`.
3. Typecheck both workspaces.

See `.claude/commands/` for slash commands that automate the common flows.
