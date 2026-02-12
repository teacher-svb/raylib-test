cmake_minimum_required(VERSION 3.10)
project(my_raylib_app)

set(CMAKE_CXX_STANDARD 17)

# Point to your vendored raylib
add_subdirectory(external/raylib)

add_executable(${PROJECT_NAME} src/main.cpp)

# Link against the target defined in the raylib subdirectory
target_link_libraries(${PROJECT_NAME} raylib)

# Ensure headers are found
target_include_directories(${PROJECT_NAME} PRIVATE external/raylib/src)