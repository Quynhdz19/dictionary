#!/bin/bash

# Script build và chạy Từ Điển Tiếng Anh
# Tác giả: AI Assistant
# Ngày tạo: $(date)

echo "🚀 Bắt đầu build Từ Điển Tiếng Anh..."

# Kiểm tra dependencies
echo "📋 Kiểm tra dependencies..."

# Kiểm tra gcc
if ! command -v g++ &> /dev/null; then
    echo "❌ Không tìm thấy g++. Vui lòng cài đặt build-essential"
    echo "   Ubuntu/Debian: sudo apt install build-essential"
    echo "   macOS: brew install gcc"
    exit 1
fi

# Kiểm tra make
if ! command -v make &> /dev/null; then
    echo "❌ Không tìm thấy make. Vui lòng cài đặt make"
    echo "   Ubuntu/Debian: sudo apt install make"
    echo "   macOS: brew install make"
    exit 1
fi

# Kiểm tra curl
if ! command -v curl &> /dev/null; then
    echo "❌ Không tìm thấy curl. Vui lòng cài đặt curl"
    echo "   Ubuntu/Debian: sudo apt install curl"
    echo "   macOS: brew install curl"
    exit 1
fi

echo "✅ Tất cả dependencies đã sẵn sàng!"

# Clean build cũ
echo "🧹 Dọn dẹp build cũ..."
make clean

# Tải dependencies
echo "📥 Tải dependencies..."
make deps

# Build project
echo "🔨 Build project..."
make all

if [ $? -eq 0 ]; then
    echo "✅ Build thành công!"
    echo ""
    echo "🎉 Từ Điển Tiếng Anh đã sẵn sàng!"
    echo "🌐 Truy cập: http://localhost:8080"
    echo ""
    echo "📱 Tính năng:"
    echo "   - Tìm kiếm từ vựng"
    echo "   - Học từ ngẫu nhiên"
    echo "   - Xem tất cả từ"
    echo "   - Giao diện đẹp mắt cho học sinh"
    echo ""
    
    # Hỏi người dùng có muốn chạy ngay không
    read -p "🚀 Bạn có muốn chạy ứng dụng ngay bây giờ? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 Khởi động server..."
        echo "💡 Nhấn Ctrl+C để dừng server"
        echo ""
        ./spdictionary
    else
        echo "💡 Để chạy ứng dụng sau này, sử dụng lệnh: ./spdictionary"
    fi
else
    echo "❌ Build thất bại!"
    echo "🔍 Kiểm tra lỗi và thử lại..."
    exit 1
fi
