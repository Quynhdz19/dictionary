# 🚀 Hướng Dẫn Chạy Từ Điển Tiếng Anh Trên Windows

## 📋 Yêu Cầu Hệ Thống

- Windows 10/11 (64-bit)
- Visual Studio 2019/2022 hoặc MinGW-w64
- Git (để clone repository)

## 🔧 Cài Đặt Dependencies

### Phương Pháp 1: Sử Dụng Visual Studio (Khuyến Nghị)

1. **Tải Visual Studio Community (Miễn Phí)**
   - Truy cập: https://visualstudio.microsoft.com/vs/community/
   - Tải và cài đặt Visual Studio Community 2022
   - Trong quá trình cài đặt, chọn workload "Desktop development with C++"

2. **Cài Đặt Windows SDK**
   - Visual Studio sẽ tự động cài đặt Windows SDK
   - Nếu cần, có thể cài đặt riêng từ Microsoft Store

### Phương Pháp 2: Sử Dụng MinGW-w64

1. **Tải MSYS2**
   - Truy cập: https://www.msys2.org/
   - Tải và cài đặt MSYS2

2. **Cài Đặt MinGW-w64**
   ```bash
   # Mở MSYS2 terminal
   pacman -S mingw-w64-x86_64-gcc
   pacman -S mingw-w64-x86_64-make
   pacman -S mingw-w64-x86_64-cmake
   ```

3. **Thêm vào PATH**
   - Thêm `C:\msys64\mingw64\bin` vào biến môi trường PATH

## 📥 Tải Dự Án

1. **Clone Repository**
   ```bash
   git clone https://github.com/your-username/spdictionary.git
   cd spdictionary
   ```

2. **Hoặc Tải ZIP**
   - Tải file ZIP từ GitHub
   - Giải nén vào thư mục mong muốn

## 🏗️ Build Project

### Sử Dụng Visual Studio

1. **Mở Project**
   - Mở Visual Studio
   - Chọn "Open a project or solution"
   - Chọn file `CMakeLists.txt` trong thư mục dự án

2. **Build Project**
   - Nhấn `Ctrl+Shift+B` hoặc chọn Build → Build Solution
   - Chờ quá trình build hoàn tất

3. **Chạy Project**
   - Nhấn `F5` để chạy với debug
   - Hoặc `Ctrl+F5` để chạy không debug

### Sử Dụng Command Line (MinGW)

1. **Tạo Build Directory**
   ```cmd
   mkdir build
   cd build
   ```

2. **Build với CMake**
   ```cmd
   cmake .. -G "MinGW Makefiles"
   mingw32-make
   ```

3. **Hoặc Build với Makefile**
   ```cmd
   mingw32-make all
   ```

## 🚀 Chạy Ứng Dụng

### Chạy Trực Tiếp

1. **Mở Command Prompt**
   - Nhấn `Win+R`, gõ `cmd`, nhấn Enter

2. **Di Chuyển Đến Thư Mục Dự Án**
   ```cmd
   cd C:\path\to\spdictionary
   ```

3. **Chạy Ứng Dụng**
   ```cmd
   spdictionary.exe
   ```

### Chạy Từ Visual Studio

1. **Nhấn F5** để chạy với debug
2. **Hoặc Ctrl+F5** để chạy không debug

## 🌐 Truy Cập Ứng Dụng

1. **Mở Trình Duyệt Web**
   - Chrome, Firefox, Edge, hoặc bất kỳ trình duyệt nào

2. **Truy Cập Địa Chỉ**
   ```
   http://localhost:8080
   ```

3. **Tính Năng Có Sẵn**
   - 🔍 Tìm kiếm từ vựng
   - 🎲 Học từ ngẫu nhiên
   - 📚 Xem tất cả từ vựng
   - 💡 Giao diện thân thiện với học sinh

## 🛠️ Xử Lý Lỗi Thường Gặp

### Lỗi "Port 8080 đã được sử dụng"

1. **Kiểm tra port đang sử dụng**
   ```cmd
   netstat -ano | findstr :8080
   ```

2. **Kết thúc process**
   ```cmd
   taskkill /PID <PID> /F
   ```

3. **Hoặc thay đổi port trong code**
   - Mở file `main.cpp`
   - Thay đổi `htons(8080)` thành port khác

### Lỗi "Không thể bind socket"

1. **Chạy với quyền Administrator**
   - Chuột phải vào Command Prompt
   - Chọn "Run as administrator"

2. **Kiểm tra Windows Defender Firewall**
   - Cho phép ứng dụng qua firewall

### Lỗi "Không thể mở file data.json"

1. **Kiểm tra đường dẫn file**
   - Đảm bảo `data.json` nằm cùng thư mục với `spdictionary.exe`

2. **Kiểm tra quyền truy cập**
   - Chuột phải vào file → Properties
   - Đảm bảo không bị chặn

## 📁 Cấu Trúc Thư Mục

```
spdictionary/
├── main.cpp              # Source code chính
├── CMakeLists.txt        # Cấu hình CMake
├── Makefile              # Makefile cho MinGW
├── data.json             # Dữ liệu từ vựng
├── index.html            # Giao diện web
├── style.css             # CSS styling
├── script.js             # JavaScript logic
├── build/                # Thư mục build (tự tạo)
└── spdictionary.exe      # File thực thi (sau khi build)
```

## 🔄 Cập Nhật Dữ Liệu

1. **Thêm từ mới vào `data.json`**
   ```json
   {
       "word": "new_word",
       "pronunciation": "/njuː wɜːd/",
       "meaning": "nghĩa tiếng Việt",
       "example_en": "English example",
       "example_vi": "Ví dụ tiếng Việt"
   }
   ```

2. **Build lại project**
   ```cmd
   mingw32-make clean
   mingw32-make all
   ```

## 📞 Hỗ Trợ

Nếu gặp vấn đề:

1. **Kiểm tra log lỗi** trong terminal
2. **Đảm bảo tất cả dependencies đã được cài đặt**
3. **Kiểm tra quyền truy cập file và thư mục**
4. **Đảm bảo port 8080 không bị sử dụng bởi ứng dụng khác**

## 🎯 Lưu Ý Quan Trọng

- **Luôn chạy với quyền Administrator** nếu gặp lỗi bind socket
- **Kiểm tra Windows Defender Firewall** nếu không thể truy cập từ trình duyệt
- **Đảm bảo tất cả file trong cùng thư mục** để tránh lỗi đường dẫn
- **Sử dụng Visual Studio** nếu gặp khó khăn với MinGW

---

🎉 **Chúc bạn thành công!** Nếu cần hỗ trợ thêm, hãy tạo issue trên GitHub.
