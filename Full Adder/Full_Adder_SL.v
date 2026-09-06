module FullAdder_SL (
    input [1:0] A, B,
    input Cin,
    output [1:0] Sum,
    output Cout
);

    wire c1; 

    FullAdder FA1 (
        .A(A[1]),
        .B(B[1]),
        .Cin(c1),
        .Cout(Cout),
        .Sum(Sum[1])
    );

    FullAdder FA2 (
        .A(A[0]),
        .B(B[0]),
        .Cin(Cin),
        .Cout(c1),
        .Sum(Sum[0])
    );


endmodule