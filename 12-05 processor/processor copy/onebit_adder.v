module onebit_adder(S,Cout,A,B,Cin);
    input A,B,Cin;
    output S,Cout;
    wire w1,w2,w3,w4,w5,w6,w7;

    nand n1(w1,A,B);
    nand n2(w2,A,w1);
    nand n3(w3,w1,B);
    nand n4(w4,w2,w3);
    nand n5(w5,w4,Cin);
    nand n6(w6,w4,w5);
    nand n7(w7,w5,Cin);
    nand n8(Cout,w1,w5);
    nand n9(S,w6,w7);

endmodule