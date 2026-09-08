module HalfAdder (
    input A, B,
    output sum, Cout
);

    xor (sum, A, B);
    and (Cout, A, B);
    
endmodule