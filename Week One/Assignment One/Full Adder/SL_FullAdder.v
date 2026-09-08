module SL_FullAdder (
    input A, B, Cin,
    output sum, Cout
);

    wire xor1, and1, and2;

    HalfAdder HA1 (
        .A(A),
        .B(B),
        .sum(xor1),
        .Cout(and1)
    );

    HalfAdder HA2 (
        .A(xor1),
        .B(Cin),
        .sum(sum),
        .Cout(and2)
    );

    assign Cout = and1 | and2;
    
endmodule