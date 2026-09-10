module Clk_Divider #(
    parameter Clk_in_par = 50_000_000,
    parameter Clk_out_par = 8
) (
    input clk_in, rst_n, 
    output reg clk_out
);

    localparam Cycles = Clk_in_par/Clk_out_par;
    localparam COUNTER_WIDTH = $clog2(Cycles);

    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            clk_out <= 0;
        end
        else if (counter == (Cycles/2) - 1) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
        else begin
            counter <= counter + 1'b1;
        end
    end




    
endmodule