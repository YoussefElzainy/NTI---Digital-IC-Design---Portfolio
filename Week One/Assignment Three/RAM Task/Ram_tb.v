module Ram_tb;
    reg en, read_en, write_en, clk;
    reg [15:0] data_in;
    reg [5:0] add;
    wire [15:0] data_out;

    Ram dut (
    .en(en),
    .data_in(data_in),
    .add(add),
    .read_en(read_en),
    .write_en(write_en),
    .clk(clk),
    .data_out(data_out)
);

    
    initial begin
        $readmemh("mem_data.mem", dut.mem);
    end

    initial begin
        clk = 0;

        forever begin
            #10 clk = ~clk;
        end
    end

    initial begin
        en = 0;
        read_en = 0;
        write_en = 0;
        data_in = 0;
        add = 0;
        

        @(negedge clk);

        en = 1;
        add = 6'b111110;
        write_en = 1;
        data_in = 16'hABCD;

        @(negedge clk);

        write_en = 0;
        read_en = 1;

        @(negedge clk);

        if (data_out !=  16'hABCD) begin
            $display("Error");
            $stop;
        end

        repeat (50) begin
            write_en = $random;
            read_en = $random;
            add = $random;

            @(negedge clk);
        end

        $finish;
    end

    
endmodule