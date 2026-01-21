// Export all imports and exports from the analyzed binary
// @category Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.symbol.*;
import ghidra.program.model.listing.*;
import ghidra.program.model.address.*;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

public class ExportImportsExports extends GhidraScript {

    @Override
    public void run() throws Exception {
        if (currentProgram == null) {
            println("No program is currently open.");
            return;
        }

        // Generate output filename with timestamp
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        String timestamp = sdf.format(new Date());
        String outputFile = System.getProperty("user.dir") + "/analysis_results/imports_exports_" + timestamp + ".txt";

        println("Exporting imports and exports to: " + outputFile);

        FileWriter fileWriter = new FileWriter(outputFile);
        PrintWriter writer = new PrintWriter(fileWriter);

        writer.println("=" .repeat(80));
        writer.println("IMPORTS & EXPORTS ANALYSIS: " + currentProgram.getName());
        writer.println("Generated: " + new Date());
        writer.println("=" .repeat(80));
        writer.println();

        // Export External Symbols (Imports)
        writer.println("\n" + "=" .repeat(80));
        writer.println("IMPORTED FUNCTIONS");
        writer.println("=" .repeat(80));

        SymbolTable symbolTable = currentProgram.getSymbolTable();
        SymbolIterator symbols = symbolTable.getExternalSymbols();

        ArrayList<Symbol> importList = new ArrayList<>();
        while (symbols.hasNext()) {
            Symbol symbol = symbols.next();
            if (symbol.getSymbolType() == SymbolType.FUNCTION) {
                importList.add(symbol);
            }
        }

        // Sort by name
        Collections.sort(importList, new Comparator<Symbol>() {
            public int compare(Symbol s1, Symbol s2) {
                return s1.getName().compareTo(s2.getName());
            }
        });

        String currentLibrary = "";
        int importCount = 0;

        for (Symbol symbol : importList) {
            ExternalLocation extLoc = (ExternalLocation) symbol.getObject();
            String library = extLoc.getLibraryName();

            if (!library.equals(currentLibrary)) {
                writer.println("\n" + "-".repeat(80));
                writer.println("Library: " + library);
                writer.println("-".repeat(80));
                currentLibrary = library;
            }

            writer.println("  " + symbol.getName());
            importCount++;
        }

        writer.println("\nTotal imported functions: " + importCount);

        // Export Exported Functions
        writer.println("\n\n" + "=" .repeat(80));
        writer.println("EXPORTED FUNCTIONS");
        writer.println("=" .repeat(80));

        FunctionManager functionManager = currentProgram.getFunctionManager();
        ArrayList<Function> exportList = new ArrayList<>();

        FunctionIterator functions = functionManager.getFunctions(true);
        while (functions.hasNext()) {
            Function function = functions.next();
            Symbol symbol = function.getSymbol();

            // Check if function is exported
            if (symbol != null && symbol.isExternalEntryPoint()) {
                exportList.add(function);
            }
        }

        // Sort by address
        Collections.sort(exportList, new Comparator<Function>() {
            public int compare(Function f1, Function f2) {
                return f1.getEntryPoint().compareTo(f2.getEntryPoint());
            }
        });

        if (exportList.isEmpty()) {
            writer.println("\nNo exported functions found (this is an executable, not a DLL).");
        } else {
            writer.println();
            for (Function function : exportList) {
                writer.println("-".repeat(80));
                writer.println("Address:    " + function.getEntryPoint());
                writer.println("Name:       " + function.getName());
                writer.println("Signature:  " + function.getSignature());
                writer.println();
            }
            writer.println("Total exported functions: " + exportList.size());
        }

        // Summary
        writer.println("\n\n" + "=" .repeat(80));
        writer.println("SUMMARY");
        writer.println("=" .repeat(80));
        writer.println("Total Imports:  " + importCount);
        writer.println("Total Exports:  " + exportList.size());
        writer.println("=" .repeat(80));

        writer.close();

        println("Successfully exported imports and exports to " + outputFile);
        println("  Imports: " + importCount);
        println("  Exports: " + exportList.size());
    }
}
