@echo off
chcp 65001 >nul
echo 🚀 Bắt đầu build Từ Điển Tiếng Anh trên Windows...
echo.

REM Kiểm tra xem có MinGW không
where g++ >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Không tìm thấy g++. Vui lòng cài đặt MinGW-w64 hoặc Visual Studio
    echo.
    echo 📥 Hướng dẫn cài đặt:
    echo    1. Tải MSYS2: https://www.msys2.org/
    echo    2. Cài đặt MinGW-w64: pacman -S mingw-w64-x86_64-gcc
    echo    3. Thêm C:\msys64\mingw64\bin vào PATH
    echo.
    echo Hoặc sử dụng Visual Studio Community (khuyến nghị)
    echo.
    pause
    exit /b 1
)

echo ✅ Tìm thấy g++ compiler
echo.

REM Kiểm tra xem có make không
where mingw32-make >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Không tìm thấy mingw32-make. Vui lòng cài đặt make
    echo.
    echo 📥 Cài đặt: pacman -S mingw-w64-x86_64-make
    echo.
    pause
    exit /b 1
)

echo ✅ Tìm thấy make
echo.

REM Clean build cũ
echo 🧹 Dọn dẹp build cũ...
if exist main.o del main.o
if exist spdictionary.exe del spdictionary.exe

REM Tải dependencies nếu chưa có
if not exist crow.h (
    echo 📥 Tải Crow header...
    powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/CrowCpp/Crow/master/include/crow.h' -OutFile 'crow.h'"
)

if not exist json.hpp (
    echo 📥 Tải nlohmann/json header...
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/nlohmann/json/releases/download/v3.11.2/json.hpp' -OutFile 'json.hpp'"
)

echo ✅ Dependencies đã sẵn sàng
echo.

REM Build project
echo 🔨 Build project...
g++ -std=c++17 -Wall -Wextra -O2 -c main.cpp -o main.o
if %errorlevel% neq 0 (
    echo ❌ Lỗi khi compile main.cpp
    pause
    exit /b 1
)

g++ main.o -o spdictionary.exe -lpthread
if %errorlevel% neq 0 (
    echo ❌ Lỗi khi link
    pause
    exit /b 1
)

echo ✅ Build thành công!
echo.

REM Kiểm tra file thực thi
if not exist spdictionary.exe (
    echo ❌ Không tìm thấy file spdictionary.exe
    pause
    exit /b 1
)

echo 🎉 Từ Điển Tiếng Anh đã sẵn sàng!
echo 🌐 Truy cập: http://localhost:8080
echo.
echo 📱 Tính năng:
echo    - Tìm kiếm từ vựng
echo    - Học từ ngẫu nhiên
echo    - Xem tất cả từ
echo    - Giao diện đẹp mắt cho học sinh
echo.

REM Hỏi người dùng có muốn chạy ngay không
set /p choice="🚀 Bạn có muốn chạy ứng dụng ngay bây giờ? (y/n): "
if /i "%choice%"=="y" (
    echo.
    echo 🚀 Khởi động server...
    echo 💡 Nhấn Ctrl+C để dừng server
    echo.
    spdictionary.exe
) else (
    echo.
    echo 💡 Để chạy ứng dụng sau này, sử dụng lệnh: spdictionary.exe
    echo.
    pause
)
