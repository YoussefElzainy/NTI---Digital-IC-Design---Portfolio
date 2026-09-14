module Stream_bit_gen (
    input clk, rst_n, serial_in,
    output reg parity_out, valid
);

    reg [7:0] data;
    reg [2:0] cntr;

    always @(posedge clk) begin
        if (!rst_n) begin
            cntr <= 0;
        end else begin
            if (cntr < 7) begin
                cntr <= cntr + 1;
                valid <= 0;
            end else begin
                valid <= 1;
                cntr <= 0;
            end
        end
        
    end

    always @(posedge clk) begin
        if (!rst_n)
            data <= 8'b0;
        else
            data <= {data[6:0], serial_in};
    end


    function parity;
        input [7:0] data;

        begin
            parity = ^data;
        end
    endfunction

    always @(posedge clk) begin
        if (!rst_n) begin
            parity_out <= 1'b0;
            cntr <= 0;
            valid <= 0;
        end
            
        else
            parity_out <= parity(data);
    end



endmodule