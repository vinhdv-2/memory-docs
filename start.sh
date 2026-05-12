#!/bin/bash

echo "🚀 Starting Memory Docs with Docusaurus + MinIO..."
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  File .env không tồn tại!"
    echo "Tạo từ template..."
    cp .env.example .env
    echo "✅ Đã tạo file .env"
    echo ""
fi

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed."
    exit 1
fi

echo "✅ Docker is ready"
echo ""

# Start services
echo "📦 Starting Docker containers..."
docker compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

echo ""
echo "✅ Services started successfully!"
echo ""
echo "🌐 Truy cập services:"
echo ""
echo "📝 Docusaurus (Outsider port: $DOCS_HOST_PORT, Container port: $DOCS_CONTAINER_PORT):"
echo "   http://localhost:$DOCS_HOST_PORT"
echo ""
echo "💾 MinIO Console (Outsider port: $MINIO_CONSOLE_HOST_PORT, Container port: $MINIO_CONSOLE_CONTAINER_PORT):"
echo "   http://localhost:$MINIO_CONSOLE_HOST_PORT"
echo "   - Username: $MINIO_ROOT_USER"
echo "   - Password: $MINIO_ROOT_PASSWORD"
echo ""
echo "🔌 MinIO API (Outsider port: $MINIO_API_HOST_PORT, Container port: $MINIO_API_CONTAINER_PORT):"
echo "   http://localhost:$MINIO_API_HOST_PORT"
echo ""
echo "📚 View logs:"
echo "   docker-compose logs -f docusaurus"
echo "   docker-compose logs -f minio"
echo ""
echo "🛑 Stop services:"
echo "   docker-compose down"
echo ""
echo "Happy documenting! 📝"
