module Rotate_Register #(
    parameter WIDTH = 10
)(
    input clk, rst_n, hold_n,
    output reg [WIDTH - 1:0] shift_out 
);

    always @(posedge clk or negedge rst_n) begin 
        if (!rst_n) begin
            shift_out <= {1, {(WIDTH - 1){1'b0}}}; 
        end else if (hold_n) begin
            shift_out <= {shift_out[0] , shift_out[WIDTH - 1:1]}; 
        end
    end

    
endmodule


