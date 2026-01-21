// Export all functions from the analyzed binary to a CSV file
// @category Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.*;
import ghidra.program.model.address.*;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ExportFunctions extends GhidraScript {

    @Override
    public void run() throws Exception {
        if (currentProgram == null) {
            println("No program is currently open.");
            return;
        }

        // Generate output filename with timestamp
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        String timestamp = sdf.format(new Date());
        String outputFile = System.getProperty("user.dir") + "/analysis_results/functions_" + timestamp + ".csv";

        println("Exporting functions to: " + outputFile);

        FileWriter fileWriter = new FileWriter(outputFile);
        PrintWriter writer = new PrintWriter(fileWriter);

        // Write CSV header
        writer.println("Address,Name,Size,CallingConvention,ReturnType,Parameters,Namespace,IsThunk,IsExternal");

        FunctionManager functionManager = currentProgram.getFunctionManager();
        FunctionIterator functions = functionManager.getFunctions(true);

        int count = 0;
        while (functions.hasNext()) {
            Function function = functions.next();

            Address entryPoint = function.getEntryPoint();
            String name = function.getName();
            long size = function.getBody().getNumAddresses();
            String callingConvention = function.getCallingConventionName();
            String returnType = function.getReturnType().getName();
            String namespace = function.getParentNamespace().getName();
            boolean isThunk = function.isThunk();
            boolean isExternal = function.isExternal();

            // Get parameters
            StringBuilder params = new StringBuilder();
            Parameter[] parameters = function.getParameters();
            for (int i = 0; i < parameters.length; i++) {
                if (i > 0) params.append("; ");
                params.append(parameters[i].getDataType().getName())
                      .append(" ")
                      .append(parameters[i].getName());
            }

            // Escape commas in strings for CSV
            String paramsStr = params.toString().replace(",", ";");

            writer.printf("%s,\"%s\",%d,%s,%s,\"%s\",%s,%b,%b%n",
                entryPoint,
                name,
                size,
                callingConvention,
                returnType,
                paramsStr,
                namespace,
                isThunk,
                isExternal
            );

            count++;
        }

        writer.close();

        println("Successfully exported " + count + " functions to " + outputFile);
    }
}
