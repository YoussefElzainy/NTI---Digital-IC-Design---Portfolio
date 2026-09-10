`timescale 1us/1ns
module EdgeDetect_tb;

    reg clk, rst_n, level;
    wire [6:0] rseg, rcseg, fseg, fcseg, tseg, tcseg;

    EdgeDetect dut (
        .clk(clk),  
        .rst_n(rst_n),
        .level(level),
        .rseg(rseg),
        .rcseg(rcseg),
        .fseg(fseg),
        .fcseg(fcseg),
        .tseg(tseg),
        .tcseg(tcseg)
    );


    initial begin
        clk = 0;
        forever #500 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        level = 0;

        repeat(2001) begin
            @(negedge clk);
          end

        rst_n = 1;

        repeat (20) begin
          level = $random;

          repeat(2001) begin
            @(negedge clk);
          end
        end

        $finish;
    end
    
endmodule