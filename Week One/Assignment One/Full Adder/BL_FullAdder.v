module BL_FullAdder (
    input A, B, Cin,
    output reg sum, Cout
);

    always @(*) begin
        {Cout, sum} = A + B + Cin;
    end
    
endmodule