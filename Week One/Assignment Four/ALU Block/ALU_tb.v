`timescale 1ns/1ps

module ALU_tb;

// reg and wire declarations
    reg [5:0] A, B;
    reg Cin;
    reg [2:0] Control;
    wire [5:0] Out;
    wire Cout;

// instantiation 
    ALU dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Control(Control),
        .Out(Out),
        .Cout(Cout)
    );

// testing block 
    initial begin
        //initializing all zeros
        A = 0;
        B = 0;
        Cin = 0;
        Control = 0; // addition = 0

        #10;
        if ({Cout, Out} != 7'd0)
            $display("Error");

        A = 6'd63;
        B = 6'd63;
        Cin = 1'b1;

        // TESTING ADDITION

        #10;
        if ({Cout, Out} != 7'd127)
            $display("Error");  

        A = 6'd0; 
        Control = 3'b001;

        // TESTING SUBTRACTION

        #10;
        if ({Cout, Out} != 7'd64)
            $display("Error"); 

        A = 6'h0A;
        B = 6'h0B;
        Cin = 0;
        Control = 3'b010;

        // TESTING MUX - CASE 0

        #10;
        if (Out != A)
            $display("Error");

        Cin = 1;

        // TESTING MUX - CASE 1

        #10;
        if (Out != B)
            $display("Error");
        
        Control = 3'b011; // A = 001010, -A = 110110

        // TESTING 2'S COMPLEMENT

        #10;
        if (Out != -A)
            $display("Error");

        Control = 3'b100; // A = 001010, B = 001011, A^B= 000001

        // TESTING XOR

        #10;
        if (Out != 6'd1)
            $display("Error");
        
        Control = 3'b101;

        // TESTING EQUALITY CHECK - CASE NOT EQUAL

        #10;
        if (Out)
            $display("Error");

        B = 6'h0A;

        // TESTING EQUALITY CHECK - CASE EQUAL

        #10;
        if (!Out)
            $display("Error");

        Control = 3'b110;

        // TESTING LOGICAL SHIFT 

        #10;
        if (Out != 6'b000101)
            $display("Error");

        Control = 3'b111;
        A = 6'b100100;

        // TESTING ARITHMETIC SHIFT

        #10;
        if (Out != 6'b110010)
            $display("Error");

        $finish;


    end

endmodule