add_library(hello STATIC IMPORTED GLOBAL)
set_target_properties(hello PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/libhello.a")
set_target_properties(hello PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_LIST_DIR}/include")

# target_include_directories(hello INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/include")
# set_property(TARGET hello APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_SOURCE_DIR}/include")
