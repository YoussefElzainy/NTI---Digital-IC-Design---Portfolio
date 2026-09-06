module FullAdder_BL(
    input [1:0] A, B,
    input Cin,
    output reg [1:0] Sum,
    output reg Cout
);

    always @(*) begin
        {Cout, Sum} = A + B + Cin;
    end


endmodule