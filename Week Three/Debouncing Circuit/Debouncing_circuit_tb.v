module Debouncing_cir_tb ;

    reg clk, sw;
    wire db1;

    Debouncing_cir dut (
        .clk(clk),
        .sw(sw),
        .db1(db1)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        sw = 0;

        @(posedge clk);
        @(negedge clk);

        repeat(75) begin
            sw = ~sw;
            #2;
        end

        sw = 1;

        repeat (20) begin
            @(posedge clk);
        end

        @(negedge clk);

        repeat(75) begin
            sw = ~sw;
            #2;
        end

        sw = 0;

        repeat (20) begin
            @(posedge clk);
        end

        $finish;
    end
    
endmodule