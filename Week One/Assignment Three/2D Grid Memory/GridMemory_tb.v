module grid_mem_router_tb;
    reg clk, rst, out_en, endian_swap, col_add;
    reg [1:0] row_add;
    wire [dut.WORD_WIDTH - 1:0] processing_word;
    wire [7:0] bus_data;

    grid_mem_router dut (
        .clk(clk),
        .rst(rst),
        .out_en(out_en),
        .endian_swap(endian_swap),
        .col_add(col_add),
        .row_add(row_add),
        .processing_word(processing_word),
        .bus_data(bus_data)
    );

    initial begin
        dut.fabric_mem[0][0] = 8'hAA;
        dut.fabric_mem[0][1] = 8'h11;

        dut.fabric_mem[1][0] = 8'hBB;
        dut.fabric_mem[1][1] = 8'h22;

        dut.fabric_mem[2][0] = 8'hCC;
        dut.fabric_mem[2][1] = 8'h33;

        dut.fabric_mem[3][0] = 8'hDD;
        dut.fabric_mem[3][1] = 8'h44;

        // filling the memory with dummy data 3shan maytla3sh unkown values X
    end

    initial begin
        clk = 0;
        forever begin
            #10 clk = ~clk;
        end
    end

    initial begin
        rst = 1;
        out_en = 0;
        endian_swap = 0;
        col_add = 0;
        row_add = 0;
        
        @(negedge clk);

        rst = 0;

        repeat(25) begin
            out_en = $random;
            endian_swap = $random;
            col_add = $random;
            row_add = $random;

            @(negedge clk);
        end

        $finish;

    end
endmodule