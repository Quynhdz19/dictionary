# 📚 Từ Điển Tiếng Anh - Học Sinh

Một web từ điển tiếng Anh đẹp mắt và thân thiện với học sinh, được xây dựng với backend C++ và frontend HTML/CSS thuần.

## ✨ Tính năng

- 🔍 **Tìm kiếm từ vựng** - Tìm kiếm nhanh chóng các từ tiếng Anh
- 🎲 **Từ ngẫu nhiên** - Học từ mới một cách thú vị
- 📖 **Xem tất cả từ** - Khám phá toàn bộ bộ từ vựng
- 🔊 **Phát âm chuẩn** - Hiển thị phiên âm IPA
- 💡 **Ví dụ thực tế** - Cả tiếng Anh và tiếng Việt
- 📱 **Responsive design** - Hoạt động tốt trên mọi thiết bị
- 🎨 **Giao diện đẹp mắt** - Thiết kế thân thiện với học sinh

## 🏗️ Kiến trúc

- **Backend**: C++ với thư viện Crow (HTTP server)
- **Frontend**: HTML5, CSS3, JavaScript thuần
- **Dữ liệu**: JSON file
- **API**: RESTful API với CORS support

## 📋 Yêu cầu hệ thống

- **Hệ điều hành**: Linux, macOS, Windows
- **Compiler**: GCC 7+ hoặc Clang 5+
- **Thư viện**: OpenSSL, zlib
- **Build tools**: Make

## 🚀 Cài đặt và chạy

### 1. Clone repository
```bash
git clone <repository-url>
cd spdictionary
```

### 2. Cài đặt dependencies (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install build-essential libssl-dev zlib1g-dev curl
```

### 3. Cài đặt dependencies (macOS)
```bash
brew install openssl zlib
```

### 4. Build project
```bash
# Tải dependencies và build
make deps
make all

# Hoặc build và chạy ngay
make dev
```

### 5. Chạy ứng dụng
```bash
./spdictionary
```

Ứng dụng sẽ chạy tại: http://localhost:8080

## 📁 Cấu trúc project

```
spdictionary/
├── main.cpp          # Backend C++ API
├── data.json         # Dữ liệu từ điển
├── index.html        # Frontend HTML
├── style.css         # CSS styles
├── script.js         # JavaScript logic
├── CMakeLists.txt    # CMake build file
├── Makefile          # Make build file
└── README.md         # Hướng dẫn này
```

## 🔧 API Endpoints

### GET `/`
- **Mô tả**: Trang chủ từ điển
- **Response**: HTML page

### GET `/api/words`
- **Mô tả**: Lấy tất cả từ vựng
- **Response**: JSON array của từ vựng

### GET `/api/search/{query}`
- **Mô tả**: Tìm kiếm từ vựng
- **Parameters**: `query` - từ khóa tìm kiếm
- **Response**: JSON array của kết quả tìm kiếm

### GET `/api/random`
- **Mô tả**: Lấy từ vựng ngẫu nhiên
- **Response**: JSON object của từ vựng

## 🎨 Tùy chỉnh

### Thêm từ vựng mới
Chỉnh sửa file `data.json` để thêm từ vựng mới:

```json
{
    "word": "new_word",
    "pronunciation": "/njuː wɜːd/",
    "meaning": "nghĩa của từ",
    "example_en": "English example sentence.",
    "example_vi": "Ví dụ tiếng Việt."
}
```

### Thay đổi giao diện
- **CSS**: Chỉnh sửa `style.css`
- **Layout**: Chỉnh sửa `index.html`
- **Logic**: Chỉnh sửa `script.js`

## 🐛 Troubleshooting

### Lỗi build
```bash
# Kiểm tra dependencies
make clean
make deps
make all
```

### Lỗi runtime
```bash
# Kiểm tra port 8080 có đang được sử dụng
lsof -i :8080

# Chạy với port khác (chỉnh sửa main.cpp)
app.port(8081).multithreaded().run();
```

### Lỗi CORS
Backend đã được cấu hình CORS để cho phép tất cả origins. Nếu cần hạn chế, chỉnh sửa trong `main.cpp`.

## 📚 Học tập

### Cách sử dụng hiệu quả
1. **Tìm kiếm từ cụ thể** - Sử dụng thanh tìm kiếm
2. **Học từ ngẫu nhiên** - Nhấn "Từ ngẫu nhiên" để học từ mới
3. **Xem tất cả từ** - Nhấn "Tất cả từ" để ôn tập
4. **Ghi nhớ ví dụ** - Đọc cả ví dụ tiếng Anh và tiếng Việt

### Tips học tiếng Anh
- Đọc to từ vựng theo phiên âm
- Tạo câu với từ mới học
- Ôn tập định kỳ các từ đã học
- Sử dụng từ trong giao tiếp hàng ngày

## 🤝 Đóng góp

Mọi đóng góp đều được chào đón! Hãy:
1. Fork project
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Tạo Pull Request

## 📄 License

Project này được phát hành dưới MIT License.

## 👨‍💻 Tác giả

Được tạo với ❤️ cho học sinh Việt Nam học tiếng Anh.

---

**Lưu ý**: Đảm bảo rằng tất cả file dữ liệu (`data.json`, `index.html`, `style.css`, `script.js`) đều có trong cùng thư mục với file thực thi khi chạy ứng dụng.
# dictionary
