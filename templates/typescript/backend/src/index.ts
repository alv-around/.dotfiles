import express, { Request, Response } from "express";
import cors from "cors";

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

interface Task {
  id: number;
  title: string;
  completed: boolean;
}

// In-memory data store for tasks (demonstrates REST state)
let tasks: Task[] = [
  { id: 1, title: "Explore the Nix flake dev shell", completed: true },
  {
    id: 2,
    title: "Install project dependencies using workspaces",
    completed: false,
  },
  {
    id: 3,
    title: "Modify the React frontend to add new features",
    completed: false,
  },
  { id: 4, title: "Build a production-ready package", completed: false },
];

// Health check endpoint
app.get("/api/health", (_req: Request, res: Response) => {
  res.json({
    status: "ok",
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || "development",
  });
});

// GET all tasks
app.get("/api/tasks", (_req: Request, res: Response) => {
  res.json(tasks);
});

// POST a new task
app.post("/api/tasks", (req: Request, res: Response) => {
  const { title } = req.body;

  if (!title || typeof title !== "string" || !title.trim()) {
    res.status(400).json({ error: "Task title is required and must be a string." });
    return;
  }

  const newTask: Task = {
    id: tasks.length > 0 ? Math.max(...tasks.map((t) => t.id)) + 1 : 1,
    title: title.trim(),
    completed: false,
  };

  tasks.push(newTask);
  res.status(201).json(newTask);
});

// PATCH (update) a task's completion status
app.patch("/api/tasks/:id", (req: Request, res: Response) => {
  const id = parseInt(req.params.id, 10);
  const { completed } = req.body;

  if (isNaN(id)) {
    res.status(400).json({ error: "Invalid task ID" });
    return;
  }

  if (typeof completed !== "boolean") {
    res.status(400).json({ error: "Completed status must be a boolean" });
    return;
  }

  const taskIndex = tasks.findIndex((t) => t.id === id);
  if (taskIndex === -1) {
    res.status(404).json({ error: "Task not found" });
    return;
  }

  tasks[taskIndex].completed = completed;
  res.json(tasks[taskIndex]);
});

// DELETE a task
app.delete("/api/tasks/:id", (req: Request, res: Response) => {
  const id = parseInt(req.params.id, 10);

  if (isNaN(id)) {
    res.status(400).json({ error: "Invalid task ID" });
    return;
  }

  const initialLength = tasks.length;
  tasks = tasks.filter((t) => t.id !== id);

  if (tasks.length === initialLength) {
    res.status(404).json({ error: "Task not found" });
    return;
  }

  res.status(204).send();
});

// Start the server
app.listen(port, () => {
  console.log(`🚀 Backend server listening on http://localhost:${port}`);
  console.log(`🔌 Health check endpoint: http://localhost:${port}/api/health`);
  console.log(`📝 Tasks endpoint: http://localhost:${port}/api/tasks`);
});
