`timescale 1ms/1us
module Light_Chaser_tb;
    reg clk, rst_n, hold_n;
    wire [dut.REG_WIDTH - 1 : 0] shift_out;

    Light_Chaser #(
        .REG_WIDTH (10),
        .Clk_in_par (32),
        .Clk_out_par (8)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .hold_n(hold_n),
        .shift_out(shift_out)
    );

    initial begin
        clk = 0;

        forever #15.625 clk = ~clk;
    end

    initial begin
        rst_n = 1;
        hold_n = 1;
        #1;
        rst_n = 0;
        @(posedge clk)
        rst_n = 1;

        @(posedge clk);

        repeat (385)
            @(posedge clk); //waiting for 12 clk cycles ~384 clk in
        
        hold_n = 0;

        repeat (65)
            @(posedge clk);


        $finish;

    end
endmodule