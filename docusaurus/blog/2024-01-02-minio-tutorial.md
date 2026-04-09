---
slug: how-to-use-minio
title: Hướng dẫn sử dụng MinIO để lưu trữ media
authors: [admin]
tags: [minio, storage, tutorial]
---

MinIO là object storage mạnh mẽ và dễ sử dụng. Trong bài viết này, chúng ta sẽ tìm hiểu cách sử dụng MinIO để lưu trữ và quản lý media files.

<!--truncate-->

## Upload file lên MinIO

### 1. Truy cập MinIO Console

Mở trình duyệt và truy cập: http://localhost:9001

### 2. Đăng nhập

- Username: `admin`
- Password: `admin123`

### 3. Upload file

1. Click vào bucket `media`
2. Click nút **Upload**
3. Chọn file từ máy tính
4. File sẽ được upload ngay lập tức

## Sử dụng trong tài liệu

Sau khi upload, bạn có thể sử dụng URL:

```
http://localhost:9000/media/your-file.png
```

### Ví dụ với hình ảnh

```markdown
![My Image](http://localhost:9000/media/screenshot.png)
```

### Ví dụ với video

```html
<video width="100%" controls>
  <source src="http://localhost:9000/media/demo.mp4" type="video/mp4" />
</video>
```

## Tips & Tricks

- Đặt tên file không dấu, không khoảng trắng
- Sử dụng thư mục để tổ chức (ví dụ: `images/`, `videos/`)
- MinIO hỗ trợ mọi loại file

Happy uploading! 🚀
