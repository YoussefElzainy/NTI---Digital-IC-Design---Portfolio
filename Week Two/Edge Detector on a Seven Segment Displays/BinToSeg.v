module BinToSeg_Decoder (
    input [3:0] Bin_in,
    output reg [6:0] Seg_out
);
    localparam [6:0]
    SEG_0 = 7'b1000000,
    SEG_1 = 7'b1111001,
    SEG_2 = 7'b0100100,
    SEG_3 = 7'b0110000,
    SEG_4 = 7'b0011001,
    SEG_5 = 7'b0010010,
    SEG_6 = 7'b0000010,
    SEG_7 = 7'b1111000,
    SEG_8 = 7'b0000000,
    SEG_9 = 7'b0010000,
    SEG_A = 7'b0001000,
    SEG_B = 7'b0000011,
    SEG_C = 7'b1000110,
    SEG_D = 7'b0100001,
    SEG_E = 7'b0000110,
    SEG_F = 7'b0001110;

    always @(*) begin
        case (Bin_in)
            4'b0000: Seg_out = SEG_0;
            4'b0001: Seg_out = SEG_1;
            4'b0010: Seg_out = SEG_2;
            4'b0011: Seg_out = SEG_3;
            4'b0100: Seg_out = SEG_4;
            4'b0101: Seg_out = SEG_5; 
            4'b0110: Seg_out = SEG_6;
            4'b0111: Seg_out = SEG_7;
            4'b1000: Seg_out = SEG_8;
            4'b1001: Seg_out = SEG_9;
            4'b1010: Seg_out = SEG_A;
            4'b1011: Seg_out = SEG_B;
            4'b1100: Seg_out = SEG_C;
            4'b1101: Seg_out = SEG_D;
            4'b1110: Seg_out = SEG_E;
            4'b1111: Seg_out = SEG_F;

            default: Seg_out = 7'b1111111;
        endcase
    end
    
endmodule