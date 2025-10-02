# 3100-POC

Full-stack web application with Django REST API, PostgreSQL database, and React frontend - all containerized with Docker.

## 🏗️ Architecture

- **Frontend**: React 18 with modern UI
- **Backend**: Django 4.2 with Django REST Framework
- **Database**: PostgreSQL 15
- **Containerization**: Docker & Docker Compose

## 📋 Prerequisites

- Docker Desktop installed and running
- Git
- At least 4GB of available RAM

## 🚀 Quick Start

### Option 1: Using Setup Script (Recommended for Windows)

```powershell
.\setup.ps1
```

### Option 2: Manual Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ivincentwchk/3100-POC.git
   cd 3100-POC
   ```

2. **Build and start the containers**
   ```bash
   docker-compose up --build
   ```

3. **Run database migrations** (in a new terminal)
   ```bash
   docker-compose exec backend python manage.py migrate
   ```

4. **Create a superuser** (optional)
   ```bash
   docker-compose exec backend python manage.py createsuperuser
   ```

## 🌐 Access Points

Once running, you can access:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Django Admin**: http://localhost:8000/admin
- **API Health Check**: http://localhost:8000/api/health/
- **API Hello Endpoint**: http://localhost:8000/api/hello/

## 📁 Project Structure

```
3100-POC/
├── backend/                 # Django backend
│   ├── api/                # API application
│   ├── config/             # Django settings
│   ├── Dockerfile          # Backend container config
│   └── requirements.txt    # Python dependencies
├── frontend/               # React frontend
│   ├── public/            # Static files
│   ├── src/               # React components
│   ├── Dockerfile         # Frontend container config
│   └── package.json       # Node dependencies
├── docker-compose.yml     # Docker orchestration
├── .env.example          # Environment variables template
└── README.md             # This file
```

## 🛠️ Development

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db
```

### Stop Containers

```bash
docker-compose down
```

### Restart Services

```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart backend
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

### Run Django Commands

```bash
# Make migrations
docker-compose exec backend python manage.py makemigrations

# Migrate
docker-compose exec backend python manage.py migrate

# Create superuser
docker-compose exec backend python manage.py createsuperuser

# Django shell
docker-compose exec backend python manage.py shell
```

### Install New Dependencies

**Backend (Python):**
1. Add package to `backend/requirements.txt`
2. Rebuild: `docker-compose up --build backend`

**Frontend (Node):**
1. Add package to `frontend/package.json` or:
   ```bash
   docker-compose exec frontend npm install <package-name>
   ```
2. Rebuild: `docker-compose up --build frontend`

## 🔧 Configuration

### Environment Variables

Copy `.env.example` to `.env` and modify as needed:

```bash
cp .env.example .env
```

Key variables:
- `POSTGRES_DB`: Database name
- `POSTGRES_USER`: Database user
- `POSTGRES_PASSWORD`: Database password
- `DEBUG`: Django debug mode
- `REACT_APP_API_URL`: Backend API URL for frontend

## 🧪 Testing

### Backend Tests

```bash
docker-compose exec backend python manage.py test
```

### Frontend Tests

```bash
docker-compose exec frontend npm test
```

## 📦 Production Deployment

For production deployment:

1. Set `DEBUG=0` in environment variables
2. Update `ALLOWED_HOSTS` in Django settings
3. Configure proper CORS settings
4. Use production-grade web server (e.g., Gunicorn + Nginx)
5. Set strong `SECRET_KEY`
6. Use managed PostgreSQL service
7. Enable HTTPS

## 🐛 Troubleshooting

### Port Already in Use

If ports 3000, 8000, or 5432 are already in use, modify the port mappings in `docker-compose.yml`.

### Database Connection Issues

```bash
# Check if database is healthy
docker-compose ps

# Restart database
docker-compose restart db

# Check database logs
docker-compose logs db
```

### Frontend Can't Connect to Backend

1. Ensure backend is running: `docker-compose ps`
2. Check CORS settings in `backend/config/settings.py`
3. Verify `REACT_APP_API_URL` in frontend environment

### Clean Rebuild

```bash
# Stop and remove all containers, networks, and volumes
docker-compose down -v

# Rebuild from scratch
docker-compose up --build
```

## 📝 API Endpoints

### Health Check
- **GET** `/api/health/`
- Returns API status

### Hello World
- **GET** `/api/hello/`
- Returns welcome message

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is for educational purposes.

## 👥 Authors

- Your Name

## 🙏 Acknowledgments

- Django Documentation
- React Documentation
- Docker Documentation
