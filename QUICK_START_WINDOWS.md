# ⚡ Hướng Dẫn Nhanh - Windows

## 🚀 Chạy Nhanh (3 Bước)

### 1️⃣ Tải Dependencies
- **Visual Studio Community** (Khuyến nghị): https://visualstudio.microsoft.com/vs/community/
- Hoặc **MSYS2 + MinGW**: https://www.msys2.org/

### 2️⃣ Build Project
```cmd
# Mở Command Prompt với quyền Administrator
cd C:\path\to\spdictionary

# Chạy script build
build_windows.bat
```

### 3️⃣ Chạy Ứng Dụng
```cmd
spdictionary.exe
```

## 🌐 Truy Cập
Mở trình duyệt và truy cập: **http://localhost:8080**

---

## 🔧 Nếu Gặp Lỗi

### ❌ "Port 8080 đã được sử dụng"
```cmd
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### ❌ "Không thể bind socket"
- Chạy Command Prompt với quyền **Administrator**
- Kiểm tra Windows Defender Firewall

### ❌ "Không tìm thấy g++"
- Cài đặt Visual Studio với workload "Desktop development with C++"
- Hoặc cài đặt MinGW-w64 qua MSYS2

---

## 📱 Tính Năng
- 🔍 **Tìm kiếm từ vựng** - Tìm kiếm nhanh chóng
- 🎲 **Học từ ngẫu nhiên** - Học từ mới mỗi ngày  
- 📚 **Xem tất cả từ** - Danh sách đầy đủ từ vựng
- 💡 **Giao diện đẹp** - Thân thiện với học sinh

---

## 📞 Hỗ Trợ Nhanh
- **Lỗi build**: Kiểm tra Visual Studio/MinGW đã cài đặt
- **Lỗi chạy**: Chạy với quyền Administrator
- **Lỗi truy cập**: Kiểm tra firewall và port 8080

---

🎯 **Mẹo**: Sử dụng Visual Studio Community để dễ dàng nhất!
