module Reg_file(
    input clk, write_en,
    input [2:0] read_add, write_add,
    input [15:0] write_data,
    output reg [15:0] read_data,
    output [7:0] read_data_top_byte
);

    reg [15:0] register_file [7:0]; 
    // memory array with 8 elements 16 bit each

    assign read_data_top_byte = read_data [15:8];

    always @(*) begin
        read_data = register_file [read_add];
    end

    always @(posedge clk) begin
        if (write_en) begin
            register_file [write_add] <= write_data;
        end
    end 

endmodule