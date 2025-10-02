# Setup Checklist

## ✅ Pre-flight Checks

Before running the Docker environment, make sure:

### 1. Docker Desktop is Running
- [ ] Open Docker Desktop application
- [ ] Wait for Docker to fully start (whale icon should be steady)
- [ ] Verify Docker is running: `docker --version`

### 2. Ports are Available
Check that these ports are not in use:
- [ ] Port 3000 (React frontend)
- [ ] Port 8000 (Django backend)
- [ ] Port 5432 (PostgreSQL database)

**To check ports on Windows:**
```powershell
netstat -ano | findstr :3000
netstat -ano | findstr :8000
netstat -ano | findstr :5432
```

If any ports are in use, either:
- Stop the application using that port, OR
- Modify the port mappings in `docker-compose.yml`

### 3. System Requirements
- [ ] At least 4GB of available RAM
- [ ] At least 2GB of free disk space
- [ ] Internet connection (for first-time image downloads)

## 🚀 Launch Sequence

### Step 1: Start Docker Desktop
1. Open Docker Desktop
2. Wait for it to fully initialize
3. Confirm the Docker icon shows "Docker Desktop is running"

### Step 2: Build and Start Containers
```powershell
docker-compose up --build
```

**Expected output:**
- Building backend image
- Building frontend image
- Pulling PostgreSQL image
- Starting all containers
- Backend should show "Starting development server at http://0.0.0.0:8000/"
- Frontend should show "webpack compiled successfully"

### Step 3: Run Database Migrations
Open a **new terminal** (keep the first one running):
```powershell
docker-compose exec backend python manage.py migrate
```

**Expected output:**
- "Running migrations..."
- "Applying contenttypes.0001_initial... OK"
- Several more "OK" messages

### Step 4: Create Superuser (Optional)
```powershell
docker-compose exec backend python manage.py createsuperuser
```

Follow the prompts to create an admin account.

### Step 5: Verify Everything Works

Visit these URLs in your browser:

1. **Frontend**: http://localhost:3000
   - [ ] Page loads successfully
   - [ ] Shows "3100 POC" heading
   - [ ] Connection status shows "healthy"
   - [ ] No error messages

2. **Backend API**: http://localhost:8000/api/health/
   - [ ] Returns JSON: `{"status": "healthy", "message": "API is running successfully"}`

3. **Django Admin**: http://localhost:8000/admin
   - [ ] Login page appears
   - [ ] Can log in with superuser credentials (if created)

## 🔍 Troubleshooting

### Problem: "Docker Desktop is not running"
**Solution:**
1. Open Docker Desktop application
2. Wait 30-60 seconds for it to start
3. Try the command again

### Problem: "Port is already allocated"
**Solution:**
1. Find what's using the port:
   ```powershell
   netstat -ano | findstr :PORT_NUMBER
   ```
2. Either stop that application or change the port in `docker-compose.yml`

### Problem: "Cannot connect to database"
**Solution:**
1. Wait 10-15 seconds for PostgreSQL to fully initialize
2. Check database health:
   ```powershell
   docker-compose ps
   ```
3. Restart backend:
   ```powershell
   docker-compose restart backend
   ```

### Problem: Frontend shows "Failed to connect to backend"
**Solution:**
1. Check backend is running:
   ```powershell
   docker-compose logs backend
   ```
2. Verify backend is accessible: http://localhost:8000/api/health/
3. Check CORS settings in `backend/config/settings.py`

### Problem: "npm install" errors in frontend
**Solution:**
1. Stop containers: `docker-compose down`
2. Rebuild frontend: `docker-compose up --build frontend`

## 🧹 Clean Start

If you encounter persistent issues, try a clean rebuild:

```powershell
# Stop and remove everything
docker-compose down -v

# Remove all images (optional, will re-download)
docker-compose down --rmi all

# Rebuild from scratch
docker-compose up --build
```

## 📊 Health Check Commands

### View All Container Status
```powershell
docker-compose ps
```

### View Logs
```powershell
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

### Check Database Connection
```powershell
docker-compose exec db psql -U poc_user -d poc_db -c "SELECT version();"
```

### Test Backend API
```powershell
curl http://localhost:8000/api/health/
```

## ✅ Success Criteria

You know everything is working when:
- [ ] All three containers are running (check with `docker-compose ps`)
- [ ] Frontend loads at http://localhost:3000
- [ ] Backend API responds at http://localhost:8000/api/health/
- [ ] Database is accessible
- [ ] No error messages in logs
- [ ] Frontend shows "healthy" status

## 🎉 Next Steps

Once everything is running:
1. Explore the Django admin panel
2. Check out the API endpoints
3. Modify the React frontend
4. Create your own Django models and APIs
5. Build something amazing!

## 📞 Getting Help

If you're still stuck:
1. Check the logs: `docker-compose logs -f`
2. Review the main [README.md](README.md)
3. Check Docker Desktop dashboard for error messages
4. Ensure all prerequisites are met
