# TypeScript Full-Stack Project Template

A modern, fast, and robust project template featuring a React frontend (powered by Vite) and a Node.js backend (Express) fully written in TypeScript, set up in an npm Workspace, managed seamlessly with a Nix development shell.

## Features

- **Nix Dev Shell**: Installs and locks Node.js 22 to ensure consistent environments across developer machines.
- **Vite & React (TypeScript)**: Hot Module Replacement (HMR), static analysis, and fast builds.
- **Express Backend (TypeScript)**: Lightweight, clean API structure written in TypeScript, running with modern `tsx` watcher for lightning-fast live-reloading.
- **npm Workspaces**: Run a single command from the root to install dependencies and run both servers simultaneously.
- **API Proxy**: Frontend is pre-configured to proxy `/api` routes directly to the backend (`localhost:3000`), resolving CORS issues naturally.
- **Vanilla CSS**: Premium-quality, modern, responsive styling without heavy CSS frameworks.

## Quick Start

### 1. Enter the Development Shell

Make sure you have Nix installed. Enter the folder and run:

```console
nix develop
```

*If you have `direnv` installed, the shell will load automatically when you `cd` into the directory.*

### 2. Install Dependencies

All dependencies are managed from the root package.json using npm workspaces:

```console
npm install
```

### 3. Run the Development Servers

Start both the React frontend and the Express backend simultaneously with:

```console
npm run dev
```

- **Frontend**: http://localhost:5173
- **Backend**: http://localhost:3000
- **Health Check**: http://localhost:3000/api/health

---

## Workspace Structure

```
.
├── flake.nix             # Multi-system Nix devShell configuration
├── package.json          # Root workspace configuration (concurrent scripts)
├── README.md             # This guide
├── .envrc                # Direnv integration
├── .gitignore            # Git exclusions
│
├── frontend/             # React application (TypeScript)
│   ├── index.html        # Main HTML layout
│   ├── vite.config.ts    # Vite configuration with API proxies
│   ├── tsconfig.json     # TypeScript settings
│   ├── package.json      # Frontend metadata and dependencies
│   └── src/
│       ├── main.tsx      # React DOM entry point
│       ├── App.tsx       # Core frontend logic (fetches/updates backend tasks)
│       └── index.css     # Clean and responsive styling
│
└── backend/              # Express API application (TypeScript)
    ├── tsconfig.json     # TypeScript compiler settings
    ├── package.json      # Backend metadata and dependencies
    └── src/
        └── index.ts      # Express server with REST API routes
```

## Production Build

To build both workspaces for production:

```console
npm run build
```

To start the production Express backend:

```console
npm run start
```
