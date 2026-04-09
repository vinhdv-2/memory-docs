# Memory Docs - Docusaurus + MinIO

Hệ thống tài liệu hoàn chỉnh với Docusaurus và MinIO object storage, chạy hoàn toàn trên Docker.

## 🚀 Tính năng

- ✅ **Docusaurus** - Framework tạo trang tài liệu tĩnh mạnh mẽ
- ✅ **MinIO** - Object storage tương thích S3 để lưu trữ media
- ✅ **Docker** - Triển khai dễ dàng trên mọi môi trường
- ✅ **Environment Configuration** - Quản lý cấu hình tập trung với .env
- ✅ **Hot Reload** - Thay đổi code và thấy kết quả ngay lập tức
- ✅ **Markdown** - Viết tài liệu đơn giản bằng Markdown
- ✅ **Media Storage** - Upload và quản lý media với MinIO qua Web GUI

## 📋 Yêu cầu

- Docker
- Docker Compose

## 🛠️ Cài đặt và chạy

### Cách nhanh nhất:

```bash
cd /home/vinhdv/projects/memory-docs
cp .env.example .env
./start.sh
```

### Hoặc dùng Docker Compose trực tiếp:

```bash
docker-compose up -d
```

### 🌐 Truy cập services

**Mặc định (non-standard ports để tránh conflict):**

```
📝 Docusaurus: http://localhost:3001      (HOST port → Container 3000)
💾 MinIO Console: http://localhost:9011   (HOST port → Container 9001)
🔌 MinIO API: http://localhost:9010       (HOST port → Container 9000)
```

**MinIO Credentials:**
- Username: `admin`
- Password: `admin123`

### 🔌 Port Mapping: Insider vs Outsider

Mỗi service chạy bên trong Docker container với port **cố định** (insider), nhưng có thể được **expose** ra máy host với port **khác biệt** (outsider):

| Service | Container Port (Insider) | Host Port (Outsider) | Biến config |
|---------|---------------------------|----------------------|-------------|
| Docusaurus | 3000 | 3001 | `DOCS_CONTAINER_PORT` / `DOCS_HOST_PORT` |
| MinIO API | 9000 | 9010 | `MINIO_API_CONTAINER_PORT` / `MINIO_API_HOST_PORT` |
| MinIO Console | 9001 | 9011 | `MINIO_CONSOLE_CONTAINER_PORT` / `MINIO_CONSOLE_HOST_PORT` |

**Tại sao sử dụng port khác nhau?**
- **Tránh conflict**: Nếu máy của bạn đã sử dụng port 3000, 9000, 9001 thì Docker không thể chạy
- **Linh hoạt**: Có thể chạy nhiều instances của project với các HOST ports khác
- **Bảo mật**: HOST ports có thể được firewall, Container ports không cần exposing

**Cách chỉnh port:**

Mở `.env` và thay đổi HOST ports (Container ports nên giữ nguyên):

```env
# To change Docusaurus port on your machine:
DOCS_HOST_PORT=4000        # Truy cập: http://localhost:4000

# To change MinIO API port on your machine:
MINIO_API_HOST_PORT=9020   # Truy cập: http://localhost:9020

# To change MinIO Console port on your machine:
MINIO_CONSOLE_HOST_PORT=9021  # Truy cập: http://localhost:9021
```

Sau khi thay đổi, restart services:

```bash
docker-compose restart
```

## 📝 Cách sử dụng

### Viết tài liệu

1. Tất cả tài liệu nằm trong folder `docusaurus/docs/`
2. Tạo file `.md` mới hoặc chỉnh sửa file có sẵn
3. Docusaurus sẽ tự động reload trang

Ví dụ tạo tài liệu mới:

```bash
# Tạo file trong docusaurus/docs/
echo "# Tài liệu mới

Nội dung tài liệu của bạn...
" > docusaurus/docs/new-doc.md
```

### Upload media lên MinIO

#### ✅ Cách 1: Sử dụng MinIO Console (Web UI) - KHUYẾN NGHỊ

**Đây là cách đơn giản và trực quan nhất!**

1. **Mở trình duyệt**, truy cập MinIO Console:
   - http://localhost:9001, HOẶC
   - http://console.minio.memory.local:9001 (nếu đã setup hosts)

2. **Đăng nhập:**
   - Username: `admin` (hoặc xem trong .env)
   - Password: `admin123` (hoặc xem trong .env)

3. **Vào bucket `media`:**
   - Click vào "Buckets" trong menu bên trái
   - Click vào bucket `media`

4. **Upload files:**
   - Click nút **"Upload"** hoặc **"Upload Files"**
   - Chọn files từ máy tính (có thể chọn nhiều files)
   - Hoặc kéo thả (drag & drop) files vào
   - File sẽ được upload ngay lập tức

5. **Tổ chức files (optional):**
   - Tạo folder mới: Click **"Create new path"**
   - Ví dụ: `images/`, `videos/`, `documents/`
   - Upload files vào từng folder

6. **Copy URL:**
   - Click vào file đã upload
   - URL sẽ có dạng: `http://localhost:9000/media/your-file.png`
   - Copy và dùng trong tài liệu

**Ưu điểm:**
- ✅ Trực quan, dễ sử dụng
- ✅ Preview files (hình ảnh, PDF)
- ✅ Quản lý files (rename, delete, download)
- ✅ Tạo folders để tổ chức
- ✅ Upload nhiều files cùng lúc
- ✅ Drag & drop

#### Cách 2: Sử dụng Script (cho automation)

Nếu cần upload tự động hoặc từ command line:

```bash
# Upload file
docker exec -it minio-init mc cp /path/to/file myminio/media/
```

### Sử dụng media trong tài liệu

Sau khi upload file `example.png` lên MinIO, sử dụng trong Markdown:

```markdown
![Example Image](http://localhost:9000/media/example.png)
```

Hoặc HTML với kích thước tùy chỉnh:

```html
<img src="http://localhost:9000/media/example.png" alt="Example" width="600" />
```

Video:

```html
<video width="100%" controls>
  <source src="http://localhost:9000/media/demo.mp4" type="video/mp4" />
</video>
```

File download:

```markdown
[Tải file PDF](http://localhost:9000/media/document.pdf)
```

## 🏗️ Cấu trúc project

```
memory-docs/
├── docker-compose.yml          # Docker Compose configuration
├── docusaurus/                 # Docusaurus application
│   ├── Dockerfile             # Dockerfile cho Docusaurus
│   ├── package.json           # Node.js dependencies
│   ├── docusaurus.config.js   # Docusaurus configuration
│   ├── sidebars.js           # Sidebar configuration
│   ├── docs/                 # Tài liệu (Markdown files)
│   │   ├── intro.md
│   │   └── upload-guide.md
│   ├── blog/                 # Blog posts
│   ├── src/                  # Source code
│   │   ├── components/       # React components
│   │   ├── css/             # CSS files
│   │   └── pages/           # Custom pages
│   └── static/              # Static assets
│       └── img/
└── README.md
```

## 🔧 Các lệnh hữu ích

### Docker

```bash
# Khởi động services
docker-compose up -d

# Xem logs
docker-compose logs -f docusaurus
docker-compose logs -f minio

# Dừng services
docker-compose down

# Dừng và xóa volumes (xóa data MinIO)
docker-compose down -v

# Rebuild Docusaurus
docker-compose up -d --build docusaurus
```

### Docusaurus

```bash
# Vào container Docusaurus
docker exec -it docusaurus sh

# Build production
docker exec -it docusaurus npm run build

# Clear cache
docker exec -it docusaurus npm run clear
```

### MinIO

```bash
# Liệt kê buckets
docker exec -it minio-init mc ls myminio

# Liệt kê files trong bucket media
docker exec -it minio-init mc ls myminio/media

# Upload file
docker cp /path/to/file minio:/tmp/
docker exec -it minio-init mc cp /tmp/file myminio/media/
```

## 🌐 Production Deployment

### Build Docusaurus cho production

```bash
docker exec -it docusaurus npm run build
```

Build output sẽ nằm trong `docusaurus/build/`

### Cấu hình cho production

1. **Thay đổi MinIO credentials** trong `docker-compose.yml`:
   ```yaml
   environment:
     MINIO_ROOT_USER: your-secure-username
     MINIO_ROOT_PASSWORD: your-secure-password
   ```

2. **Cập nhật Docusaurus config** trong `docusaurus/docusaurus.config.js`:
   ```js
   url: 'https://your-domain.com',
   baseUrl: '/',
   ```

3. **Setup reverse proxy** (Nginx, Caddy, etc.) cho:
   - Docusaurus: port 3000
   - MinIO API: port 9000
   - MinIO Console: port 9001

## 📚 Tài liệu tham khảo

- [Docusaurus Documentation](https://docusaurus.io/)
- [MinIO Documentation](https://min.io/docs/minio/linux/index.html)
- [Docker Documentation](https://docs.docker.com/)

## 🤝 Hỗ trợ

Nếu gặp vấn đề, hãy check:

1. Docker và Docker Compose đã được cài đặt chưa
2. Ports 3000, 9000, 9001 có bị chiếm bởi service khác không
3. Logs của services: `docker-compose logs -f`

## 📄 License

MIT

---

**Happy documenting! 📝**
