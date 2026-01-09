@echo off
echo ========================================
echo Ghidra Launcher
echo ========================================
echo.

set GHIDRA_ROOT=C:\Tools\ghidra_11.2.1_PUBLIC

echo Searching for Ghidra launch script...
echo.

REM Check all possible locations
if exist "%GHIDRA_ROOT%\Ghidra\ghidraRun.bat" (
    echo FOUND: Launching Ghidra...
    cd /d "%GHIDRA_ROOT%\Ghidra"
    start "" ghidraRun.bat
    goto :done
)

if exist "%GHIDRA_ROOT%\ghidraRun.bat" (
    echo FOUND: Launching Ghidra...
    cd /d "%GHIDRA_ROOT%"
    start "" ghidraRun.bat
    goto :done
)

if exist "%GHIDRA_ROOT%\Ghidra\ghidra.bat" (
    echo FOUND: Launching Ghidra...
    cd /d "%GHIDRA_ROOT%\Ghidra"
    start "" ghidra.bat
    goto :done
)

if exist "%GHIDRA_ROOT%\ghidra.bat" (
    echo FOUND: Launching Ghidra...
    cd /d "%GHIDRA_ROOT%"
    start "" ghidra.bat
    goto :done
)

echo ERROR: Could not find Ghidra launcher
echo.
echo Please do this manually:
echo 1. Open File Explorer
echo 2. Go to: %GHIDRA_ROOT%
echo 3. Open the "Ghidra" folder
echo 4. Double-click ghidraRun.bat
echo.
pause
exit /b 1

:done
echo.
echo ========================================
echo Ghidra is starting...
echo ========================================
echo.
echo When Ghidra opens:
echo 1. File -^> New Project -^> Create Non-Shared Project
echo 2. Choose a location and name for your project
echo 3. File -^> Import File
echo 4. Browse to: C:\Program Files\MetaTrader 5\MetaEditor64.exe
echo 5. Click Select File to Import
echo 6. Click OK (accept default import options)
echo 7. When import completes, double-click MetaEditor64.exe in the project window
echo 8. Click "Yes" when asked to analyze
echo 9. Wait for analysis to complete
echo.
echo This window will close in 10 seconds...
timeout /t 10 /nobreak >nul
