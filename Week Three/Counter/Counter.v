module counter #(
    parameter WIDTH = 5
) (
    input [WIDTH - 1 : 0] cnt_in,
    input enab, load, clk, rst,
    output reg [WIDTH - 1 : 0] cnt_out
);

    always @(posedge clk) begin
        if (rst) begin
            cnt_out <= 0;
        end else if (load) begin
            cnt_out <= cnt_in;
        end else if (enab) begin
            cnt_out <= cnt_out + 1;
        end
    end
    
endmodule
