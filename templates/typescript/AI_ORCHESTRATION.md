# Multi-agent orchestration

How this template runs **two coding agents (Claude + Codex) in parallel** inside
a sandbox, with **pueue** as a task queue to dispatch and watch headless agent
jobs. This is the demo-able part of the setup.

## The setup

`nix develop` (or `direnv` / `workmux`) opens a three-pane session **inside a
Lima micro-VM sandbox** (configured in `home/ai.nix`, with the API keys passed
through). The flake's `workmux` block lays it out:

```
┌──────────┬──────────┐
│          │  codex   │   interactive agents
│  claude  ├──────────┤
│          │  pueue   │   queue / orchestrator
└──────────┴──────────┘
```

Because everything runs in the sandbox VM, the agents start in autonomous mode
(`claude --dangerously-skip-permissions`, `codex --yolo`) — a wrong command can
only hurt the disposable VM, not your machine.

## Two modes of working

**1. Interactive, divided by area.** Drive Claude and Codex live in their panes.
Give each a lane so they don't fight over files — e.g. Claude on `backend/`,
Codex on `frontend/`. The shared `CLAUDE.md` / `AGENTS.md` keep both consistent.

**2. Headless, queued via pueue.** The bottom pane is a normal shell with the
pueue daemon already running (`pueued -d`). Use it to **enqueue non-interactive
agent runs** and let pueue schedule them (the daemon allows 2 parallel tasks):

```bash
# queue a headless Claude job and a headless Codex job
pueue add -- claude -p "add a PUT /api/tasks/:id/title endpoint, typecheck it"
pueue add -- codex exec "add a filter toggle (all/active/done) to the task list"

# watch them run
pueue status            # the pane already shows this on startup
pueue follow            # tail the live output of the running task(s)
pueue log <id>          # full output of a finished task

# build pipelines: only typecheck once the edit job (id 0) succeeds
pueue add --after 0 -- npm run -w backend build
```

Useful queue controls: `pueue pause` / `pueue start`, `pueue kill <id>`,
`pueue clean` (drop finished tasks), `pueue parallel 3` (raise concurrency).

## Why this is interesting (talking points)

- **Reproducible env**: the Nix flake pins Node 22 + tooling; the same shell on
  any machine, no "works on mine".
- **Safe autonomy**: agents run full-auto, but inside a Lima sandbox, so YOLO
  mode has a blast radius of one throwaway VM.
- **Parallelism with backpressure**: pueue turns "run these N agent tasks" into a
  scheduled queue with dependencies (`--after`), concurrency limits, and logs —
  instead of juggling background jobs by hand.
- **Shared context**: one `CLAUDE.md` / `AGENTS.md` means Claude and Codex follow
  the same conventions and stay off each other's toes.

## Files that make the agents effective

- `CLAUDE.md` / `AGENTS.md` — project memory both agents read on startup.
- `.claude/settings.json` — pre-approved commands so autonomous runs don't stall
  on permission prompts (and a deny-list for `git push`, secrets, `rm -rf`).
- `.claude/commands/` — slash commands for the repeat flows: `/add-endpoint`,
  `/review`, `/ship`.
- `.claude/agents/code-reviewer.md` — a reviewer subagent to check changes.
