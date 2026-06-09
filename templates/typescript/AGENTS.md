# AGENTS.md

Instructions for Codex and other agents that read `AGENTS.md`. The full project
guide lives in **`CLAUDE.md`** — read it; everything there applies to you too.
This file repeats only the essentials so you can act without extra lookups.

## What this is

TypeScript monorepo, npm workspaces: `frontend/` (React + Vite) and `backend/`
(Express + tsx). State is in-memory, no database. Frontend proxies `/api/*` to
the backend on port 3000; frontend runs on 5173.

## Always run from the repo root

```bash
npm run dev               # frontend + backend together
npm run -w backend build  # typecheck the backend (tsc)
npm run -w frontend build # typecheck + build the frontend
curl -s localhost:3000/api/health
```

## Rules

- Validate input in Express handlers, then `return` after sending an error.
- Keep the `Task` interface identical in `backend/src/index.ts` and
  `frontend/src/App.tsx`.
- No test/lint setup exists yet — don't report passing tests that don't exist.
- Frontend uses relative `fetch('/api/...')` URLs only.

## Coordinating with the other agent

You may be running alongside Claude in a split workmux pane, with a `pueue`
queue in a third pane. To avoid clobbering each other's edits, stick to your
assigned area (e.g. one agent on `backend/`, one on `frontend/`). See
`AI_ORCHESTRATION.md` for the queue-based workflow.
