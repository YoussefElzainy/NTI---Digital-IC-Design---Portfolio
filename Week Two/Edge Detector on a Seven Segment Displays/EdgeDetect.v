module EdgeDetect (
    input clk, rst_n, level,
    output [6:0] rseg, rcseg, fseg, fcseg, tseg, tcseg
);

    wire clk_100hz; 
    wire tick_rise, tick_fall, tick_edge;
    wire [3:0] Rise_count, Fall_Count, Total_Count;

    Clk_Divider #(
        .Clk_in_par(1000),
        .Clk_out_par(100)
    ) clk_inst (
        .clk_in(clk),
        .rst_n(rst_n),
        .clk_out(clk_100hz)
    );

    BothEdgeDetect isnt_both (
        .clk(clk_100hz),
        .level(level),
        .rst_n(rst_n),
        .tick(tick_edge)
    );

    RiseEdgeDetect_moore inst_rise (
        .clk(clk_100hz),
        .level(level),
        .rst_n(rst_n),
        .tick(tick_rise)
    );

    FallEdgeDetect inst_fall (
        .clk(clk_100hz),
        .level(level),
        .rst_n(rst_n),
        .tick(tick_fall)
    );

     Edge_Counter inst_ctr (
        .clk(clk_100hz),
        .Rise_tick(tick_rise),
        .Fall_Tick(tick_fall),
        .Edge_tick(tick_edge),
        .rst_n(rst_n),
        .Rise_count(Rise_count),
        .Fall_Count(Fall_Count),
        .Total_Count(Total_Count)
     );


    EdgeDisplay_Top display_inst (
        .rst_n(rst_n),

        .Rise_count(Rise_count),
        .Fall_count(Fall_Count),
        .Total_count(Total_Count),

        .Seg_R(rseg),
        .Seg_Rise(rcseg),
        .Seg_F(fseg),
        .Seg_Fall(fcseg),
        .Seg_t(tseg),
        .Seg_Total(tcseg)
    );


    
endmodule