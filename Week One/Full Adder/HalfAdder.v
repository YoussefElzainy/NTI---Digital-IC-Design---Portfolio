module HalfAdder (
    input A, B,
    output Sum, Cout
);

assign {Cout, Sum} = A + B;
    
endmodule