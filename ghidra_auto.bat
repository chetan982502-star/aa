@echo off
REM Run Ghidra headless analysis on MetaEditor64.exe

echo ========================================
echo Ghidra Headless Analysis - Checking System
echo ========================================
echo.

set GHIDRA_HOME=C:\Tools\ghidra_11.2.1_PUBLIC
set TARGET_FILE=C:\Program Files\MetaTrader 5\MetaEditor64.exe
set PROJECT_DIR=%USERPROFILE%\ghidra_projects
set PROJECT_NAME=MetaTrader_Analysis

REM Check if Ghidra exists
echo [1/5] Checking Ghidra installation...
if not exist "%GHIDRA_HOME%" (
    echo ERROR: Ghidra not found at: %GHIDRA_HOME%
    echo Please verify the path and try again.
    echo.
    pause
    exit /b 1
)
if not exist "%GHIDRA_HOME%\support\analyzeHeadless.bat" (
    echo ERROR: analyzeHeadless.bat not found in: %GHIDRA_HOME%\support\
    echo Please verify your Ghidra installation.
    echo.
    pause
    exit /b 1
)
echo    FOUND: %GHIDRA_HOME%
echo.

REM Check if target file exists
echo [2/5] Checking target file...
if not exist "%TARGET_FILE%" (
    echo ERROR: Target file not found at: %TARGET_FILE%
    echo Please verify the path and try again.
    echo.
    pause
    exit /b 1
)
echo    FOUND: %TARGET_FILE%
echo.

REM Check Java
echo [3/5] Checking Java installation...
java -version 2>&1 | find "version" >nul
if errorlevel 1 (
    echo ERROR: Java not found in PATH
    echo Ghidra requires Java 17 or later
    echo Please install Java and try again.
    echo.
    pause
    exit /b 1
)
java -version 2>&1 | findstr /C:"version"
echo.

REM Create project directory
echo [4/5] Creating project directory...
if not exist "%PROJECT_DIR%" (
    mkdir "%PROJECT_DIR%"
    echo    CREATED: %PROJECT_DIR%
) else (
    echo    EXISTS: %PROJECT_DIR%
)
echo.

REM Run headless analysis
echo [5/5] Running Ghidra analysis...
echo ========================================
echo This may take several minutes...
echo Target: %TARGET_FILE%
echo Project: %PROJECT_DIR%\%PROJECT_NAME%
echo ========================================
echo.

cd /d "%GHIDRA_HOME%\support"
call analyzeHeadless.bat "%PROJECT_DIR%" "%PROJECT_NAME%" -import "%TARGET_FILE%" -analyze

if errorlevel 1 (
    echo.
    echo ========================================
    echo ERROR: Analysis failed!
    echo ========================================
    echo Check the error messages above.
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Analysis Complete - SUCCESS!
echo ========================================
echo.
echo To view results:
echo 1. Open Ghidra GUI
echo 2. File -^> Open Project
echo 3. Browse to: %PROJECT_DIR%
echo 4. Open project: %PROJECT_NAME%
echo 5. Double-click MetaEditor64.exe in the project
echo.
pause
