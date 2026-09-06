module dec_enc_tb;

    reg [dec_dut.WIDTH_INPUT - 1: 0] dec_in;
    reg en;
    wire [dec_dut.WIDTH_OUTPUT - 1: 0] dec_out;
    wire [dec_dut.WIDTH_INPUT - 1: 0] enc_out;
    integer i;

    Decoder dec_dut(
        .dec_in(dec_in),
        .en(en),
        .dec_out(dec_out)
    );

    Encoder enc_dut(
        .enc_in(dec_out),
        .en(en),
        .enc_out(enc_out)
    );

    initial begin

        en = 1;

        for (i = 0; i < dec_dut.WIDTH_OUTPUT ;i = i + 1 ) begin
            dec_in = i;

            #10;

            if (dec_in != enc_out) begin
                $display("error");
                $stop;
            end
        end

        $finish;
    end


    
endmodule