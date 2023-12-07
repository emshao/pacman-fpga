module comp_8(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [7:0] A, B;
    output EQ0, GT0;
    wire EQ32,GT32,EQ21,GT21,EQ10,GT10;

    comp_2 comp_2_3(EQ1, GT1, A[7:6], B[7:6], EQ32, GT32);
    comp_2 comp_2_2(EQ32, GT32, A[5:4], B[5:4], EQ21, GT21);
    comp_2 comp_2_1(EQ21, GT21, A[3:2], B[3:2], EQ10, GT10);
    comp_2 comp_2_0(EQ10, GT10, A[1:0], B[1:0], EQ0, GT0);


endmodule