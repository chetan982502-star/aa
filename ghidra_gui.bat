@echo off
REM Launch Ghidra GUI and open MetaEditor64.exe for analysis

set GHIDRA_HOME=C:\Tools\ghidra_11.2.1_PUBLIC
set TARGET_FILE=C:\Program Files\MetaTrader 5\MetaEditor64.exe

echo Starting Ghidra...
echo Ghidra location: %GHIDRA_HOME%
echo Target file: %TARGET_FILE%

REM Launch Ghidra GUI
"%GHIDRA_HOME%\ghidraRun.bat"

echo.
echo Once Ghidra opens:
echo 1. Click File -^> Import File
echo 2. Browse to: %TARGET_FILE%
echo 3. Click Select File to Import
echo 4. Review the import options and click OK
echo 5. After import, double-click the file in the Project window to analyze it
echo.
pause
