import { useState, useEffect } from 'react';

interface Task {
  id: number;
  title: string;
  completed: boolean;
}

interface HealthStatus {
  status: string;
  uptime: number;
  timestamp: string;
  environment: string;
}

function App() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [newTaskTitle, setNewTaskTitle] = useState('');
  const [health, setHealth] = useState<HealthStatus | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Fetch health status and tasks
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setError(null);

        // Fetch health
        const healthRes = await fetch('/api/health');
        if (healthRes.ok) {
          const healthData = await healthRes.json();
          setHealth(healthData);
        } else {
          setHealth(null);
        }

        // Fetch tasks
        const tasksRes = await fetch('/api/tasks');
        if (tasksRes.ok) {
          const tasksData = await tasksRes.json();
          setTasks(tasksData);
        } else {
          throw new Error('Failed to fetch tasks from the backend server.');
        }
      } catch (err) {
        console.error('Error fetching data:', err);
        setError(err instanceof Error ? err.message : 'Backend server is not responding.');
        setHealth(null);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
    // Poll health status every 10 seconds
    const interval = setInterval(async () => {
      try {
        const res = await fetch('/api/health');
        if (res.ok) {
          const data = await res.json();
          setHealth(data);
        } else {
          setHealth(null);
        }
      } catch {
        setHealth(null);
      }
    }, 10000);

    return () => clearInterval(interval);
  }, []);

  const handleAddTask = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newTaskTitle.trim()) return;

    try {
      const res = await fetch('/api/tasks', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title: newTaskTitle }),
      });

      if (res.ok) {
        const newTask = await res.json();
        setTasks((prev) => [...prev, newTask]);
        setNewTaskTitle('');
      } else {
        alert('Failed to add task');
      }
    } catch (err) {
      console.error('Error adding task:', err);
      alert('Network error when adding task');
    }
  };

  const handleToggleTask = async (id: number, completed: boolean) => {
    try {
      const res = await fetch(`/api/tasks/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ completed }),
      });

      if (res.ok) {
        const updatedTask = await res.json();
        setTasks((prev) =>
          prev.map((t) => (t.id === id ? updatedTask : t))
        );
      } else {
        alert('Failed to update task');
      }
    } catch (err) {
      console.error('Error updating task:', err);
      alert('Network error when updating task');
    }
  };

  const handleDeleteTask = async (id: number) => {
    try {
      const res = await fetch(`/api/tasks/${id}`, {
        method: 'DELETE',
      });

      if (res.ok) {
        setTasks((prev) => prev.filter((t) => t.id !== id));
      } else {
        alert('Failed to delete task');
      }
    } catch (err) {
      console.error('Error deleting task:', err);
      alert('Network error when deleting task');
    }
  };

  return (
    <div className="container">
      <header>
        <h1>React + Node.js Template</h1>
        <p>A modern, modular template powered by Nix, Vite, and Express</p>
      </header>

      {error && (
        <div style={{
          backgroundColor: 'rgba(239, 68, 68, 0.1)',
          border: '1px solid var(--accent-danger)',
          color: 'var(--text-primary)',
          padding: '1rem',
          borderRadius: 'var(--radius-sm)',
          marginBottom: '2rem',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center'
        }}>
          <span>⚠️ {error} Make sure your backend server is running on port 3000!</span>
          <button style={{ padding: '0.25rem 0.75rem', fontSize: '0.8rem' }} onClick={() => window.location.reload()}>Retry</button>
        </div>
      )}

      <div className="dashboard-grid">
        {/* Connection & Status Card */}
        <section className="card">
          <div className="card-title">
            <span>🔌 System Status</span>
            {health ? (
              <span className="badge badge-success">Online</span>
            ) : (
              <span className="badge badge-danger">Offline</span>
            )}
          </div>
          
          <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', marginTop: '1.5rem' }}>
            <div className="status-row">
              <span className="status-label">Backend Status</span>
              <span className="status-value">
                {health ? (
                  <span style={{ color: 'var(--accent-success)' }}>● Healthy</span>
                ) : (
                  <span style={{ color: 'var(--accent-danger)' }}>● Down / Unreachable</span>
                )}
              </span>
            </div>
            
            <div className="status-row">
              <span className="status-label">API Endpoint</span>
              <span className="status-value"><code>/api/health</code></span>
            </div>

            <div className="status-row">
              <span className="status-label">Uptime</span>
              <span className="status-value">
                {health ? `${Math.floor(health.uptime)} seconds` : 'N/A'}
              </span>
            </div>

            <div className="status-row">
              <span className="status-label">Environment</span>
              <span className="status-value" style={{ textTransform: 'capitalize' }}>
                {health ? health.environment : 'N/A'}
              </span>
            </div>

            <div className="status-row">
              <span className="status-label">Client Host</span>
              <span className="status-value">{window.location.host}</span>
            </div>
          </div>

          <div style={{ marginTop: '2rem', fontSize: '0.9rem', color: 'var(--text-secondary)' }}>
            <p style={{ marginBottom: '0.5rem' }}><strong>How to run:</strong></p>
            <ol style={{ paddingLeft: '1.2rem', display: 'flex', flexDirection: 'column', gap: '0.25rem' }}>
              <li>Run <code>nix develop</code> to load Node.js</li>
              <li>Run <code>npm install</code> at the root</li>
              <li>Run <code>npm run dev</code> to start both services</li>
            </ol>
          </div>
        </section>

        {/* Task Manager (Interactive Demo) */}
        <section className="card">
          <h2 className="card-title">📝 Task Manager</h2>
          <p style={{ color: 'var(--text-secondary)', marginBottom: '1.5rem', fontSize: '0.9rem' }}>
            This list is synchronized in-memory with the Express backend API. Try adding, completing, or removing items.
          </p>

          <form onSubmit={handleAddTask} className="form-group">
            <div className="input-container">
              <input
                type="text"
                placeholder="Buy milk, write tests..."
                value={newTaskTitle}
                onChange={(e) => setNewTaskTitle(e.target.value)}
                disabled={loading && tasks.length === 0}
              />
              <button type="submit" disabled={loading && tasks.length === 0}>Add</button>
            </div>
          </form>

          {loading && tasks.length === 0 ? (
            <div className="empty-state">Loading tasks...</div>
          ) : tasks.length === 0 ? (
            <div className="empty-state">No tasks found. Create one above!</div>
          ) : (
            <ul className="task-list">
              {tasks.map((task) => (
                <li
                  key={task.id}
                  className={`task-item ${task.completed ? 'task-completed' : ''}`}
                >
                  <div className="task-info">
                    <input
                      type="checkbox"
                      className="task-checkbox"
                      checked={task.completed}
                      onChange={(e) => handleToggleTask(task.id, e.target.checked)}
                    />
                    <span className="task-title-text">{task.title}</span>
                  </div>
                  <button
                    className="btn-danger"
                    onClick={() => handleDeleteTask(task.id)}
                  >
                    Delete
                  </button>
                </li>
              ))}
            </ul>
          )}
        </section>
      </div>
    </div>
  );
}

export default App;
