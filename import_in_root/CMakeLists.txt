cmake_minimum_required(VERSION 3.14)
project(foo)

add_library(hello STATIC IMPORTED)
set_target_properties(hello PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/libhello.a")
set_target_properties(hello PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include")

add_executable(foo main.cpp)
target_link_libraries(foo hello)

