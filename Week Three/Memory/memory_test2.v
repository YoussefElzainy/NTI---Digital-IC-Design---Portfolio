module memory_tb;

    localparam AWIDTH = 5;
    localparam DWIDTH = 8;

    reg clk;
    reg wr;
    reg rd;
    reg [AWIDTH-1:0] addr;

    reg [DWIDTH-1:0] data_in;
    wire [DWIDTH-1:0] data;

    assign data = (wr && !rd) ? data_in : {DWIDTH{1'bz}};

    memory #(
        .AWIDTH(AWIDTH),
        .DWIDTH(DWIDTH)
    ) dut (
        .addr(addr),
        .clk(clk),
        .wr(wr),
        .rd(rd),
        .data(data)
    );

    always #5 clk = ~clk;

    task write_mem;
        input [AWIDTH-1:0] write_addr;
        input [DWIDTH-1:0] write_data;

        begin
            @(negedge clk);
            addr = write_addr;
            data_in = write_data;
            wr = 1;
            rd = 0;

            @(posedge clk);
            #1;

            wr = 0;
            data_in = 0;
        end
    endtask

    task read_mem;
        input [AWIDTH-1:0] read_addr;
        input [DWIDTH-1:0] expected_data;

        begin
            @(negedge clk);
            addr = read_addr;
            wr = 0;
            rd = 1;

            #1;

            if (data === expected_data)
                $display("PASS: ADDR=%0d DATA=%h", read_addr, data);
            else
                $display("FAIL: ADDR=%0d EXPECTED=%h ACTUAL=%h",
                         read_addr, expected_data, data);

            @(negedge clk);
            rd = 0;
        end
    endtask

    initial begin
        clk = 0;
        wr = 0;
        rd = 0;
        addr = 0;
        data_in = 0;

        #10;

        write_mem(5, 8'hA5);
        write_mem(10, 8'h3C);
        write_mem(20, 8'hF0);

        read_mem(5, 8'hA5);
        read_mem(10, 8'h3C);
        read_mem(20, 8'hF0);


        #10;
        $finish;
    end

endmodule
