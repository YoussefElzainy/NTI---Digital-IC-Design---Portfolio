module MultiFuncALU_tb;

    reg [7:0] A, B;
    reg Cin;
    reg [4:0] Control;
    wire [15:0] Out;

    MultiFuncALU dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Control(Control),
        .Out(Out)
    );

    task test_operation;
        input [4:0] ctrl;
        input [7:0] test_A;
        input [7:0] test_B;
        input test_Cin;

        begin
            Control = ctrl;
            A = test_A;
            B = test_B;
            Cin = test_Cin;

            #10;

            $display(
                "Control=%b | A=%h | B=%h | Cin=%b | Out=%h",
                Control, A, B, Cin, Out
            );
        end
    endtask

    initial begin


        // Arithmetic Operations
        test_operation(5'b00000, 8'h05, 8'h03, 0); // A + B
        test_operation(5'b00001, 8'h05, 8'h03, 1); // A + B + Cin
        test_operation(5'b00010, 8'h08, 8'h03, 1); // A - B + Cin
        test_operation(5'b00011, 8'h08, 8'h03, 0); // A - B
        test_operation(5'b00100, 8'hFF, 8'h00, 0); // A + 1 edge case
        test_operation(5'b00101, 8'h00, 8'h00, 0); // A - 1 edge case
        test_operation(5'b00110, 8'hFF, 8'hFF, 0); // Maximum multiplication

        // Logical Operations
        test_operation(5'b00111, 8'hAA, 8'h55, 0); // AND
        test_operation(5'b01000, 8'hAA, 8'h55, 0); // OR
        test_operation(5'b01001, 8'hAA, 8'h55, 0); // XOR
        test_operation(5'b01010, 8'hAA, 8'h00, 0); // NOT
        test_operation(5'b01011, 8'hAA, 8'h55, 0); // NAND

        // Shift Operations
        test_operation(5'b01100, 8'b00001111, 8'd2, 0); // Logical left
        test_operation(5'b01101, 8'b11110000, 8'd2, 0); // Logical right
        test_operation(5'b01110, 8'b00001111, 8'd2, 0); // Arithmetic left
        test_operation(5'b01111, 8'b11110000, 8'd2, 0); // Arithmetic right

        // Rotate Operations
        test_operation(5'b10000, 8'b10110010, 8'd2, 0); // ROR
        test_operation(5'b10001, 8'b10110010, 8'd2, 0); // ROL

        // Comparison 
        test_operation(5'b10010, 8'h10, 8'h20, 0); // MAX
        test_operation(5'b10010, 8'h30, 8'h20, 0); // MAX

        test_operation(5'b10011, 8'hAA, 8'h55, 0); // Cin = 0
        test_operation(5'b10011, 8'hAA, 8'h55, 1); // Cin = 1

        // Swap / Complement
        test_operation(5'b10100, 8'h12, 8'h34, 0);

        // Comparison 
        test_operation(5'b10101, 8'h20, 8'h20, 0); // Equal
        test_operation(5'b10101, 8'h30, 8'h20, 0); // A > B
        test_operation(5'b10101, 8'h10, 8'h20, 0); // A < B

        // Parity
        test_operation(5'b10110, 8'hAA, 8'h55, 0);
        test_operation(5'b10110, 8'hFF, 8'h00, 0);

        // Edge Cases
        $display(" EDGE CASES ");

        test_operation(5'b00000, 8'hFF, 8'h01, 0);
        test_operation(5'b00011, 8'h00, 8'h01, 0);

        test_operation(5'b00111, 8'hFF, 8'hFF, 0);
        test_operation(5'b01000, 8'h00, 8'h00, 0);
        test_operation(5'b01001, 8'hFF, 8'hFF, 0);

        test_operation(5'b01100, 8'h01, 8'd7, 0);
        test_operation(5'b01101, 8'h80, 8'd7, 0);

        // Shift by zero
        test_operation(5'b01100, 8'hA5, 8'd0, 0);
        test_operation(5'b01101, 8'hA5, 8'd0, 0);

        // Shift by maximum amount
        test_operation(5'b01100, 8'hA5, 8'd8, 0);
        test_operation(5'b01101, 8'hA5, 8'd8, 0);

        // Maximum values
        test_operation(5'b10010, 8'hFF, 8'h00, 0);
        test_operation(5'b10010, 8'h00, 8'hFF, 0);


        $finish;
    end

endmodule