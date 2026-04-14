cmake_minimum_required(VERSION 4.3)

project(GPU-Project VERSION 1.0 LANGUAGES CUDA)

include_directories(include)

file(GLOB SOURCES "src/*.cu")

add_executable(${PROJECT_NAME} ${SOURCES})

if(MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W4)
else()
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra -Werror -pedantic -o2)
endif()
