module GrayToSeg (
    input [3:0] Gray_in,
    output [6:0] Seg_out
);
    wire [3:0] bin_out_in;
  GrayToBinary_gate dut_gray (
    .gray(Gray_in),
    .binary(bin_out_in)
  );  

  BinToSeg_Decoder dutseg (
    .Bin_in(bin_out_in),
    .Seg_out(Seg_out)
  );
    
endmodule