module grid_mem_router #(
    parameter WORD_WIDTH = 32
)(
    input clk, rst, out_en, endian_swap, col_add,
    input [1:0] row_add,
    output reg [WORD_WIDTH - 1:0] processing_word,
    inout [7:0] bus_data
);

    reg [7:0] fabric_mem [3:0] [1:0];
    // grid memory with 4 rows and 2 columns each address is 8 bits wide

    assign bus_data = out_en? fabric_mem[row_add][col_add] : 8'hzz;
    // tri state buffer logic

    integer i;

    always @(posedge clk or posedge rst) begin
        

        if (rst) begin
            processing_word <= 0;
        end else begin
            
            for (i = 0;i < 4;i = i+1) begin
            if (endian_swap) begin
                processing_word[(WORD_WIDTH - 8*i - 1) -: 8] <= fabric_mem [i] [0];
                // endianness swap
            end else begin
                processing_word[8*i +: 8] <= fabric_mem [i] [0];
                // copying the first column
            end
        end

        end
        
    end

    
endmodule