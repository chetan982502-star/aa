@echo off
REM Run Ghidra headless analysis on MetaEditor64.exe

set GHIDRA_HOME=C:\Tools\ghidra_11.2.1_PUBLIC
set TARGET_FILE=C:\Program Files\MetaTrader 5\MetaEditor64.exe
set PROJECT_DIR=%USERPROFILE%\ghidra_projects
set PROJECT_NAME=MetaTrader_Analysis

echo ========================================
echo Ghidra Headless Analysis
echo ========================================
echo Ghidra location: %GHIDRA_HOME%
echo Target file: %TARGET_FILE%
echo Project directory: %PROJECT_DIR%
echo Project name: %PROJECT_NAME%
echo ========================================

REM Create project directory if it doesn't exist
if not exist "%PROJECT_DIR%" mkdir "%PROJECT_DIR%"

REM Run headless analysis
echo.
echo Running Ghidra analysis... This may take several minutes.
echo.

"%GHIDRA_HOME%\support\analyzeHeadless.bat" "%PROJECT_DIR%" "%PROJECT_NAME%" -import "%TARGET_FILE%" -analyze

echo.
echo ========================================
echo Analysis complete!
echo ========================================
echo.
echo To view results, open Ghidra GUI and open the project:
echo Project Directory: %PROJECT_DIR%
echo Project Name: %PROJECT_NAME%
echo.
pause
