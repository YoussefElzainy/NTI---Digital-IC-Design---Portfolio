module data_router_tb;
    reg [31:0] data_in;
    wire [7:0] byte_high, byte_low;
    wire parity_bit;

    data_router dut (
        .data_in(data_in),
        .byte_high(byte_high),
        .byte_low(byte_low),
        .parity_bit(parity_bit)
    );

    initial begin

        repeat(30) begin
            data_in = $random;

            #10;

            $monitor("data in = %h, byte high = %h, byte low = %h, parity bit = %b", data_in, byte_high, byte_low, parity_bit);
        end

        $finish;
    end

endmodule
