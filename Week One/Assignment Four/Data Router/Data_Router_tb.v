module Data_scrambler_tb;

    reg signed [7:0] data_in;
    reg [1:0] scramble_key, op_mode;
    reg sleep_mode;
    wire [7:0] data_out;
    wire parity_err, is_zero;
    integer i;

    Data_scrambler dut (
        .data_in(data_in),
        .scramble_key(scramble_key),
        .op_mode(op_mode),
        .sleep_mode(sleep_mode),
        .data_out(data_out),
        .parity_err(parity_err),
        .is_zero(is_zero)
    );

    initial begin
        sleep_mode = 1;

        #10;

        sleep_mode = 0;

        for (i = 0; i < 4 ; i = i + 1 ) begin
            op_mode = i;
            data_in = 8'hA8; //10101000
            scramble_key = 2'b10;
            
           
            #10;

            if (op_mode == 2'b10) begin
                if (data_out != 8'b11101010) begin
                    $display("ERROR");
                    $stop;
                end
            end

        end

        $finish;
    end
    
endmodule