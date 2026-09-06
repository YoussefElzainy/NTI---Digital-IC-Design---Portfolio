module Decoder #(
    parameter WIDTH_INPUT = 2,
    parameter WIDTH_OUTPUT = 2 ** WIDTH_INPUT 
) (
    input [WIDTH_INPUT - 1 : 0] dec_in,
    input en, 
    output reg [WIDTH_OUTPUT - 1 : 0] dec_out
);

    always @(*) begin
        dec_out = {WIDTH_OUTPUT{1'b0}};
        if (en) begin
            dec_out = 1'b1 << dec_in; // 1 << dec_in
        end else begin
            dec_out = {WIDTH_OUTPUT{1'b0}};
        end
    end
    
endmodule