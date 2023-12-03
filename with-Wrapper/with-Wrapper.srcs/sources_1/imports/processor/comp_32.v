module comp_32(A, B, EQ0, GT0);
    input [31:0] A, B;
    output EQ0, GT0;
    wire zero,one;
    wire EQ32,GT32,EQ21,GT21,EQ10,GT10;

    assign zero = 1'b0;
    assign one = 1'b1;

    comp_8 comp_2_3(one, zero, A[31:24], B[31:24], EQ32, GT32);
    comp_8 comp_2_2(EQ32, GT32, A[23:16], B[23:16], EQ21, GT21);
    comp_8 comp_2_1(EQ21, GT21, A[15:8], B[15:8], EQ10, GT10);
    comp_8 comp_2_0(EQ10, GT10, A[7:0], B[7:0], EQ0, GT0);


endmodule