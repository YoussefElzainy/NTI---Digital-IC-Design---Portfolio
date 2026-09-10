module Edge_Counter (
    input clk, Rise_tick, Fall_Tick, Edge_tick, rst_n,
    output reg [3:0] Rise_count, Fall_Count, Total_Count
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
          Rise_count <= 0;
          Fall_Count <= 0;
          Total_Count <= 0;
        end else begin
          if (Rise_tick) begin
            Rise_count <= Rise_count + 1;
          end 

          if (Fall_Tick) begin
            Fall_Count <= Fall_Count + 1;
          end

          if (Edge_tick) begin
            Total_Count <= Total_Count + 1;
          end
        end
    end
    
endmodule