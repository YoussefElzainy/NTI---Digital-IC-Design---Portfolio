module RiseEdgeDetect_mealy(
    input clk, level,
    output reg tick
);

    localparam zero = 2'b00,
               one  = 2'b01; 

    reg [1:0] cs, ns;

    // current state logic
    always @(posedge clk) begin
        cs <= ns;
    end

    // next state logic
    always @(*) begin
        case (cs)
            zero: begin
                if (level)
                    ns = one;
                else 
                    ns = zero;
            end 

            one: begin
                if (level)
                    ns = one;
                else 
                    ns = zero;
            end
            default: ns = zero;
        endcase
    end

    // output logic
    always @(*) begin
        if (cs == zero && level) begin
            tick = 1;
        end else begin
            tick = 0;
        end
    end
    

endmodule