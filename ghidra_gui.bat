@echo off
REM Launch Ghidra GUI and open MetaEditor64.exe for analysis

echo ========================================
echo Ghidra Launcher - Checking System
echo ========================================
echo.

set GHIDRA_HOME=C:\Tools\ghidra_11.2.1_PUBLIC
set TARGET_FILE=C:\Program Files\MetaTrader 5\MetaEditor64.exe

REM Check if Ghidra exists
echo [1/4] Checking Ghidra installation...
if not exist "%GHIDRA_HOME%" (
    echo ERROR: Ghidra not found at: %GHIDRA_HOME%
    echo Please verify the path and try again.
    echo.
    pause
    exit /b 1
)
REM Skipping specific check - will try multiple locations later
echo    FOUND: %GHIDRA_HOME%
echo.

REM Check if target file exists
echo [2/4] Checking target file...
if not exist "%TARGET_FILE%" (
    echo WARNING: Target file not found at: %TARGET_FILE%
    echo You will need to manually import the file in Ghidra.
    echo.
) else (
    echo    FOUND: %TARGET_FILE%
    echo.
)

REM Check Java
echo [3/4] Checking Java installation...
java -version 2>&1 | find "version" >nul
if errorlevel 1 (
    echo WARNING: Java not found in PATH
    echo Ghidra requires Java 17 or later
    echo.
) else (
    java -version 2>&1 | findstr /C:"version"
    echo.
)

REM Launch Ghidra
echo [4/4] Launching Ghidra GUI...
echo.
echo ========================================
echo Starting Ghidra...
echo ========================================
echo.

REM Try different possible locations for ghidraRun
if exist "%GHIDRA_HOME%\ghidraRun.bat" (
    cd /d "%GHIDRA_HOME%"
    call ghidraRun.bat
) else if exist "%GHIDRA_HOME%\Ghidra\ghidraRun.bat" (
    cd /d "%GHIDRA_HOME%\Ghidra"
    call ghidraRun.bat
) else if exist "%GHIDRA_HOME%\ghidra.bat" (
    cd /d "%GHIDRA_HOME%"
    call ghidra.bat
) else (
    echo ERROR: Could not find ghidraRun.bat or ghidra.bat
    echo Searched in:
    echo   - %GHIDRA_HOME%\ghidraRun.bat
    echo   - %GHIDRA_HOME%\Ghidra\ghidraRun.bat
    echo   - %GHIDRA_HOME%\ghidra.bat
    echo.
    echo Please open %GHIDRA_HOME% and look for the Ghidra launch script.
    pause
    exit /b 1
)

echo.
echo ========================================
echo Ghidra has closed
echo ========================================
echo.
echo To import and analyze MetaEditor64.exe:
echo 1. In Ghidra, click File -^> New Project
echo 2. Create a Non-Shared Project
echo 3. Click File -^> Import File
echo 4. Browse to: %TARGET_FILE%
echo 5. Click OK to import
echo 6. Double-click the imported file to analyze
echo.
pause
