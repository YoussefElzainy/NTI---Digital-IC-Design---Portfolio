module FullAdder_tb;
    reg [1:0] A, B;
    reg Cin;
    wire [1:0] sum_gl, sum_sl, sum_bl;
    wire Cout_gl,  Cout_sl ,Cout_bl;

    FullAdder_GL dut_gl (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(sum_gl),
        .Cout(Cout_gl)
    );

    FullAdder_SL dut_sl (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(sum_sl),
        .Cout(Cout_sl)
    );


    FullAdder_BL dut_bl (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(sum_bl),
        .Cout(Cout_bl)
    );

    initial begin

        repeat (20) begin
            A = $random;
            B = $random;
            Cin = $random;

            #10;
        end

        $finish;
    end

    initial begin
        $display("============ Levels Comparison ============");

        $monitor("Gate Level: Cout = %b , Sum = %b | Structural Level: Cout = %b , Sum = %b | Behavioral Level: Cout = %b , Sum = %b" , Cout_gl, sum_gl, Cout_sl, sum_sl, Cout_bl, sum_bl);
    end

endmodule