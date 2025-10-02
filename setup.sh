#!/bin/bash

echo "🚀 Setting up 3100 POC Docker Environment..."

# Build and start all containers
echo "📦 Building Docker containers..."
docker-compose build

# Start the containers
echo "🔄 Starting containers..."
docker-compose up -d

# Wait for database to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
sleep 5

# Run Django migrations
echo "🔧 Running Django migrations..."
docker-compose exec backend python manage.py migrate

# Create Django superuser (optional)
echo "👤 Creating Django superuser..."
echo "You can skip this by pressing Ctrl+C"
docker-compose exec backend python manage.py createsuperuser

echo "✅ Setup complete!"
echo ""
echo "🌐 Access your application:"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend API: http://localhost:8000"
echo "   - Django Admin: http://localhost:8000/admin"
echo ""
echo "📝 Useful commands:"
echo "   - View logs: docker-compose logs -f"
echo "   - Stop containers: docker-compose down"
echo "   - Restart: docker-compose restart"
