module Debouncing_cir #(
    parameter clk_freq = 50_000_000,
    parameter cntr_top = 5
) (
    input clk, sw,
    output reg db1
);

    localparam zero = 3'b000,
               wait1_1 = 3'b001,
               wait1_2 = 3'b010,
               wait1_3 = 3'b011,
               wait0_3 = 3'b100,
               wait0_2 = 3'b101,
               wait0_1 = 3'b110,
               one = 3'b111;

    reg [2:0] cs, ns;
    reg m_tick;
    reg [2:0] cntr;

    // counter logic 
    always @(posedge clk) begin
        if (cntr < (cntr_top - 1)) begin
            m_tick <= 0;
            cntr <= cntr + 1;
        end else begin
            m_tick <= 1;
            cntr <= 0;
        end
    end


    // current state logic 
    always @(posedge clk) begin
        cs <= ns;
    end 

    // next state logic 
    always @(*) begin
        case (cs)
            zero: begin
                if (!sw) 
                    ns = zero;
                else 
                    ns = wait1_1;
            end 

            wait1_1: begin
                if (!sw) 
                    ns = zero;
                else if (sw && !m_tick)
                    ns = wait1_1;
                else if (sw && m_tick)
                    ns = wait1_2;
            end

            wait1_2: begin
                if (!sw) 
                    ns = zero;
                else if (sw && !m_tick)
                    ns = wait1_2;
                else if (sw && m_tick)
                    ns = wait1_3;
            end

            wait1_3: begin
                if (!sw) 
                    ns = zero;
                else if (sw && !m_tick)
                    ns = wait1_3;
                else if (sw && m_tick)
                    ns = one;
            end

            one: begin
                if (sw)
                    ns = one;
                else 
                    ns = wait0_1; 
            end

            wait0_1: begin
                if (sw)
                    ns = one;
                else if (!sw && !m_tick)
                    ns = wait0_1;
                else if (!sw && m_tick) 
                    ns = wait0_2;
            end

            wait0_2: begin
                if (sw)
                    ns = one;
                else if (!sw && !m_tick)
                    ns = wait0_2;
                else if (!sw && m_tick) 
                    ns = wait0_3;
            end

            wait0_3: begin
                if (sw)
                    ns = one;
                else if (!sw && !m_tick)
                    ns = wait0_3;
                else if (!sw && m_tick) 
                    ns = zero;
            end
            default: ns = zero;
        endcase
    end

    // output logic 
    always @(*) begin
        if (cs == one || cs == wait0_1 || cs == wait0_2 || cs == wait0_3) begin
            db1 = 1;
        end else begin
            db1 = 0;
        end
    end
    
endmodule