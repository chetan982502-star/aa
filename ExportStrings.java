// Export all defined strings from the analyzed binary to a text file
// @category Analysis

import ghidra.app.script.GhidraScript;
import ghidra.program.model.listing.*;
import ghidra.program.model.address.*;
import ghidra.program.model.data.*;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ExportStrings extends GhidraScript {

    @Override
    public void run() throws Exception {
        if (currentProgram == null) {
            println("No program is currently open.");
            return;
        }

        // Generate output filename with timestamp
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        String timestamp = sdf.format(new Date());
        String outputFile = System.getProperty("user.dir") + "/analysis_results/strings_" + timestamp + ".txt";

        println("Exporting strings to: " + outputFile);

        FileWriter fileWriter = new FileWriter(outputFile);
        PrintWriter writer = new PrintWriter(fileWriter);

        writer.println("=" .repeat(80));
        writer.println("STRINGS EXPORT FROM: " + currentProgram.getName());
        writer.println("Generated: " + new Date());
        writer.println("=" .repeat(80));
        writer.println();

        Listing listing = currentProgram.getListing();
        DataIterator dataIterator = listing.getDefinedData(true);

        int count = 0;
        while (dataIterator.hasNext()) {
            Data data = dataIterator.next();
            DataType dataType = data.getDataType();

            // Check if it's a string type
            if (dataType instanceof StringDataType ||
                dataType instanceof UnicodeDataType ||
                dataType instanceof TerminatedStringDataType ||
                dataType instanceof TerminatedUnicodeDataType) {

                Address address = data.getAddress();
                Object value = data.getValue();
                String stringValue = value != null ? value.toString() : "";

                // Get references to this string
                int refCount = getReferencesTo(address).length;

                writer.println("-".repeat(80));
                writer.println("Address: " + address);
                writer.println("Type:    " + dataType.getName());
                writer.println("Length:  " + stringValue.length() + " chars");
                writer.println("XRefs:   " + refCount);
                writer.println("Value:   " + stringValue);
                writer.println();

                count++;
            }
        }

        writer.println("=" .repeat(80));
        writer.println("Total strings found: " + count);
        writer.println("=" .repeat(80));

        writer.close();

        println("Successfully exported " + count + " strings to " + outputFile);
    }
}
