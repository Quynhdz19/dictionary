# 🚀 Script Build Từ Điển Tiếng Anh trên Windows (PowerShell)
# Tác giả: AI Assistant
# Ngày tạo: $(Get-Date)

Write-Host "🚀 Bắt đầu build Từ Điển Tiếng Anh trên Windows..." -ForegroundColor Green
Write-Host ""

# Kiểm tra xem có g++ không
try {
    $gppPath = Get-Command g++ -ErrorAction Stop
    Write-Host "✅ Tìm thấy g++ compiler tại: $($gppPath.Source)" -ForegroundColor Green
} catch {
    Write-Host "❌ Không tìm thấy g++. Vui lòng cài đặt MinGW-w64 hoặc Visual Studio" -ForegroundColor Red
    Write-Host ""
    Write-Host "📥 Hướng dẫn cài đặt:" -ForegroundColor Yellow
    Write-Host "   1. Tải MSYS2: https://www.msys2.org/" -ForegroundColor Cyan
    Write-Host "   2. Cài đặt MinGW-w64: pacman -S mingw-w64-x86_64-gcc" -ForegroundColor Cyan
    Write-Host "   3. Thêm C:\msys64\mingw64\bin vào PATH" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Hoặc sử dụng Visual Studio Community (khuyến nghị)" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Nhấn Enter để thoát"
    exit 1
}

# Kiểm tra xem có mingw32-make không
try {
    $makePath = Get-Command mingw32-make -ErrorAction Stop
    Write-Host "✅ Tìm thấy mingw32-make tại: $($makePath.Source)" -ForegroundColor Green
} catch {
    Write-Host "❌ Không tìm thấy mingw32-make. Vui lòng cài đặt make" -ForegroundColor Red
    Write-Host ""
    Write-Host "📥 Cài đặt: pacman -S mingw-w64-x86_64-make" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Nhấn Enter để thoát"
    exit 1
}

Write-Host ""

# Clean build cũ
Write-Host "🧹 Dọn dẹp build cũ..." -ForegroundColor Yellow
if (Test-Path "main.o") { Remove-Item "main.o" -Force }
if (Test-Path "spdictionary.exe") { Remove-Item "spdictionary.exe" -Force }

# Tải dependencies nếu chưa có
if (-not (Test-Path "crow.h")) {
    Write-Host "📥 Tải Crow header..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CrowCpp/Crow/master/include/crow.h" -OutFile "crow.h"
        Write-Host "✅ Đã tải crow.h" -ForegroundColor Green
    } catch {
        Write-Host "❌ Không thể tải crow.h" -ForegroundColor Red
    }
}

if (-not (Test-Path "json.hpp")) {
    Write-Host "📥 Tải nlohmann/json header..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri "https://github.com/nlohmann/json/releases/download/v3.11.2/json.hpp" -OutFile "json.hpp"
        Write-Host "✅ Đã tải json.hpp" -ForegroundColor Green
    } catch {
        Write-Host "❌ Không thể tải json.hpp" -ForegroundColor Red
    }
}

Write-Host "✅ Dependencies đã sẵn sàng" -ForegroundColor Green
Write-Host ""

# Build project
Write-Host "🔨 Build project..." -ForegroundColor Yellow

# Compile main.cpp
Write-Host "   Compiling main.cpp..." -ForegroundColor Cyan
$compileResult = & g++ -std=c++17 -Wall -Wextra -O2 -c main.cpp -o main.o 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Lỗi khi compile main.cpp:" -ForegroundColor Red
    Write-Host $compileResult -ForegroundColor Red
    Read-Host "Nhấn Enter để thoát"
    exit 1
}
Write-Host "   ✅ Compile thành công" -ForegroundColor Green

# Link
Write-Host "   Linking..." -ForegroundColor Cyan
$linkResult = & g++ main.o -o spdictionary.exe -lpthread 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Lỗi khi link:" -ForegroundColor Red
    Write-Host $linkResult -ForegroundColor Red
    Read-Host "Nhấn Enter để thoát"
    exit 1
}
Write-Host "   ✅ Link thành công" -ForegroundColor Green

Write-Host "✅ Build thành công!" -ForegroundColor Green
Write-Host ""

# Kiểm tra file thực thi
if (-not (Test-Path "spdictionary.exe")) {
    Write-Host "❌ Không tìm thấy file spdictionary.exe" -ForegroundColor Red
    Read-Host "Nhấn Enter để thoát"
    exit 1
}

Write-Host "🎉 Từ Điển Tiếng Anh đã sẵn sàng!" -ForegroundColor Green
Write-Host "🌐 Truy cập: http://localhost:8080" -ForegroundColor Cyan
Write-Host ""
Write-Host "📱 Tính năng:" -ForegroundColor Yellow
Write-Host "   - Tìm kiếm từ vựng" -ForegroundColor White
Write-Host "   - Học từ ngẫu nhiên" -ForegroundColor White
Write-Host "   - Xem tất cả từ" -ForegroundColor White
Write-Host "   - Giao diện đẹp mắt cho học sinh" -ForegroundColor White
Write-Host ""

# Hỏi người dùng có muốn chạy ngay không
$choice = Read-Host "🚀 Bạn có muốn chạy ứng dụng ngay bây giờ? (y/n)"
if ($choice -eq "y" -or $choice -eq "Y") {
    Write-Host ""
    Write-Host "🚀 Khởi động server..." -ForegroundColor Green
    Write-Host "💡 Nhấn Ctrl+C để dừng server" -ForegroundColor Yellow
    Write-Host ""
    
    # Chạy ứng dụng
    try {
        & .\spdictionary.exe
    } catch {
        Write-Host "❌ Lỗi khi chạy ứng dụng: $_" -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "💡 Để chạy ứng dụng sau này, sử dụng lệnh: .\spdictionary.exe" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Nhấn Enter để thoát"
}
