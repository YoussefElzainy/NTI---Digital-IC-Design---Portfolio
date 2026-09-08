module Light_Chaser #(
    parameter REG_WIDTH = 10,
    parameter Clk_in_par = 50_000_000,
    parameter Clk_out_par = 8
) (
    input clk, rst_n, hold_n,
    output [REG_WIDTH - 1:0] shift_out
);
    wire Clk_Out;

    Clk_Divider #(
        .Clk_in_par(Clk_in_par),
        .Clk_out_par(Clk_out_par)
    ) Clk_dut (
        .clk_in(clk),
        .rst_n(rst_n),
        .clk_out(Clk_Out)
    );

    Rotate_Register #(
        .WIDTH(REG_WIDTH)
    ) RS_dut (
        .clk(Clk_Out),
        .rst_n(rst_n),
        .hold_n(hold_n),
        .shift_out(shift_out)
    );
endmodule