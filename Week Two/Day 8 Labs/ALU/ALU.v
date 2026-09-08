module alu (
    input [7 : 0] in_a, in_b,
    input [2 : 0] opcode, 
    output reg [7 : 0] alu_out,
    output reg a_is_zero
);
    

    always @(*) begin
        case (opcode)
            3'b000: alu_out = in_a;
            3'b001: alu_out = in_a;
            3'b010: alu_out = in_a + in_b;
            3'b011: alu_out = in_a & in_b;
            3'b100: alu_out = in_a ^ in_b;
            3'b101: alu_out = in_b;
            3'b110: alu_out = in_a;
            3'b111: alu_out = in_a;
            default: alu_out = 0;
        endcase
    end
    
endmodule