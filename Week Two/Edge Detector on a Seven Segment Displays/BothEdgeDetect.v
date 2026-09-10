module BothEdgeDetect (
    input clk, rst_n, level,
    output reg tick
);

    localparam zero = 2'b00,
               high_edg= 2'b01,
               low_edg = 2'b10,
               one  = 2'b11;

    reg [1:0] cs, ns;


    // curret state logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          cs <= zero; 
        end else begin
          cs <= ns;
        end
        
    end

    // next state logic 
    always @(*) begin
      case (cs)
        zero: begin
          if (level) begin
            ns = high_edg;
          end else begin
            ns = zero;
          end
        end

        high_edg: begin
          if (level) begin
            ns = one;
          end else begin
            ns = low_edg;
          end
        end

        low_edg: begin
          if (level)
            ns = high_edg;
          else 
            ns = zero;
        end

        one: begin
          if (level) begin
            ns = one;
          end else begin
            ns = low_edg;
          end
        end

        default: ns = zero;
      endcase
    end

    // output logic
    always @(*) begin
        if (cs == high_edg || cs == low_edg) begin
            tick = 1;
        end else begin
            tick = 0;
        end
    end
    
endmodule