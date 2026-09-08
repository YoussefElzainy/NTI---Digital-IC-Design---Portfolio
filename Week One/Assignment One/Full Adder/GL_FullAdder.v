module GL_FullAdder (
    input A, B, Cin, 
    output sum, Cout
);
    
    wire xor1, and1, and2;

    xor (xor1, A, B);
    and (and1, A, B);
    and (and2, xor1, Cin);
    xor (sum, xor1, Cin);
    or (Cout, and2, and1);    
endmodule
