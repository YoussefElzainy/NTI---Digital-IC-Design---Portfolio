module FullAdder_GL (
    input [1:0] A, B,
    input Cin,
    output [1:0] Sum,
    output Cout
);

    wire Xor1, Xor2, or1, And1, And2, And3, And4;

    xor(Xor1, A[1], B[1]);
    xor(Xor2, A[0], B[0]);
    and(And1, A[1], B[1]);
    and(And2, A[0], B[0]);
    or(or1, And4, And2);
    and(And3, Xor1, or1);
    and(And4, Xor2, Cin);
    xor(Sum[1], or1, Xor1);
    or(Cout, And3, And1);
    xor(Sum[0], Cin, Xor2);
    
    
endmodule