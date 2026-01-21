#!/usr/bin/env python3
"""
Ghidra Headless Analysis Script for MetaEditor64.exe
This script automates the analysis of MetaEditor64.exe using Ghidra
and provides detailed reporting capabilities.
"""

import os
import sys
import subprocess
import hashlib
import json
from datetime import datetime
from pathlib import Path

# Configuration
GHIDRA_PATH = r"C:\Tools\ghidra_12.0_PUBLIC_20251205\ghidra_12.0_PUBLIC"
TARGET_EXE = r"C:\Program Files\MetaTrader 5\MetaEditor64.exe"
SCRIPT_DIR = Path(__file__).parent.absolute()
PROJECT_DIR = SCRIPT_DIR / "ghidra_analysis"
PROJECT_NAME = "MetaEditor_Analysis"
OUTPUT_DIR = SCRIPT_DIR / "analysis_results"


def print_banner():
    """Print script banner"""
    print("\n" + "=" * 60)
    print("  Ghidra MetaEditor64.exe Analysis Tool")
    print("=" * 60 + "\n")


def calculate_file_hash(filepath, algorithm='sha256'):
    """Calculate hash of a file"""
    hash_obj = hashlib.new(algorithm)
    with open(filepath, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_obj.update(chunk)
    return hash_obj.hexdigest()


def validate_environment():
    """Validate Ghidra installation and target file"""
    print("[*] Validating environment...")

    # Check Ghidra
    ghidra_path = Path(GHIDRA_PATH)
    analyze_headless = ghidra_path / "support" / "analyzeHeadless.bat"

    if not analyze_headless.exists():
        print(f"[!] ERROR: Ghidra analyzeHeadless.bat not found at: {analyze_headless}")
        print(f"[!] Please verify GHIDRA_PATH is correct")
        return False

    print(f"[+] Ghidra found at: {GHIDRA_PATH}")

    # Check target executable
    target_path = Path(TARGET_EXE)
    if not target_path.exists():
        print(f"[!] ERROR: MetaEditor64.exe not found at: {TARGET_EXE}")
        return False

    file_size = target_path.stat().st_size / (1024 * 1024)  # Convert to MB
    print(f"[+] Target file found: {TARGET_EXE}")
    print(f"    Size: {file_size:.2f} MB")
    print(f"    Modified: {datetime.fromtimestamp(target_path.stat().st_mtime)}")

    return True


def setup_directories():
    """Create necessary directories"""
    print("\n[*] Setting up directories...")
    PROJECT_DIR.mkdir(parents=True, exist_ok=True)
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
    print(f"[+] Project directory: {PROJECT_DIR}")
    print(f"[+] Output directory: {OUTPUT_DIR}")


def generate_file_info():
    """Generate detailed file information"""
    target_path = Path(TARGET_EXE)

    print("\n[*] Generating file hashes (this may take a moment)...")

    info = {
        "filename": target_path.name,
        "path": str(target_path),
        "size_bytes": target_path.stat().st_size,
        "size_mb": round(target_path.stat().st_size / (1024 * 1024), 2),
        "modified": datetime.fromtimestamp(target_path.stat().st_mtime).isoformat(),
        "md5": calculate_file_hash(TARGET_EXE, 'md5'),
        "sha1": calculate_file_hash(TARGET_EXE, 'sha1'),
        "sha256": calculate_file_hash(TARGET_EXE, 'sha256'),
    }

    print(f"[+] MD5:    {info['md5']}")
    print(f"[+] SHA1:   {info['sha1']}")
    print(f"[+] SHA256: {info['sha256']}")

    return info


def run_ghidra_analysis():
    """Run Ghidra headless analysis"""
    print("\n" + "=" * 60)
    print("[*] Starting Ghidra headless analysis...")
    print("[*] This may take several minutes depending on binary size...")
    print("=" * 60 + "\n")

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    stdout_log = OUTPUT_DIR / f"stdout_{timestamp}.txt"
    stderr_log = OUTPUT_DIR / f"stderr_{timestamp}.txt"

    # Build command
    analyze_headless = Path(GHIDRA_PATH) / "support" / "analyzeHeadless.bat"

    cmd = [
        str(analyze_headless),
        str(PROJECT_DIR),
        PROJECT_NAME,
        "-import", TARGET_EXE,
        "-overwrite",
        "-analysisTimeoutPerFile", "300",  # 5 minutes timeout
    ]

    print(f"[*] Command: {' '.join(cmd)}")
    print(f"[*] Logs will be saved to:")
    print(f"    - {stdout_log.name}")
    print(f"    - {stderr_log.name}\n")

    # Execute Ghidra
    with open(stdout_log, 'w') as out_f, open(stderr_log, 'w') as err_f:
        try:
            process = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True,
                bufsize=1
            )

            # Print output in real-time
            for line in process.stdout:
                print(line, end='')
                out_f.write(line)

            process.wait()

            # Write stderr
            stderr_output = process.stderr.read()
            err_f.write(stderr_output)

            if stderr_output:
                print("\n[*] Stderr output:")
                print(stderr_output)

            exit_code = process.returncode

        except Exception as e:
            print(f"[!] ERROR running Ghidra: {e}")
            return timestamp, 1

    print()
    if exit_code == 0:
        print("[+] Analysis completed successfully!")
    else:
        print(f"[!] Analysis completed with exit code: {exit_code}")
        print(f"[*] Check log files in: {OUTPUT_DIR}")

    return timestamp, exit_code


def generate_report(file_info, timestamp, exit_code):
    """Generate comprehensive analysis report"""
    print("\n[*] Generating analysis report...")

    report_file = OUTPUT_DIR / f"analysis_report_{timestamp}.txt"
    json_file = OUTPUT_DIR / f"file_info_{timestamp}.json"

    # Save JSON info
    with open(json_file, 'w') as f:
        json.dump(file_info, f, indent=2)

    # Generate text report
    report = f"""
GHIDRA ANALYSIS REPORT
Generated: {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
{"=" * 60}

TARGET INFORMATION
{"-" * 60}
File:           {file_info['filename']}
Full Path:      {file_info['path']}
Size:           {file_info['size_mb']} MB ({file_info['size_bytes']} bytes)
Last Modified:  {file_info['modified']}

FILE HASHES
{"-" * 60}
MD5:            {file_info['md5']}
SHA1:           {file_info['sha1']}
SHA256:         {file_info['sha256']}

ANALYSIS INFORMATION
{"-" * 60}
Ghidra Version:     12.0
Ghidra Path:        {GHIDRA_PATH}
Analysis Date:      {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
Project Path:       {PROJECT_DIR / PROJECT_NAME}
Exit Code:          {exit_code}
Status:             {"Success" if exit_code == 0 else "Completed with warnings/errors"}

GHIDRA PROJECT LOCATION
{"-" * 60}
To open this analysis in Ghidra GUI:

1. Launch Ghidra:
   {GHIDRA_PATH}\\ghidraRun.bat

2. Open Project:
   - File -> Open Project
   - Navigate to: {PROJECT_DIR}
   - Select project: {PROJECT_NAME}

3. View Analysis:
   - Double-click: MetaEditor64.exe
   - Navigate through functions, strings, and data

USEFUL GHIDRA VIEWS
{"-" * 60}
- Symbol Tree:      Shows all functions, imports, exports
- Decompiler:       C-like pseudocode view
- Listing:          Disassembly view
- Defined Strings:  All strings found in binary
- Data Type Manager: Structures and types

ANALYSIS AREAS TO EXPLORE
{"-" * 60}
1. Entry Point:     main() or WinMain()
2. Imports:         External functions used
3. Exports:         Functions exposed by the DLL
4. Strings:         Hardcoded strings, URLs, paths
5. Functions:       Core logic and algorithms
6. Cross-references: How functions are called

OUTPUT FILES
{"-" * 60}
Stdout Log:         stdout_{timestamp}.txt
Stderr Log:         stderr_{timestamp}.txt
File Info (JSON):   file_info_{timestamp}.json
This Report:        analysis_report_{timestamp}.txt

{"=" * 60}

For detailed analysis, open the project in Ghidra GUI using the
instructions above. The automated analysis has identified functions,
strings, and data structures. Manual review recommended for deeper
understanding of the binary's behavior.

{"=" * 60}
"""

    with open(report_file, 'w') as f:
        f.write(report)

    print(f"[+] Text report saved to: {report_file.name}")
    print(f"[+] JSON info saved to: {json_file.name}")

    return report_file


def print_summary(file_info, report_file):
    """Print final summary"""
    print("\n" + "=" * 60)
    print("          ANALYSIS SUMMARY")
    print("=" * 60)
    print(f"Target:        {file_info['filename']}")
    print(f"Size:          {file_info['size_mb']} MB")
    print(f"Project:       {PROJECT_DIR / PROJECT_NAME}")
    print(f"Report:        {report_file.name}")
    print("=" * 60)

    print("\n[*] Next Steps:")
    print(f"    1. Review report: {report_file}")
    print(f"    2. Open Ghidra: {GHIDRA_PATH}\\ghidraRun.bat")
    print(f"    3. Open project: {PROJECT_DIR}")
    print(f"    4. Project name: {PROJECT_NAME}")
    print(f"    5. Analyze: Double-click MetaEditor64.exe")

    print("\n[+] Script completed successfully!")


def main():
    """Main execution function"""
    try:
        print_banner()

        # Validate environment
        if not validate_environment():
            sys.exit(1)

        # Setup directories
        setup_directories()

        # Generate file information
        file_info = generate_file_info()

        # Run Ghidra analysis
        timestamp, exit_code = run_ghidra_analysis()

        # Generate report
        report_file = generate_report(file_info, timestamp, exit_code)

        # Print summary
        print_summary(file_info, report_file)

        return exit_code

    except KeyboardInterrupt:
        print("\n\n[!] Analysis interrupted by user")
        sys.exit(130)
    except Exception as e:
        print(f"\n[!] ERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    sys.exit(main())
