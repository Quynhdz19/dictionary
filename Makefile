CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra -O2
# Detect OS and set appropriate flags
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    # macOS
    LDFLAGS = -lpthread -lz
else
    # Linux
    LDFLAGS = -lpthread -lssl -lcrypto -lz
endif

# Thư viện Crow (single header)
CROW_HEADER = https://raw.githubusercontent.com/CrowCpp/Crow/master/include/crow.h

# Thư viện nlohmann/json (single header)
JSON_HEADER = https://github.com/nlohmann/json/releases/download/v3.11.2/json.hpp

# Tên file thực thi
TARGET = spdictionary

# Source files
SOURCES = main.cpp

# Object files
OBJECTS = $(SOURCES:.cpp=.o)

# Default target
all: $(TARGET)

# Download headers if they don't exist
crow.h:
	@echo "Downloading Crow header..."
	@curl -L -o crow.h $(CROW_HEADER)

json.hpp:
	@echo "Downloading nlohmann/json header..."
	@curl -L -o json.hpp $(JSON_HEADER)

# Build target
$(TARGET): $(OBJECTS) crow.h json.hpp
	$(CXX) $(OBJECTS) -o $(TARGET) $(LDFLAGS)

# Compile source files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean build files
clean:
	rm -f $(OBJECTS) $(TARGET)

# Install dependencies
deps: crow.h json.hpp

# Run the application
run: $(TARGET)
	./$(TARGET)

# Build and run
dev: clean all run

# Help
help:
	@echo "Available targets:"
	@echo "  all     - Build the application"
	@echo "  clean   - Clean build files"
	@echo "  deps    - Download dependencies"
	@echo "  run     - Build and run the application"
	@echo "  dev     - Clean, build and run"
	@echo "  help    - Show this help message"

.PHONY: all clean deps run dev help
