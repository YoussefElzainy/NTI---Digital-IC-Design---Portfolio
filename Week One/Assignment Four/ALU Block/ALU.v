module ALU (
    input [5:0] A, B,
    input Cin, 
    input [2:0] Control,
    output reg [5:0] Out,
    output reg Cout
);

    always @(*) begin
        case (Control)

            3'b000: {Cout, Out} = A + B + Cin;
            3'b001: {Cout, Out} = A - B - Cin;
            3'b010: Out = Cin? B : A;
            3'b011: Out = ~A + 1;
            3'b100: Out = A ^ B;
            3'b101: Out = (A == B)? 1 : 0;
            3'b110: Out = {0 ,A[5:1]};
            3'b111: Out = {A[5], A[5:1]};
            
        endcase
    end
    
endmodule