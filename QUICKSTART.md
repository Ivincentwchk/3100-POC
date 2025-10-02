# Quick Start Guide

## 🚀 Get Started in 3 Steps

### Step 1: Start Docker Containers

```powershell
docker-compose up --build
```

This will:
- Build all Docker images
- Start PostgreSQL database
- Start Django backend
- Start React frontend

### Step 2: Run Database Migrations

Open a new terminal and run:

```powershell
docker-compose exec backend python manage.py migrate
```

### Step 3: Access the Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000/api/
- **Django Admin**: http://localhost:8000/admin

## 🎯 Common Commands

### Start Everything
```powershell
docker-compose up
```

### Stop Everything
```powershell
docker-compose down
```

### View Logs
```powershell
docker-compose logs -f
```

### Create Django Superuser
```powershell
docker-compose exec backend python manage.py createsuperuser
```

### Restart a Service
```powershell
docker-compose restart backend
docker-compose restart frontend
```

## ✅ Verify Installation

1. Visit http://localhost:3000
2. You should see a beautiful UI showing connection status
3. If all is green, you're ready to develop!

## 🆘 Troubleshooting

**Containers won't start?**
- Make sure Docker Desktop is running
- Check if ports 3000, 8000, 5432 are available

**Database connection error?**
- Wait a few seconds for PostgreSQL to initialize
- Run: `docker-compose restart backend`

**Need a clean start?**
```powershell
docker-compose down -v
docker-compose up --build
```

## 📚 Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Explore the Django admin at http://localhost:8000/admin
- Start building your API endpoints in `backend/api/`
- Customize the React frontend in `frontend/src/`
