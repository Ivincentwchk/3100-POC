import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

function App() {
  const [healthStatus, setHealthStatus] = useState(null);
  const [message, setMessage] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchData = async () => {
    setLoading(true);
    setError(null);
    
    try {
      // Fetch health check
      const healthResponse = await axios.get(`${API_URL}/api/health/`);
      setHealthStatus(healthResponse.data);

      // Fetch hello message
      const helloResponse = await axios.get(`${API_URL}/api/hello/`);
      setMessage(helloResponse.data);
    } catch (err) {
      setError('Failed to connect to the backend. Make sure the Django server is running.');
      console.error('Error fetching data:', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="App">
      <div className="container">
        <h1>🚀 3100 POC</h1>
        <p className="subtitle">Django + PostgreSQL + React</p>

        <div className="card">
          <h2>Connection Status</h2>
          {loading && <p className="loading">Loading...</p>}
          
          {error && (
            <div className="error">
              <p>{error}</p>
              <button onClick={fetchData} className="retry-btn">
                Retry Connection
              </button>
            </div>
          )}

          {!loading && !error && healthStatus && (
            <div className="success">
              <div className="status-item">
                <span className="label">Backend Status:</span>
                <span className="value status-healthy">{healthStatus.status}</span>
              </div>
              <div className="status-item">
                <span className="label">Message:</span>
                <span className="value">{healthStatus.message}</span>
              </div>
            </div>
          )}

          {!loading && !error && message && (
            <div className="message-box">
              <p className="api-message">{message.message}</p>
            </div>
          )}
        </div>

        <div className="info-cards">
          <div className="info-card">
            <h3>🐘 PostgreSQL</h3>
            <p>Database running on port 5432</p>
          </div>
          <div className="info-card">
            <h3>🐍 Django</h3>
            <p>Backend API on port 8000</p>
          </div>
          <div className="info-card">
            <h3>⚛️ React</h3>
            <p>Frontend on port 3000</p>
          </div>
        </div>

        <div className="footer">
          <p>All services running in Docker containers 🐳</p>
        </div>
      </div>
    </div>
  );
}

export default App;
