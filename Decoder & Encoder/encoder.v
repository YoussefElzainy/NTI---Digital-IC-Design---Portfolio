module Encoder #(
    parameter WIDTH_INPUT = 4,
    parameter  WIDTH_OUTPUT = $clog2(WIDTH_INPUT) 
) (
    input [WIDTH_INPUT - 1 : 0] enc_in,
    input en, 
    output reg [WIDTH_OUTPUT - 1 : 0] enc_out
);

    integer i;

    always @(*) begin
        if (en) begin

          for (i = 0;i < WIDTH_INPUT ; i = i + 1 ) begin
            if (enc_in[i]) 
                enc_out = i;
          end
          
        end else begin
            enc_out = 0;
        end
    end
    
endmodule