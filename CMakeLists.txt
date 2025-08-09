cmake_minimum_required(VERSION 3.16)
project(SpDictionary)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find required packages
find_package(PkgConfig REQUIRED)
find_package(Threads REQUIRED)

# Include directories
include_directories(${CMAKE_SOURCE_DIR})

# Add executable
add_executable(spdictionary main.cpp)

# Link libraries
target_link_libraries(spdictionary 
    ${CMAKE_THREAD_LIBS_INIT}
    ssl
    crypto
    z
)

# Compiler flags
target_compile_options(spdictionary PRIVATE -Wall -Wextra)

# Copy data files to build directory
configure_file(${CMAKE_SOURCE_DIR}/data.json ${CMAKE_BINARY_DIR}/data.json COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/index.html ${CMAKE_BINARY_DIR}/index.html COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/style.css ${CMAKE_BINARY_DIR}/style.css COPYONLY)
configure_file(${CMAKE_SOURCE_DIR}/script.js ${CMAKE_BINARY_DIR}/script.js COPYONLY)

# Install target
install(TARGETS spdictionary DESTINATION bin)
install(FILES data.json index.html style.css script.js DESTINATION share/spdictionary)
