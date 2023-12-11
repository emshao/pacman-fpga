module full_adder(S,Cout,A,B,Cin);
    input A,B,Cin;
    output S,Cout;
    wire w1,w2,w3;

    xor Sresult(S,A,B,Cin);

    and AandB(w1,A,B);
    and AandCin(w2,A,Cin);
    and BandCin(w3,B,Cin);

    or CoutResult(Cout,w1,w2,w3);

endmodule