module GrayToSeg_Decoder_tb;
    reg [3:0] gray_in;
    wire [6:0] Seg_out;
    integer i;

    GrayToSeg dut (
        .Gray_in(gray_in),
        .Seg_out(Seg_out)
    );

    initial begin
        for (i = 0; i < 16 ; i = i + 1 ) begin
            gray_in = i;

            #10;
        end
        $finish;
    end

    
    
endmodule