module RiseEdgeDetect_tb;

    reg clk, level;
    wire tick_moore, tick_mealy;

    RiseEdgeDetect_moore dut_moore (
        .clk(clk),
        .level(level),
        .tick(tick_moore)
    );

    RiseEdgeDetect_mealy dut_mealy (
        .clk(clk),
        .level(level),
        .tick(tick_mealy)
    );


    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        level = 0;

        repeat(2)
            @(posedge clk);

        @(negedge clk);

        #5;

        level = 1;

        repeat(2)
            @(posedge clk);

        @(negedge clk);

        #1;

        level = 0;

        repeat(2)
            @(posedge clk);

        $finish;

    end

    

endmodule