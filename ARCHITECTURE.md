# Architecture Overview

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Docker Host                          │
│                                                             │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────┐ │
│  │   Frontend     │  │    Backend     │  │   Database   │ │
│  │   Container    │  │   Container    │  │  Container   │ │
│  │                │  │                │  │              │ │
│  │  React 18      │  │  Django 4.2    │  │ PostgreSQL   │ │
│  │  Port: 3000    │  │  Port: 8000    │  │ Port: 5432   │ │
│  │                │  │                │  │              │ │
│  │  - Modern UI   │  │  - REST API    │  │ - Data Store │ │
│  │  - Axios       │  │  - DRF         │  │ - Persistent │ │
│  │  - Hot Reload  │  │  - CORS        │  │   Volume     │ │
│  └────────┬───────┘  └────────┬───────┘  └──────┬───────┘ │
│           │                   │                  │         │
│           │    HTTP Requests  │    SQL Queries   │         │
│           └──────────────────►└─────────────────►│         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
           │                    │                  │
           │                    │                  │
           ▼                    ▼                  ▼
    localhost:3000      localhost:8000      localhost:5432
```

## 🔄 Request Flow

### Frontend → Backend → Database

1. **User Action** (Browser)
   - User visits http://localhost:3000
   - React app loads in browser

2. **API Request** (Frontend → Backend)
   - React component calls API using Axios
   - Request sent to http://localhost:8000/api/

3. **Backend Processing** (Django)
   - Django receives request
   - Routes to appropriate view
   - Processes business logic

4. **Database Query** (Backend → Database)
   - Django ORM generates SQL
   - Queries PostgreSQL database
   - Retrieves/stores data

5. **Response** (Database → Backend → Frontend)
   - Data returned to Django
   - Serialized to JSON
   - Sent back to React
   - UI updates with new data

## 📦 Container Details

### Frontend Container (poc_frontend)
```yaml
Base Image: node:18-alpine
Working Dir: /app
Exposed Port: 3000
Volume Mount: ./frontend:/app
Hot Reload: ✅ Enabled
```

**Key Files:**
- `package.json` - Dependencies
- `src/App.js` - Main component
- `src/index.js` - Entry point
- `public/index.html` - HTML template

### Backend Container (poc_backend)
```yaml
Base Image: python:3.11-slim
Working Dir: /app
Exposed Port: 8000
Volume Mount: ./backend:/app
Hot Reload: ✅ Enabled
```

**Key Files:**
- `requirements.txt` - Python packages
- `manage.py` - Django CLI
- `config/settings.py` - Configuration
- `api/views.py` - API endpoints

### Database Container (poc_postgres)
```yaml
Base Image: postgres:15-alpine
Exposed Port: 5432
Volume: postgres_data (persistent)
Health Check: ✅ Configured
```

**Configuration:**
- Database: poc_db
- User: poc_user
- Password: poc_password

## 🌐 Network Communication

### Docker Network
All containers are on the same Docker network and can communicate using service names:

- Frontend → Backend: `http://backend:8000`
- Backend → Database: `postgresql://poc_user:poc_password@db:5432/poc_db`

### Host Access
From your computer (host machine):

- Frontend: `http://localhost:3000`
- Backend: `http://localhost:8000`
- Database: `postgresql://localhost:5432/poc_db`

## 📊 Data Flow Diagram

```
┌──────────┐
│ Browser  │
└────┬─────┘
     │
     │ HTTP GET http://localhost:3000
     ▼
┌─────────────────┐
│ React Frontend  │
│  (Port 3000)    │
└────┬────────────┘
     │
     │ API Call: GET /api/health/
     │ URL: http://localhost:8000/api/health/
     ▼
┌─────────────────┐
│ Django Backend  │
│  (Port 8000)    │
│                 │
│ 1. URL Router   │──► /api/health/ → views.health_check
│ 2. View         │──► Process request
│ 3. Serializer   │──► Format response
└────┬────────────┘
     │
     │ (If database needed)
     │ SQL Query via Django ORM
     ▼
┌─────────────────┐
│  PostgreSQL     │
│  (Port 5432)    │
│                 │
│ - Execute Query │
│ - Return Data   │
└─────────────────┘
```

## 🔐 Security Considerations

### Development Mode (Current Setup)
- ⚠️ DEBUG=True (shows detailed errors)
- ⚠️ CORS allows localhost:3000
- ⚠️ Default database credentials
- ⚠️ No HTTPS

### Production Recommendations
- ✅ Set DEBUG=False
- ✅ Restrict ALLOWED_HOSTS
- ✅ Use environment variables for secrets
- ✅ Enable HTTPS/SSL
- ✅ Use strong database passwords
- ✅ Implement authentication/authorization
- ✅ Add rate limiting
- ✅ Use production web server (Gunicorn + Nginx)

## 🔧 Environment Variables

### Backend (.env)
```bash
DEBUG=1
SECRET_KEY=your-secret-key
DATABASE_NAME=poc_db
DATABASE_USER=poc_user
DATABASE_PASSWORD=poc_password
DATABASE_HOST=db
DATABASE_PORT=5432
```

### Frontend (.env)
```bash
REACT_APP_API_URL=http://localhost:8000
```

## 📈 Scaling Considerations

### Current Setup (Development)
- Single instance of each service
- Suitable for local development
- Not production-ready

### Production Scaling Options
1. **Horizontal Scaling**
   - Multiple backend containers behind load balancer
   - Multiple frontend containers
   - Managed PostgreSQL service

2. **Vertical Scaling**
   - Increase container resources
   - Optimize database queries
   - Add caching (Redis)

3. **Infrastructure**
   - Kubernetes for orchestration
   - Cloud services (AWS, GCP, Azure)
   - CDN for static files
   - Separate database server

## 🛠️ Development Workflow

```
1. Code Change
   │
   ├─► Frontend (src/)
   │   └─► Hot reload → Browser updates automatically
   │
   └─► Backend (api/)
       └─► Django dev server reloads → API updates

2. Database Change
   │
   ├─► Create/modify models.py
   ├─► Run: docker-compose exec backend python manage.py makemigrations
   ├─► Run: docker-compose exec backend python manage.py migrate
   └─► Database schema updated

3. Add Dependencies
   │
   ├─► Frontend: Update package.json → Rebuild container
   └─► Backend: Update requirements.txt → Rebuild container

4. Test Changes
   │
   ├─► Frontend: http://localhost:3000
   ├─► Backend API: http://localhost:8000/api/
   └─► Admin: http://localhost:8000/admin
```

## 📚 Technology Stack

### Frontend Stack
- **React 18** - UI framework
- **Axios** - HTTP client
- **CSS3** - Styling (with gradients)
- **Create React App** - Build tooling

### Backend Stack
- **Django 4.2** - Web framework
- **Django REST Framework** - API toolkit
- **psycopg2** - PostgreSQL adapter
- **django-cors-headers** - CORS handling
- **python-decouple** - Environment config

### Database Stack
- **PostgreSQL 15** - Relational database
- **Alpine Linux** - Lightweight container

### DevOps Stack
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Git** - Version control

## 🎯 API Endpoints

### Current Endpoints

| Method | Endpoint | Description | Response |
|--------|----------|-------------|----------|
| GET | `/api/health/` | Health check | `{"status": "healthy", "message": "..."}` |
| GET | `/api/hello/` | Hello world | `{"message": "Hello from Django..."}` |
| GET | `/admin/` | Django admin | Admin interface |

### Adding New Endpoints

1. Create view in `backend/api/views.py`
2. Add URL pattern in `backend/api/urls.py`
3. Test at `http://localhost:8000/api/your-endpoint/`
4. Call from React using Axios

## 🔍 Monitoring & Debugging

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

### Container Status
```bash
docker-compose ps
```

### Resource Usage
```bash
docker stats
```

### Access Container Shell
```bash
# Backend
docker-compose exec backend bash

# Frontend
docker-compose exec frontend sh

# Database
docker-compose exec db psql -U poc_user -d poc_db
```

This architecture provides a solid foundation for full-stack development with modern best practices!
