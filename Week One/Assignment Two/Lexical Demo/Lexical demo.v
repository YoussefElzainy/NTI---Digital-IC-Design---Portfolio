/*
Lab: Verilog Lexical Conventions
Description: Demonstrates identifiers, numbers, strings, and attributes.
*/
// TODO: Add a module-level attribute here (e.g., (* optimize = "off" *))
module lexical_demo;
// TODO:
    // 1. Strings
    // A string requires 8 bits per character. "Hello World" is 11 characters.
    // Declare a register named ‘my_string’
    reg [87:0] my_string;
    // 2. Case Sensitivity & Identifiers
    // Declare two 8-bit registers named 'Data_Val' and 'data_val'
    reg [7:0] Data_Val, data_val;
    // 3. Logic Values & Literal Integers
    // Declare a 12-bit register named 'mixed_logic'
    reg [11:0] mixed_logic;
    // 4. Literal Real Numbers
    // Declare a 'real' variable named 'analog_voltage'
    real analog_voltage;
    // 5. Attributes on variables
    // use (* keep = "true" *) to a net called ‘protected_wire’
    (* keep = "true" *)
    wire protected_wire;


    initial begin
        // --- Assignments ---
// TODO:
        // String assignment
        
        // TODO: assign "Hello World" to my_string
        my_string = "Hello World";

        //----------------------------------------------------------------

        // TODO: Assign 8'hAA to 'Data_Val' and 8'h55 to 'data_val'
        
        Data_Val = 8'hAA;
        data_val = 8'h55;

        // TODO: Assign a 12-bit binary number to 'mixed_logic' (1, 0, x, z)
        mixed_logic = 12'b111_000_xxx_zzz;
        // Example: 12'b1010_xxxx_zzzz;

        //----------------------------------------------------------------


        // TODO: Assign a real number to 'analog_voltage' (e.g., 3.3e-3)
        
        analog_voltage = 3.3e-3;

        // --- Display Results ---
        // $display statements automatically print to the console.
        $display("--- Lexical Conventions Output ---");
        $display("String Value: %s", my_string);
        // TODO: Add $display statements to print variables.

        $display("Data_Val: %h", Data_Val);
        $display("data_val: %h", data_val);

        $display("Mixed Logic (binary): %b", mixed_logic);
        $display("Mixed Logic (hex): %h", mixed_logic);

        $display("Analog Voltage: %f", analog_voltage);
        // Hint: Use %h for hex, %b for binary, and %f for real numbers.
        $finish;
    end
endmodule