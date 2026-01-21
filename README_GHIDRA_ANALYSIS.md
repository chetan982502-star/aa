# Ghidra Analysis Guide for MetaEditor64.exe

This repository contains automated scripts and tools for analyzing `MetaEditor64.exe` using Ghidra reverse engineering tool.

## Table of Contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quick Start](#quick-start)
4. [Available Scripts](#available-scripts)
5. [Detailed Usage](#detailed-usage)
6. [Understanding the Results](#understanding-the-results)
7. [Troubleshooting](#troubleshooting)
8. [Advanced Analysis](#advanced-analysis)

---

## Overview

This analysis toolkit provides automated scripts to:
- Import MetaEditor64.exe into Ghidra
- Run automated analysis and decompilation
- Extract functions, strings, imports, and exports
- Generate comprehensive reports
- Prepare the binary for manual reverse engineering

**Target Binary:**
- **File:** `C:\Program Files\MetaTrader 5\MetaEditor64.exe`
- **Type:** Windows PE (Portable Executable) 64-bit
- **Purpose:** MetaTrader 5 code editor

**Ghidra Installation:**
- **Path:** `C:\Tools\ghidra_12.0_PUBLIC_20251205\ghidra_12.0_PUBLIC`
- **Version:** 12.0

---

## Prerequisites

### Required Software

1. **Ghidra 12.0** (or compatible version)
   - Downloaded from: https://ghidra-sre.org/
   - Installed at: `C:\Tools\ghidra_12.0_PUBLIC_20251205\ghidra_12.0_PUBLIC`

2. **Java JDK 17+** (required by Ghidra)
   - Download from: https://adoptium.net/
   - Verify installation: `java -version`

3. **Python 3.8+** (optional, for Python script)
   - Download from: https://www.python.org/
   - Verify installation: `python --version`

4. **PowerShell 5.1+** (optional, for PowerShell script)
   - Pre-installed on Windows 10/11
   - Verify: `$PSVersionTable.PSVersion`

### Required Files

- MetaEditor64.exe at: `C:\Program Files\MetaTrader 5\MetaEditor64.exe`
- Analysis scripts (provided in this repository)

---

## Quick Start

### Option 1: Batch File (Easiest)

1. Double-click `analyze_metaeditor_ghidra.bat`
2. Wait for analysis to complete
3. Review results in `analysis_results/` folder

### Option 2: PowerShell Script

```powershell
# Run in PowerShell
.\analyze_metaeditor_ghidra.ps1
```

### Option 3: Python Script

```bash
# Run in Command Prompt or PowerShell
python analyze_metaeditor_ghidra.py
```

---

## Available Scripts

### 1. `analyze_metaeditor_ghidra.bat`

**Windows Batch Script**

- **Best for:** Users who want a simple double-click solution
- **Features:**
  - No dependencies beyond Ghidra
  - Color-coded output
  - Automatic log generation
  - Creates analysis report

**Usage:**
```cmd
analyze_metaeditor_ghidra.bat
```

---

### 2. `analyze_metaeditor_ghidra.ps1`

**PowerShell Script**

- **Best for:** Users comfortable with PowerShell
- **Features:**
  - Rich formatting and colors
  - Better error handling
  - File hash calculation (MD5, SHA256)
  - Detailed progress reporting

**Usage:**
```powershell
# If you get execution policy error, run:
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Then run the script:
.\analyze_metaeditor_ghidra.ps1
```

---

### 3. `analyze_metaeditor_ghidra.py`

**Python Script**

- **Best for:** Advanced users who want customization
- **Features:**
  - Cross-platform compatible
  - Real-time analysis output
  - JSON export of file metadata
  - Comprehensive hash calculation (MD5, SHA1, SHA256)
  - Extensible for custom analysis

**Usage:**
```bash
python analyze_metaeditor_ghidra.py
```

---

### 4. Ghidra Post-Analysis Scripts

These Java scripts run automatically or can be run manually in Ghidra:

#### `ExportFunctions.java`
- Exports all functions to CSV
- Includes: address, name, size, calling convention, parameters
- Output: `analysis_results/functions_[timestamp].csv`

#### `ExportStrings.java`
- Exports all defined strings
- Includes: address, type, length, cross-references
- Output: `analysis_results/strings_[timestamp].txt`

#### `ExportImportsExports.java`
- Exports imported functions (from DLLs)
- Exports exported functions (if any)
- Organized by library
- Output: `analysis_results/imports_exports_[timestamp].txt`

---

## Detailed Usage

### Step 1: Run Analysis Script

Choose one of the three scripts and run it:

```cmd
REM Option 1: Batch file
analyze_metaeditor_ghidra.bat

REM Option 2: PowerShell
powershell -ExecutionPolicy Bypass -File analyze_metaeditor_ghidra.ps1

REM Option 3: Python
python analyze_metaeditor_ghidra.py
```

### Step 2: Wait for Analysis

The script will:
1. Validate Ghidra installation
2. Validate target executable
3. Create project directory
4. Import MetaEditor64.exe into Ghidra
5. Run automated analysis (may take 5-15 minutes)
6. Generate reports

**Expected Output:**
```
[*] Starting Ghidra headless analysis...
[*] This may take several minutes...

INFO  ANALYZING changes made by auto-analysis
INFO  Decompiling functions...
INFO  Analysis complete
```

### Step 3: Review Results

After completion, check the `analysis_results/` folder:

```
analysis_results/
├── stdout_20260121_143022.txt       # Ghidra output log
├── stderr_20260121_143022.txt       # Ghidra error log (if any)
├── analysis_report_20260121_143022.txt  # Summary report
├── file_info_20260121_143022.json   # File metadata (Python only)
├── functions_20260121_143022.csv    # Extracted functions
├── strings_20260121_143022.txt      # Extracted strings
└── imports_exports_20260121_143022.txt  # Imports/Exports
```

### Step 4: Open in Ghidra GUI

For detailed manual analysis:

1. **Launch Ghidra:**
   ```cmd
   C:\Tools\ghidra_12.0_PUBLIC_20251205\ghidra_12.0_PUBLIC\ghidraRun.bat
   ```

2. **Open Project:**
   - File → Open Project
   - Navigate to: `<script_directory>\ghidra_analysis`
   - Select: `MetaEditor_Analysis`

3. **Open Binary:**
   - Double-click: `MetaEditor64.exe`

4. **Explore Analysis:**
   - See next section for what to look for

---

## Understanding the Results

### Analysis Report

The `analysis_report_[timestamp].txt` contains:

- **Target Information:** File name, path, size, hashes
- **Analysis Information:** Ghidra version, project location, status
- **Instructions:** How to open the project in Ghidra GUI

### Extracted Functions (`functions_*.csv`)

CSV format with columns:

| Column | Description |
|--------|-------------|
| Address | Memory address of function entry point |
| Name | Function name (demangled if C++) |
| Size | Size of function in bytes |
| CallingConvention | Calling convention (e.g., __stdcall) |
| ReturnType | Return data type |
| Parameters | Function parameters with types |
| Namespace | Namespace or class (for C++) |
| IsThunk | Whether it's a thunk function |
| IsExternal | Whether it's an imported function |

**Example:**
```csv
Address,Name,Size,CallingConvention,ReturnType,Parameters,Namespace
0x140001000,"WinMain",256,__stdcall,int,"HINSTANCE hInstance; HINSTANCE hPrevInstance",Global
```

### Extracted Strings (`strings_*.txt`)

Contains all strings found in the binary:

```
Address: 0x140012000
Type:    unicode
Length:  45 chars
XRefs:   3
Value:   MetaEditor - MetaQuotes Software Corp.
```

**Look for:**
- Error messages (debugging info)
- File paths (installation/config paths)
- URLs (update servers, telemetry)
- Registry keys (settings storage)
- Function names (internal debug symbols)

### Imports & Exports (`imports_exports_*.txt`)

**Imports:** External functions the binary calls

```
Library: KERNEL32.dll
  CreateFileW
  ReadFile
  WriteFile
  CloseHandle
```

**Useful for:**
- Understanding what APIs are used
- Identifying functionality (file I/O, network, crypto)
- Finding interesting function calls to analyze

---

## Troubleshooting

### Error: "Ghidra analyzeHeadless.bat not found"

**Solution:**
1. Verify Ghidra is installed at the correct path
2. Edit the script and update `GHIDRA_PATH` variable
3. Ensure path doesn't have trailing backslash

### Error: "MetaEditor64.exe not found"

**Solution:**
1. Verify MetaTrader 5 is installed
2. Check exact path: `C:\Program Files\MetaTrader 5\MetaEditor64.exe`
3. Edit script if installed in different location

### Error: "Java not found"

**Solution:**
1. Install Java JDK 17+ from https://adoptium.net/
2. Add Java to PATH environment variable
3. Restart command prompt/PowerShell

### Analysis Hangs or Takes Too Long

**Solutions:**
1. Be patient - large binaries can take 15-30 minutes
2. Check Task Manager - ensure Ghidra process is running
3. Review `stderr_*.txt` for error messages
4. Try reducing timeout in script

### PowerShell Execution Policy Error

**Solution:**
```powershell
# Temporary bypass
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Or run directly
powershell -ExecutionPolicy Bypass -File analyze_metaeditor_ghidra.ps1
```

---

## Advanced Analysis

### Manual Analysis in Ghidra GUI

Once the project is open:

#### 1. Navigate to Entry Point

- **Window → Program Trees**
- Expand `Imports` to see external functions
- Expand `Exports` to see exported functions
- Double-click `entry` function to jump to entry point

#### 2. Use the Decompiler

- Select any function in Symbol Tree
- Press `F5` or Window → Decompiler
- View C-like pseudocode

#### 3. Search for Strings

- **Search → For Strings**
- Filter by:
  - Minimum length (e.g., 5)
  - String type (ASCII, Unicode)
- Double-click to see cross-references

#### 4. Analyze Specific Function

1. Find function in Symbol Tree
2. Double-click to open in disassembly
3. Press `F5` for decompiler view
4. Right-click → References → Show References to
5. See where function is called from

#### 5. Export Custom Analysis

- **File → Export Program**
- Choose format: C/C++, XML, HTML
- Useful for documentation

### Running Custom Scripts

To run the Java scripts manually:

1. Open Ghidra project
2. **Window → Script Manager**
3. Click **Create New Script** → Java
4. Copy contents of `ExportFunctions.java`
5. Save and click **Run**

### Batch Processing Multiple Files

Modify the scripts to accept command-line arguments:

```python
# Python example
import sys
TARGET_EXE = sys.argv[1] if len(sys.argv) > 1 else r"C:\Program Files\MetaTrader 5\MetaEditor64.exe"
```

### Automated Analysis Tasks

Create a custom Ghidra script to:

- Find specific API calls (e.g., `CreateRemoteThread`)
- Identify cryptographic constants
- Detect suspicious patterns
- Generate custom reports

---

## Key Areas to Investigate

When analyzing MetaEditor64.exe, focus on:

### 1. **Initialization**
- Entry point (WinMain or main)
- DLL loading
- Configuration file reading

### 2. **File Operations**
- File open/read/write functions
- MQL file parsing
- Project management

### 3. **Network Activity**
- URLs and endpoints
- Update checking
- License validation

### 4. **Code Compilation**
- MQL to EX5 compilation
- Syntax parsing
- Error handling

### 5. **User Interface**
- Window creation
- Menu handlers
- Editor functionality

### 6. **Security Features**
- License checking
- Code signing verification
- Anti-debugging (if any)

---

## Additional Resources

### Ghidra Documentation
- **Official Docs:** https://ghidra-sre.org/
- **Courses:** https://ghidra.re/courses/
- **CheatSheet:** https://ghidra-sre.org/CheatSheet.html

### MetaTrader Information
- **MQL5 Docs:** https://www.mql5.com/en/docs
- **MetaEditor:** https://www.metatrader5.com/en/automated-trading/metaeditor

### Reverse Engineering Resources
- **Practical Reverse Engineering** (Book)
- **Reverse Engineering Stack Exchange:** https://reverseengineering.stackexchange.com/

---

## Notes

- **Legal:** Ensure you have permission to reverse engineer this software
- **Purpose:** This analysis is for educational and security research purposes
- **Backup:** Always keep backups of original files
- **Time:** Initial analysis may take 10-30 minutes depending on hardware
- **Disk Space:** Ghidra project may require 500MB - 2GB of disk space

---

## Script Customization

### Changing Paths

Edit these variables in the scripts:

**Batch/PowerShell:**
```batch
set "GHIDRA_PATH=C:\Your\Ghidra\Path"
set "TARGET_EXE=C:\Your\Target\File.exe"
```

**Python:**
```python
GHIDRA_PATH = r"C:\Your\Ghidra\Path"
TARGET_EXE = r"C:\Your\Target\File.exe"
```

### Adding Custom Analysis

Add Ghidra script parameters:

```batch
-postScript YourScript.java
-scriptPath "C:\Path\To\Scripts"
```

---

## Support

For issues or questions:

1. Check Ghidra logs in `analysis_results/`
2. Review Ghidra documentation
3. Verify all paths are correct
4. Ensure Java is properly installed

---

## License

These scripts are provided as-is for educational purposes.

---

**Last Updated:** 2026-01-21
**Version:** 1.0
**Tested With:** Ghidra 12.0, Windows 10/11, Java 17
