module controller(
    input zero, rst,
    input [2:0] opcode, phase,
    output sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e
);
    localparam HLT = 3'b000;
    localparam SKZ = 3'b001;
    localparam ADD = 3'b010;
    localparam AND = 3'b011;
    localparam XOR = 3'b100;
    localparam LDA = 3'b101;
    localparam STO = 3'b110;
    localparam JMP = 3'b111;

    localparam INST_ADDR = 3'b000;
    localparam INST_FETCH = 3'b001;
    localparam INST_LOAD = 3'b010;
    localparam IDLE = 3'b011;
    localparam OP_ADDR = 3'b100;
    localparam OP_FETCH = 3'b101;
    localparam ALU_OP = 3'b110;
    localparam STORE = 3'b111;


    wire aluop;   
    wire is_halt; 
    wire jmp;  
    wire sto;  
    wire skz; 
    reg [8:0] outs; 

    assign aluop   = (opcode == ADD) || (opcode == AND) || (opcode == XOR) || (opcode == LDA);
    assign is_halt = (opcode == HLT);
    assign jmp  = (opcode == JMP);
    assign sto  = (opcode == STO);
    assign skz  = (opcode == SKZ);
    assign {sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e} = outs;

    always @(*) begin
        if (rst) begin

            outs <= 9'b100000000;

        end else begin
            case (phase)

                INST_ADDR: outs <= 9'b100000000;
                INST_FETCH: outs <= 9'b110000000;
                INST_LOAD: outs <= 9'b111000000;
                IDLE: outs <= 9'b111000000;
                OP_ADDR: outs <= {3'b000 , is_halt , 5'b10000};
                OP_FETCH: outs <= {1'b0 , aluop , 7'd0};
                ALU_OP: outs <= {1'b0 , aluop , 2'b00 , (skz && zero) , 1'b0 , jmp , 1'b0, sto};
                STORE: outs <= {1'b0 , aluop , 3'b000 , aluop , jmp, sto, sto};
                
                default: outs <= 0;
            endcase
        end
    end

endmodule