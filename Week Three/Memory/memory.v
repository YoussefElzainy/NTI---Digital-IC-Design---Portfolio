module memory #(
    parameter AWIDTH = 5,
    parameter DWIDTH = 8
)(
    input [AWIDTH - 1 : 0] addr,
    input clk, wr, rd, 
    inout [DWIDTH - 1 :0] data 
);

    reg [7:0] mem [0:31];
    assign data = (rd && !wr) ? mem[addr] : {DWIDTH{1'bz}};


    always @(posedge clk) begin
        if (wr) begin
            mem[addr] <= data; 
        end
    end


    
endmodule
