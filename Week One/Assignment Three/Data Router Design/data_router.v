module data_router(
    input [31:0] data_in,
    output reg [7:0] byte_high,
    output [7:0] byte_low,
    output parity_bit
);

    assign byte_low = data_in[7:0];
    assign parity_bit = ^data_in; 
    // reductional XOR is used to get the parity bit 

    always @(*) begin
        byte_high = data_in[31:24];
    end

endmodule