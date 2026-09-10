module EdgeDisplay_Top (
    input clk, rst_n,
    input  [3:0] Rise_count, Fall_count, Total_count,
    output reg [6:0] Seg_R, Seg_Rise, Seg_F, Seg_Fall, Seg_t, Seg_Total
);

    wire [6:0] rise_seg, fall_seg, total_seg;


    BinToSeg_Decoder rise_decoder (
        .Bin_in(Rise_count),
        .Seg_out(rise_seg)
    );

    BinToSeg_Decoder fall_decoder (
        .Bin_in(Fall_count),
        .Seg_out(fall_seg)
    );

    BinToSeg_Decoder total_decoder (
        .Bin_in(Total_count),
        .Seg_out(total_seg)
    );

    always @(*) begin
        if (!rst_n) begin
            
            Seg_R     = 7'b1001000;
            Seg_Rise  = 7'b1000001;
            Seg_F     = 7'b1000111;
            Seg_Fall  = 7'b1000111;
            Seg_t     = 7'b1111111;
            Seg_Total = 7'b1111111;
        end
        else begin
            
            Seg_R = 7'b0001000;   // R
            Seg_F = 7'b0001110;   // F
            Seg_t = 7'b0000111;   // t

            
            Seg_Rise  = rise_seg;
            Seg_Fall  = fall_seg;
            Seg_Total = total_seg;
        end
    end

endmodule