module Ram (
    input en,
    input [15:0] data_in,
    input [5:0] add,
    input read_en, write_en, clk,
    output reg [15:0] data_out
);

    reg [15:0] mem [63:0]; // 64 x 16 memory

    
    
    always @(posedge clk) begin
        if (en) begin
            case ({read_en , write_en})

                2'b01: begin
                    mem [add] <= data_in;
                end 

                2'b10: begin
                    data_out <= mem [add];
                end

            endcase
        end
    end
    
endmodule