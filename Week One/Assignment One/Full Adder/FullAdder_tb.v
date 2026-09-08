module FullAdder_tb;

    reg A, B, Cin;
    wire sum_Bl, Cout_BL, sum_Sl, Cout_SL, sum_Gl, Cout_GL;
    integer i;

    BL_FullAdder dut_bl (
        .A(A),
        .B(B),
        .Cin(Cin),
        .sum(sum_Bl),
        .Cout(Cout_BL)
    );

     SL_FullAdder dut_sl (
        .A(A),
        .B(B),
        .Cin(Cin),
        .sum(sum_Sl),
        .Cout(Cout_SL)
    );

     GL_FullAdder dut_gl (
        .A(A),
        .B(B),
        .Cin(Cin),
        .sum(sum_Gl),
        .Cout(Cout_GL)
    );

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            {Cin, B, A} = i; 
            #10;
            
            // assign values to inputs from 000 till 111 
            // so that all possibilities would be included
        end

        $stop;
    end
    
endmodule