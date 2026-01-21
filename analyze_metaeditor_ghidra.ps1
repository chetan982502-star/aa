# Ghidra Headless Analysis Script for MetaEditor64.exe
# This script automates the analysis of MetaEditor64.exe using Ghidra

# Configuration
$GHIDRA_PATH = "C:\Tools\ghidra_12.0_PUBLIC_20251205\ghidra_12.0_PUBLIC"
$TARGET_EXE = "C:\Program Files\MetaTrader 5\MetaEditor64.exe"
$PROJECT_DIR = "$PSScriptRoot\ghidra_analysis"
$PROJECT_NAME = "MetaEditor_Analysis"
$OUTPUT_DIR = "$PSScriptRoot\analysis_results"

# Validate Ghidra installation
Write-Host "[*] Validating Ghidra installation..." -ForegroundColor Cyan
$analyzeHeadless = Join-Path $GHIDRA_PATH "support\analyzeHeadless.bat"
if (-Not (Test-Path $analyzeHeadless)) {
    Write-Host "[!] ERROR: Ghidra analyzeHeadless.bat not found at: $analyzeHeadless" -ForegroundColor Red
    Write-Host "[!] Please verify GHIDRA_PATH is correct" -ForegroundColor Red
    exit 1
}
Write-Host "[+] Ghidra found at: $GHIDRA_PATH" -ForegroundColor Green

# Validate target executable
Write-Host "[*] Validating target executable..." -ForegroundColor Cyan
if (-Not (Test-Path $TARGET_EXE)) {
    Write-Host "[!] ERROR: MetaEditor64.exe not found at: $TARGET_EXE" -ForegroundColor Red
    exit 1
}
$fileInfo = Get-Item $TARGET_EXE
Write-Host "[+] Target file found: $TARGET_EXE" -ForegroundColor Green
Write-Host "    Size: $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor Gray
Write-Host "    Modified: $($fileInfo.LastWriteTime)" -ForegroundColor Gray

# Create output directories
Write-Host "[*] Setting up directories..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $PROJECT_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $OUTPUT_DIR | Out-Null
Write-Host "[+] Project directory: $PROJECT_DIR" -ForegroundColor Green
Write-Host "[+] Output directory: $OUTPUT_DIR" -ForegroundColor Green

# Run Ghidra headless analysis
Write-Host "`n[*] Starting Ghidra headless analysis..." -ForegroundColor Cyan
Write-Host "[*] This may take several minutes depending on the binary size..." -ForegroundColor Yellow

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = Join-Path $OUTPUT_DIR "ghidra_analysis_$timestamp.log"

# Build the command
$ghidraArgs = @(
    $PROJECT_DIR,
    $PROJECT_NAME,
    "-import", "`"$TARGET_EXE`"",
    "-overwrite",
    "-scriptPath", "`"$PSScriptRoot`"",
    "-postScript", "ExportFunctions.java",
    "-postScript", "ExportStrings.java"
)

Write-Host "[*] Running Ghidra analyzer..." -ForegroundColor Cyan
Write-Host "    Command: $analyzeHeadless $($ghidraArgs -join ' ')" -ForegroundColor Gray

# Execute Ghidra
$process = Start-Process -FilePath $analyzeHeadless `
    -ArgumentList $ghidraArgs `
    -NoNewWindow `
    -Wait `
    -PassThru `
    -RedirectStandardOutput "$OUTPUT_DIR\stdout_$timestamp.txt" `
    -RedirectStandardError "$OUTPUT_DIR\stderr_$timestamp.txt"

if ($process.ExitCode -eq 0) {
    Write-Host "`n[+] Analysis completed successfully!" -ForegroundColor Green
} else {
    Write-Host "`n[!] Analysis completed with exit code: $($process.ExitCode)" -ForegroundColor Yellow
    Write-Host "[*] Check log files in: $OUTPUT_DIR" -ForegroundColor Yellow
}

# Display results
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "          ANALYSIS SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Target:        $TARGET_EXE" -ForegroundColor White
Write-Host "Project:       $PROJECT_DIR\$PROJECT_NAME" -ForegroundColor White
Write-Host "Output:        $OUTPUT_DIR" -ForegroundColor White
Write-Host "Log file:      stdout_$timestamp.txt" -ForegroundColor White
Write-Host "========================================`n" -ForegroundColor Cyan

# Instructions for viewing results
Write-Host "[*] Next steps:" -ForegroundColor Cyan
Write-Host "    1. Open Ghidra GUI: $GHIDRA_PATH\ghidraRun.bat" -ForegroundColor White
Write-Host "    2. Open project at: $PROJECT_DIR" -ForegroundColor White
Write-Host "    3. Project name: $PROJECT_NAME" -ForegroundColor White
Write-Host "    4. Double-click MetaEditor64.exe to view analysis" -ForegroundColor White
Write-Host "`n[*] Analysis logs saved to: $OUTPUT_DIR" -ForegroundColor Green

# Optional: Generate basic report
Write-Host "`n[*] Generating basic analysis report..." -ForegroundColor Cyan
$reportFile = Join-Path $OUTPUT_DIR "analysis_report_$timestamp.txt"

$report = @"
GHIDRA ANALYSIS REPORT
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
===============================================

TARGET INFORMATION
------------------
File:           $TARGET_EXE
Size:           $([math]::Round($fileInfo.Length / 1MB, 2)) MB
Last Modified:  $($fileInfo.LastWriteTime)
MD5:            $((Get-FileHash -Path $TARGET_EXE -Algorithm MD5).Hash)
SHA256:         $((Get-FileHash -Path $TARGET_EXE -Algorithm SHA256).Hash)

ANALYSIS INFORMATION
--------------------
Ghidra Version: 12.0
Analysis Date:  $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Project Path:   $PROJECT_DIR\$PROJECT_NAME

GHIDRA PROJECT LOCATION
-----------------------
To open this analysis in Ghidra GUI:
1. Launch: $GHIDRA_PATH\ghidraRun.bat
2. File -> Open Project
3. Navigate to: $PROJECT_DIR
4. Select project: $PROJECT_NAME
5. Double-click: MetaEditor64.exe

OUTPUT FILES
------------
Stdout Log:     stdout_$timestamp.txt
Stderr Log:     stderr_$timestamp.txt
This Report:    analysis_report_$timestamp.txt

===============================================
"@

$report | Out-File -FilePath $reportFile -Encoding UTF8
Write-Host "[+] Report saved to: $reportFile" -ForegroundColor Green

Write-Host "`n[+] Script completed!" -ForegroundColor Green
