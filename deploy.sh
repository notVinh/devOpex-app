#!/bin/bash

echo "--- Bắt đầu quy trình cập nhật tự động ---"

# 1. Kéo image mới (như nashydawg/ex-user) về máy
sudo docker compose pull

# 2. Kiểm tra file cấu hình Nginx trước khi áp dụng
# (Nếu bạn có file nginx cục bộ, Docker sẽ mount vào container)
echo "Đang kiểm tra cấu hình Nginx..."
sudo docker run --rm -v $(pwd)/nginx/default.conf:/etc/nginx/conf.d/default.conf:ro nginx:latest nginx -t

if [ $? -eq 0 ]; then
    echo "Cấu hình Nginx hợp lệ. Đang tiến hành cập nhật..."
    
    # 3. Khởi động lại các container
    # --remove-orphans giúp dọn sạch các service cũ không còn trong file compose
    sudo docker compose up -d --remove-orphans 

    # 4. Dọn dẹp image cũ để tiết kiệm ổ cứng máy ảo
    sudo docker image prune -f
    
    echo "--- Cập nhật thành công vào lúc: $(date) ---"
else
    echo "LỖI: Cấu hình Nginx không hợp lệ! Hủy bỏ quy trình deploy."
    exit 1
fi