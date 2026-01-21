@echo off
REM Ghidra Headless Analysis Batch Script for MetaEditor64.exe
REM This script automates the analysis of MetaEditor64.exe using Ghidra

setlocal EnableDelayedExpansion

REM Configuration
set "GHIDRA_PATH=C:\Tools\ghidra_12.0_PUBLIC_20251205\ghidra_12.0_PUBLIC"
set "TARGET_EXE=C:\Program Files\MetaTrader 5\MetaEditor64.exe"
set "PROJECT_DIR=%~dp0ghidra_analysis"
set "PROJECT_NAME=MetaEditor_Analysis"
set "OUTPUT_DIR=%~dp0analysis_results"

echo.
echo ========================================
echo  Ghidra MetaEditor64.exe Analysis
echo ========================================
echo.

REM Validate Ghidra installation
echo [*] Validating Ghidra installation...
if not exist "%GHIDRA_PATH%\support\analyzeHeadless.bat" (
    echo [!] ERROR: Ghidra analyzeHeadless.bat not found
    echo [!] Expected location: %GHIDRA_PATH%\support\analyzeHeadless.bat
    echo [!] Please verify GHIDRA_PATH is correct
    pause
    exit /b 1
)
echo [+] Ghidra found at: %GHIDRA_PATH%
echo.

REM Validate target executable
echo [*] Validating target executable...
if not exist "%TARGET_EXE%" (
    echo [!] ERROR: MetaEditor64.exe not found
    echo [!] Expected location: %TARGET_EXE%
    pause
    exit /b 1
)
echo [+] Target file found: %TARGET_EXE%
echo.

REM Create output directories
echo [*] Setting up directories...
if not exist "%PROJECT_DIR%" mkdir "%PROJECT_DIR%"
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"
echo [+] Project directory: %PROJECT_DIR%
echo [+] Output directory: %OUTPUT_DIR%
echo.

REM Generate timestamp
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set TIMESTAMP=%datetime:~0,8%_%datetime:~8,6%

REM Run Ghidra headless analysis
echo ========================================
echo [*] Starting Ghidra headless analysis...
echo [*] This may take several minutes...
echo ========================================
echo.

set "LOG_STDOUT=%OUTPUT_DIR%\stdout_%TIMESTAMP%.txt"
set "LOG_STDERR=%OUTPUT_DIR%\stderr_%TIMESTAMP%.txt"

REM Execute Ghidra analyzer
call "%GHIDRA_PATH%\support\analyzeHeadless.bat" ^
    "%PROJECT_DIR%" ^
    "%PROJECT_NAME%" ^
    -import "%TARGET_EXE%" ^
    -overwrite ^
    > "%LOG_STDOUT%" 2> "%LOG_STDERR%"

set EXITCODE=%ERRORLEVEL%

echo.
if %EXITCODE% EQU 0 (
    echo [+] Analysis completed successfully!
) else (
    echo [!] Analysis completed with exit code: %EXITCODE%
    echo [*] Check log files in: %OUTPUT_DIR%
)

echo.
echo ========================================
echo          ANALYSIS SUMMARY
echo ========================================
echo Target:        %TARGET_EXE%
echo Project:       %PROJECT_DIR%\%PROJECT_NAME%
echo Output:        %OUTPUT_DIR%
echo Stdout Log:    stdout_%TIMESTAMP%.txt
echo Stderr Log:    stderr_%TIMESTAMP%.txt
echo ========================================
echo.

REM Generate basic report
echo [*] Generating analysis report...
set "REPORT_FILE=%OUTPUT_DIR%\analysis_report_%TIMESTAMP%.txt"

(
    echo GHIDRA ANALYSIS REPORT
    echo Generated: %date% %time%
    echo ===============================================
    echo.
    echo TARGET INFORMATION
    echo ------------------
    echo File:           %TARGET_EXE%
    echo.
    echo ANALYSIS INFORMATION
    echo --------------------
    echo Ghidra Version: 12.0
    echo Analysis Date:  %date% %time%
    echo Project Path:   %PROJECT_DIR%\%PROJECT_NAME%
    echo.
    echo GHIDRA PROJECT LOCATION
    echo -----------------------
    echo To open this analysis in Ghidra GUI:
    echo 1. Launch: %GHIDRA_PATH%\ghidraRun.bat
    echo 2. File -^> Open Project
    echo 3. Navigate to: %PROJECT_DIR%
    echo 4. Select project: %PROJECT_NAME%
    echo 5. Double-click: MetaEditor64.exe
    echo.
    echo OUTPUT FILES
    echo ------------
    echo Stdout Log:     stdout_%TIMESTAMP%.txt
    echo Stderr Log:     stderr_%TIMESTAMP%.txt
    echo This Report:    analysis_report_%TIMESTAMP%.txt
    echo.
    echo ===============================================
) > "%REPORT_FILE%"

echo [+] Report saved to: analysis_report_%TIMESTAMP%.txt
echo.

REM Instructions for viewing results
echo ========================================
echo [*] Next Steps:
echo ========================================
echo 1. Open Ghidra GUI:
echo    %GHIDRA_PATH%\ghidraRun.bat
echo.
echo 2. Open project at: %PROJECT_DIR%
echo    Project name: %PROJECT_NAME%
echo.
echo 3. Double-click MetaEditor64.exe to view analysis
echo.
echo 4. Review logs in: %OUTPUT_DIR%
echo ========================================
echo.

echo [+] Script completed!
echo.
pause
