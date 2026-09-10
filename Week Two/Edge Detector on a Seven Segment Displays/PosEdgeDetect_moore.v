module RiseEdgeDetect_moore(
    input clk, level, rst_n,
    output reg tick 
);

    localparam zero = 2'b00,
               edg= 2'b01,
               one  = 2'b10;

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
                if (!level) 
                    ns = zero;
                else 
                    ns = edg;
                
            end 

            edg: begin
                if (!level)
                    ns = zero;
                else 
                    ns = one;
            end

            one: begin
                if (!level)
                    ns = zero;
                else 
                    ns = one; 
            end
            default: ns = zero;
        endcase
    end

    // output logic
    always @(*) begin
        if (cs == edg) begin
            tick = 1;
        end else begin
            tick = 0;
        end
    end

endmodule