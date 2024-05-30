cmake_minimum_required(VERSION 3.25)

project(CppInterOpExtra LANGUAGES CXX)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

# Turn on using VS solution folders
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH FALSE)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

find_package(LLVM REQUIRED CONFIG)
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

find_package(Clang REQUIRED CONFIG)
message(STATUS "Found Clang ${Clang_PACKAGE_VERSION}")
message(STATUS "Using ClangConfig.cmake in: ${Clang_DIR}")

find_package(CppInterOp REQUIRED CONFIG)
message(STATUS "Using CppInterOpConfig.cmake in: ${CppInterOp_DIR}")

add_library(CppInterOpExtra SHARED)
add_subdirectory(lib)
add_subdirectory(include)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")

target_include_directories(CppInterOpExtra PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${LLVM_INCLUDE_DIRS}>
    $<BUILD_INTERFACE:${Clang_INCLUDE_DIRS}>
    $<INSTALL_INTERFACE:include>)
    
target_compile_features(CppInterOpExtra PRIVATE cxx_std_17)

if (WIN32)
    message(STATUS "Windows detected, adding `_CINDEX_LIB_` definition...")
    target_compile_definitions(CppInterOpExtra PUBLIC "_CINDEX_LIB_")
endif(WIN32)

target_link_libraries(CppInterOpExtra LINK_PUBLIC LLVM clang-cpp CppInterOp::CppInterOp)

# Install CompilationDatabase
set_target_properties(CppInterOpExtra PROPERTIES EXPORT_COMPILE_COMMANDS true)
set(ccmds_json ${CMAKE_CURRENT_BINARY_DIR}/compile_commands.json)
if(EXISTS ${ccmds_json})
    message(STATUS "Found CompilationDatabase File: " ${ccmds_json})
    install(FILES ${ccmds_json} DESTINATION share)
endif()

# Install Binaries
install(TARGETS CppInterOpExtra
        EXPORT CppInterOpExtraTargets
        RUNTIME DESTINATION lib
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib/static
        INCLUDES DESTINATION include/clang-c)

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/clang-c/ DESTINATION include/clang-c
        FILES_MATCHING PATTERN "*.h")

# Install CMake targets
install(EXPORT CppInterOpExtraTargets
        NAMESPACE CppInterOpExtra::
        FILE CppInterOpExtraConfig.cmake
        DESTINATION lib/cmake/CppInterOpExtra)