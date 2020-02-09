cmake_minimum_required(VERSION 3.14)
project(foo)

add_subdirectory(lib)

add_executable(foo main.cpp)
target_link_libraries(foo hello)

