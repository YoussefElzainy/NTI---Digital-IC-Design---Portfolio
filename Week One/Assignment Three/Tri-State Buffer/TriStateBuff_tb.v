module Tri_State_Buffer_tb;

    wire [7:0] shared_bus;
    reg [7:0] Tx_data;
    reg Tx_en;

    Tri_State_Buffer dut (
        .shared_bus(shared_bus),
        .Tx_data(Tx_data),
        .Tx_en(Tx_en)
    );

    initial begin
        repeat(20) begin
            Tx_data = $random;
            Tx_en = $random;

            #10;

            if (!Tx_en && shared_bus !== 8'hzz) begin
                $display("Error");
                $finish;
            end
        end

        $finish;
    end


endmodule