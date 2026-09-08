module Tri_State_Buffer (
    inout [7:0] shared_bus,
    input [7:0] Tx_data,
    input Tx_en
);

    assign shared_bus = Tx_en? Tx_data : 8'hzz;
    
endmodule