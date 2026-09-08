module Data_scrambler (
    input signed [7:0] data_in,
    input [1:0] scramble_key, op_mode,
    input sleep_mode,
    output reg [7:0] data_out,
    output  parity_err, 
    output  is_zero
);
    
    assign parity_err = ~^data_out;
    assign is_zero = !data_out;

    always @(*) begin
        if (sleep_mode)
            data_out = 8'd0;
        else begin
            case (op_mode)
                2'b00: data_out = data_in;
                2'b01: data_out = data_in ^ {4{scramble_key}};
                2'b10: data_out = data_in >>> 2;
                2'b11: data_out = {data_in[3:0], data_in[7:4]};
                default: data_out = 8'd0;
            endcase
        end
    end 
endmodule