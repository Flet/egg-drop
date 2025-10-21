@echo off
REM Build script for creating distributable Love2D game (Windows)
REM Generates a .love file that can be run with Love2D

setlocal

set BUILD_DIR=build
set GAME_NAME=lovely
set VERSION=1.0.0

echo ========================================
echo Building %GAME_NAME% v%VERSION%
echo ========================================

REM Create build directory
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"

REM Clean previous builds
if exist "%BUILD_DIR%\%GAME_NAME%.love" del "%BUILD_DIR%\%GAME_NAME%.love"

echo Creating .love file...

REM Create temporary file list
dir /b /s /a-d *.lua *.glsl *.png *.jpg *.wav *.mp3 *.ogg > temp_files.txt 2>nul

REM Use PowerShell to create zip (rename to .love)
powershell -command "Compress-Archive -Path conf.lua,main.lua,src,lib,levels,assets -DestinationPath %BUILD_DIR%\%GAME_NAME%.zip -Force" 2>nul

if exist "%BUILD_DIR%\%GAME_NAME%.zip" (
    move /y "%BUILD_DIR%\%GAME_NAME%.zip" "%BUILD_DIR%\%GAME_NAME%.love" >nul
)

REM Clean up
if exist temp_files.txt del temp_files.txt

echo ========================================
echo Build complete!
echo Output: %BUILD_DIR%\%GAME_NAME%.love
echo.
echo To run: love %BUILD_DIR%\%GAME_NAME%.love
echo Or double-click the .love file if Love2D is associated
echo ========================================

endlocal
