@echo off
REM This script Configures, Cleans, and Builds libbson and libmongoc using CMake

REM Clean the previous build and install directories
if exist _build (
    rmdir /s /q _build
)

if exist _install (
    rmdir /s /q _install
)

cmake -S . -B _build ^
   -D ENABLE_EXTRA_ALIGNMENT=OFF ^
   -D ENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF ^
   -D CMAKE_BUILD_TYPE=RelWithDebInfo ^
   -D BUILD_VERSION="1.29.0" ^
   -D ENABLE_MONGOC=ON

REM Build the project
cmake --build _build --config RelWithDebInfo --parallel

REM Installing the Built Results
REN _build libbson
cmake --install "_build" --prefix "_install" --config RelWithDebInfo   