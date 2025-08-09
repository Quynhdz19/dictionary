#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <sstream>
#include <map>
#include <algorithm>
#include <cstring>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <thread>
#include <mutex>
#include "json.hpp"

// Cấu trúc từ điển
struct DictionaryEntry {
    std::string word;
    std::string pronunciation;
    std::string meaning;
    std::string example_en;
    std::string example_vi;
};

// Global variables
std::vector<DictionaryEntry> dictionary;
std::mutex dictMutex;

// Đọc dữ liệu từ file JSON sử dụng nlohmann/json
std::vector<DictionaryEntry> loadDictionary(const std::string& filename) {
    std::vector<DictionaryEntry> entries;
    
    try {
        std::ifstream file(filename);
        if (!file.is_open()) {
            std::cerr << "Không thể mở file: " << filename << std::endl;
            return entries;
        }
        
        nlohmann::json jsonData;
        file >> jsonData;
        file.close();
        
        for (const auto& item : jsonData) {
            DictionaryEntry entry;
            entry.word = item["word"].get<std::string>();
            entry.pronunciation = item["pronunciation"].get<std::string>();
            entry.meaning = item["meaning"].get<std::string>();
            entry.example_en = item["example_en"].get<std::string>();
            entry.example_vi = item["example_vi"].get<std::string>();
            entries.push_back(entry);
        }
        
        std::cout << "Đã load " << entries.size() << " từ vựng từ file " << filename << std::endl;
    } catch (const std::exception& e) {
        std::cerr << "Lỗi khi đọc file JSON: " << e.what() << std::endl;
    }
    
    return entries;
}

// Tạo JSON response sử dụng nlohmann/json
std::string createJsonResponse(const std::vector<DictionaryEntry>& entries) {
    nlohmann::json jsonArray = nlohmann::json::array();
    
    for (const auto& entry : entries) {
        nlohmann::json item;
        item["word"] = entry.word;
        item["pronunciation"] = entry.pronunciation;
        item["meaning"] = entry.meaning;
        item["example_en"] = entry.example_en;
        item["example_vi"] = entry.example_vi;
        jsonArray.push_back(item);
    }
    
    return jsonArray.dump();
}

// Tìm kiếm từ
std::vector<DictionaryEntry> searchWords(const std::string& query) {
    std::vector<DictionaryEntry> results;
    std::string lowerQuery = query;
    std::transform(lowerQuery.begin(), lowerQuery.end(), lowerQuery.begin(), ::tolower);
    
    for (const auto& entry : dictionary) {
        std::string lowerWord = entry.word;
        std::transform(lowerWord.begin(), lowerWord.end(), lowerWord.begin(), ::tolower);
        
        if (lowerWord.find(lowerQuery) != std::string::npos) {
            results.push_back(entry);
        }
    }
    return results;
}

// Lấy từ ngẫu nhiên
DictionaryEntry getRandomWord() {
    if (dictionary.empty()) {
        return DictionaryEntry{};
    }
    int randomIndex = rand() % dictionary.size();
    return dictionary[randomIndex];
}

// Tạo HTTP response
std::string createHttpResponse(const std::string& content, const std::string& contentType = "text/html") {
    std::stringstream response;
    response << "HTTP/1.1 200 OK\r\n";
    response << "Content-Type: " << contentType << "; charset=utf-8\r\n";
    response << "Access-Control-Allow-Origin: *\r\n";
    response << "Access-Control-Allow-Methods: GET, POST, OPTIONS\r\n";
    response << "Access-Control-Allow-Headers: Content-Type\r\n";
    response << "Content-Length: " << content.length() << "\r\n";
    response << "\r\n";
    response << content;
    return response.str();
}

// Xử lý request
std::string handleRequest(const std::string& request) {
    std::istringstream requestStream(request);
    std::string method, path, version;
    requestStream >> method >> path >> version;
    
    std::cout << "Request: " << method << " " << path << std::endl;
    
    if (path == "/") {
        // Trang chủ
        std::ifstream file("index.html");
        if (file.is_open()) {
            std::string content((std::istreambuf_iterator<char>(file)),
                               std::istreambuf_iterator<char>());
            file.close();
            return createHttpResponse(content, "text/html");
        } else {
            return createHttpResponse("<h1>Không thể mở file index.html</h1>");
        }
    } else if (path == "/style.css") {
        // CSS file
        std::ifstream file("style.css");
        if (file.is_open()) {
            std::string content((std::istreambuf_iterator<char>(file)),
                               std::istreambuf_iterator<char>());
            file.close();
            return createHttpResponse(content, "text/css");
        }
    } else if (path == "/script.js") {
        // JavaScript file
        std::ifstream file("script.js");
        if (file.is_open()) {
            std::string content((std::istreambuf_iterator<char>(file)),
                               std::istreambuf_iterator<char>());
            file.close();
            return createHttpResponse(content, "application/javascript");
        }
    } else if (path == "/api/words") {
        // API lấy tất cả từ
        std::lock_guard<std::mutex> lock(dictMutex);
        std::string jsonResponse = createJsonResponse(dictionary);
        return createHttpResponse(jsonResponse, "application/json");
    } else if (path.find("/api/search/") == 0) {
        // API tìm kiếm
        std::string query = path.substr(12); // Bỏ "/api/search/"
        std::lock_guard<std::mutex> lock(dictMutex);
        auto results = searchWords(query);
        std::string jsonResponse = createJsonResponse(results);
        return createHttpResponse(jsonResponse, "application/json");
    } else if (path == "/api/random") {
        // API từ ngẫu nhiên
        std::lock_guard<std::mutex> lock(dictMutex);
        auto randomWord = getRandomWord();
        if (!randomWord.word.empty()) {
            std::vector<DictionaryEntry> singleWord = {randomWord};
            std::string jsonResponse = createJsonResponse(singleWord);
            return createHttpResponse(jsonResponse, "application/json");
        } else {
            return createHttpResponse("{}", "application/json");
        }
    }
    
    // 404 Not Found
    return "HTTP/1.1 404 Not Found\r\nContent-Type: text/html\r\n\r\n<h1>404 - Không tìm thấy</h1>";
}

// Xử lý client connection
void handleClient(int clientSocket) {
    char buffer[4096];
    int bytesRead = recv(clientSocket, buffer, sizeof(buffer) - 1, 0);
    
    if (bytesRead > 0) {
        buffer[bytesRead] = '\0';
        std::string request(buffer);
        std::string response = handleRequest(request);
        
        send(clientSocket, response.c_str(), response.length(), 0);
    }
    
    close(clientSocket);
}

int main() {
    // Load dữ liệu từ điển
    dictionary = loadDictionary("data.json");
    std::cout << "Đã load " << dictionary.size() << " từ vựng từ file data.json" << std::endl;
    
    // Khởi tạo random seed
    srand(time(nullptr));
    
    // Tạo socket
    int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverSocket == -1) {
        std::cerr << "Không thể tạo socket" << std::endl;
        return 1;
    }
    
    // Cấu hình socket
    int opt = 1;
    setsockopt(serverSocket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
    
    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = INADDR_ANY;
    serverAddr.sin_port = htons(8080);
    
    // Bind socket
    if (bind(serverSocket, (struct sockaddr*)&serverAddr, sizeof(serverAddr)) < 0) {
        std::cerr << "Không thể bind socket" << std::endl;
        return 1;
    }
    
    // Listen
    if (listen(serverSocket, 10) < 0) {
        std::cerr << "Không thể listen" << std::endl;
        return 1;
    }
    
    std::cout << "🚀 Từ Điển API đang chạy tại: http://localhost:8080" << std::endl;
    std::cout << "💡 Nhấn Ctrl+C để dừng server" << std::endl;
    
    // Accept connections
    while (true) {
        struct sockaddr_in clientAddr;
        socklen_t clientLen = sizeof(clientAddr);
        int clientSocket = accept(serverSocket, (struct sockaddr*)&clientAddr, &clientLen);
        
        if (clientSocket < 0) {
            std::cerr << "Không thể accept connection" << std::endl;
            continue;
        }
        
        // Xử lý client trong thread riêng
        std::thread clientThread(handleClient, clientSocket);
        clientThread.detach();
    }
    
    close(serverSocket);
    return 0;
}
