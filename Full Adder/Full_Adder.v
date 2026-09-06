module FullAdder(
    input A, B, Cin, 
    output Cout, Sum
);
    
    wire Xor1, And1, And2;

    HalfAdder HA1 (
        .A(A),
        .B(B),
        .Cout(And1),
        .Sum(Xor1)
    );

    HalfAdder HA2 (
        .A(Xor1),
        .B(Cin),
        .Cout(And2),
        .Sum(Sum)
    );

    assign Cout = And1|And2;

endmodule