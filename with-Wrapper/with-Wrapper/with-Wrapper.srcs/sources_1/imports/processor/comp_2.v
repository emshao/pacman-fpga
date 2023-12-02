module comp_2(EQ1, GT1, A, B, EQ0, GT0);
    input EQ1, GT1;
    input [1:0] A, B;
    wire [2:0] select;
    wire zero;
    wire one;
    output EQ0, GT0;
    wire eq_from_mux, gt_from_mux;
    wire notB0,notGT1,GTandor;

    assign select[2:1] = A;
    assign select[0] = B[1];
    assign zero = 0;
    assign one = 1;

    not notB0_gate(notB0, B[0]);
    not notGT1_gate(notGT1, GT1);

    mux_8_1 eq_mux(eq_from_mux,select,notB0,zero,B[0],zero,zero,notB0,zero,B[0]);
    mux_8_1 gt_mux(gt_from_mux,select,zero,zero,notB0,zero,one,zero,one,notB0);

    and andeq(EQ0,eq_from_mux,notGT1,EQ1);
    and andgt(GTandor,gt_from_mux,notGT1,EQ1);
    or orgt(GT0,GTandor,GT1);



endmodule