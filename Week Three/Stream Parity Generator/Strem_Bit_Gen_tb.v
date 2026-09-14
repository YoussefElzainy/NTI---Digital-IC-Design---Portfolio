module Stream_bit_gen_tb;
    reg clk, rst_n, serial_in;
    wire parity_out, valid;
    

    Stream_bit_gen dut (
        .clk(clk),
        .rst_n(rst_n),
        .serial_in(serial_in),
        .parity_out(parity_out),
        .valid(valid)
    );

    task send_all;
        integer i;
        integer j;
        reg exp_parity;

        begin
            for (i = 0; i <= 8'd255; i = i + 1) begin

                for (j = 0; j < 8; j = j + 1) begin
                    serial_in = i[j];
                    @(negedge clk);

                    exp_parity = ^i;

                    if ((exp_parity != parity_out) && valid) begin
                        $display("error");
                        $stop;
                    end
                end

            end
        end
    endtask


    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        serial_in = 0;

        @(posedge clk);
        @(negedge clk);

        rst_n = 1;

        send_all();


        $finish;
    end

    
endmodule