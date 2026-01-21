# Quick Start Guide - Ghidra Analysis of MetaEditor64.exe

## TL;DR - 30 Second Start

1. **Double-click:** `analyze_metaeditor_ghidra.bat`
2. **Wait:** 5-15 minutes for analysis
3. **Check:** `analysis_results/` folder for reports
4. **Open Ghidra:** Launch GUI to explore binary

---

## Three Ways to Run

### Method 1: Batch File (Recommended for Beginners)
```cmd
analyze_metaeditor_ghidra.bat
```
- Just double-click
- No setup required
- Works immediately

### Method 2: PowerShell (Recommended for Windows Users)
```powershell
.\analyze_metaeditor_ghidra.ps1
```
- Better progress display
- More detailed output
- Includes file hashing

### Method 3: Python (Recommended for Advanced Users)
```bash
python analyze_metaeditor_ghidra.py
```
- Real-time output
- JSON metadata export
- Extensible/customizable

---

## What You Get

After running the script, check `analysis_results/` for:

### 📄 Main Report
- `analysis_report_[timestamp].txt` - Full analysis summary

### 📊 Data Exports
- `functions_[timestamp].csv` - All functions found
- `strings_[timestamp].txt` - All strings in the binary
- `imports_exports_[timestamp].txt` - DLL imports/exports

### 📝 Logs
- `stdout_[timestamp].txt` - Ghidra output
- `stderr_[timestamp].txt` - Error messages (if any)

---

## View Results in Ghidra

### Step 1: Launch Ghidra
```cmd
C:\Tools\ghidra_12.0_PUBLIC_20251205\ghidra_12.0_PUBLIC\ghidraRun.bat
```

### Step 2: Open Project
- File → Open Project
- Browse to: `[script location]\ghidra_analysis`
- Project name: `MetaEditor_Analysis`

### Step 3: Analyze
- Double-click: `MetaEditor64.exe`
- Explore functions, strings, and code

---

## Useful Ghidra Shortcuts

| Action | Shortcut |
|--------|----------|
| Decompile function | `F5` |
| Go to address | `G` |
| Find references | `Ctrl+Shift+F` |
| Search strings | `Ctrl+Shift+E` |
| Go back | `Alt+Left` |
| Go forward | `Alt+Right` |
| Rename symbol | `L` |
| Add comment | `;` |

---

## Common Issues

### ❌ "Java not found"
**Fix:** Install Java 17+ from https://adoptium.net/

### ❌ "Ghidra not found"
**Fix:** Edit script and update `GHIDRA_PATH` variable

### ❌ "MetaEditor64.exe not found"
**Fix:** Edit script and update `TARGET_EXE` path

### ❌ PowerShell execution error
**Fix:** Run in PowerShell as Administrator:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

---

## What to Look For

### 🔍 Interesting Functions
- `WinMain` or `main` - Entry point
- Functions with "crypto", "encrypt", "decrypt"
- Functions with "network", "connect", "download"
- Error handling functions

### 🔍 Interesting Strings
- URLs and IP addresses
- File paths and registry keys
- Error messages
- Debug information
- Version information

### 🔍 Interesting Imports
- **Crypto:** `CryptEncrypt`, `CryptDecrypt`
- **Network:** `WSAStartup`, `connect`, `send`
- **Files:** `CreateFile`, `ReadFile`, `WriteFile`
- **Process:** `CreateProcess`, `CreateRemoteThread`

---

## Example Workflow

```
1. Run: analyze_metaeditor_ghidra.bat
2. Wait: ~10 minutes
3. Read: analysis_results/analysis_report_*.txt
4. Review: analysis_results/strings_*.txt (look for URLs, paths)
5. Check: analysis_results/imports_exports_*.txt (see what APIs are used)
6. Open Ghidra GUI
7. Navigate to interesting functions
8. Decompile and analyze
```

---

## Next Steps

After initial analysis:

1. **Read the full README:** `README_GHIDRA_ANALYSIS.md`
2. **Learn Ghidra basics:** https://ghidra-sre.org/courses/
3. **Explore the binary:** Focus on interesting functions
4. **Document findings:** Keep notes on discoveries
5. **Advanced analysis:** Write custom Ghidra scripts

---

## Files in This Repository

| File | Purpose |
|------|---------|
| `analyze_metaeditor_ghidra.bat` | Windows batch script |
| `analyze_metaeditor_ghidra.ps1` | PowerShell script |
| `analyze_metaeditor_ghidra.py` | Python script |
| `ExportFunctions.java` | Ghidra script - export functions |
| `ExportStrings.java` | Ghidra script - export strings |
| `ExportImportsExports.java` | Ghidra script - export imports/exports |
| `README_GHIDRA_ANALYSIS.md` | Full documentation |
| `QUICK_START.md` | This file - quick reference |

---

## Time Requirements

- **Script execution:** 5-15 minutes
- **Reading reports:** 10-20 minutes
- **Manual Ghidra analysis:** Hours to days (depending on depth)

---

## Support

Need help? Check:
1. Full README: `README_GHIDRA_ANALYSIS.md`
2. Log files in `analysis_results/`
3. Ghidra documentation: https://ghidra-sre.org/
4. Error messages in console output

---

**Happy Reversing! 🔍**
