Write-Host "🚀 Setting up 3100 POC Docker Environment..." -ForegroundColor Green

# Build and start all containers
Write-Host "📦 Building Docker containers..." -ForegroundColor Yellow
docker-compose build

# Start the containers
Write-Host "🔄 Starting containers..." -ForegroundColor Yellow
docker-compose up -d

# Wait for database to be ready
Write-Host "⏳ Waiting for PostgreSQL to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Run Django migrations
Write-Host "🔧 Running Django migrations..." -ForegroundColor Yellow
docker-compose exec backend python manage.py migrate

# Create Django superuser (optional)
Write-Host "👤 Creating Django superuser..." -ForegroundColor Yellow
Write-Host "You can skip this by pressing Ctrl+C" -ForegroundColor Cyan
docker-compose exec backend python manage.py createsuperuser

Write-Host "✅ Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Access your application:" -ForegroundColor Cyan
Write-Host "   - Frontend: http://localhost:3000"
Write-Host "   - Backend API: http://localhost:8000"
Write-Host "   - Django Admin: http://localhost:8000/admin"
Write-Host ""
Write-Host "📝 Useful commands:" -ForegroundColor Cyan
Write-Host "   - View logs: docker-compose logs -f"
Write-Host "   - Stop containers: docker-compose down"
Write-Host "   - Restart: docker-compose restart"
