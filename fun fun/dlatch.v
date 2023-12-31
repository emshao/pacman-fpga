module dlatch(d,clock,q,notq);
    input [31:0] d;
    input clock;
    output [31:0] q,notq;

    wire [31:0] aNA1,aNA2;

    nand n1_0(aNA1[0],d[0],clock);
    nand n1_1(aNA1[1],d[1],clock);
    nand n1_2(aNA1[2],d[2],clock);
    nand n1_3(aNA1[3],d[3],clock);
    nand n1_4(aNA1[4],d[4],clock);
    nand n1_5(aNA1[5],d[5],clock);
    nand n1_6(aNA1[6],d[6],clock);
    nand n1_7(aNA1[7],d[7],clock);
    nand n1_8(aNA1[8],d[8],clock);
    nand n1_9(aNA1[9],d[9],clock);
    nand n1_10(aNA1[10],d[10],clock);
    nand n1_11(aNA1[11],d[11],clock);
    nand n1_12(aNA1[12],d[12],clock);
    nand n1_13(aNA1[13],d[13],clock);
    nand n1_14(aNA1[14],d[14],clock);
    nand n1_15(aNA1[15],d[15],clock);
    nand n1_16(aNA1[16],d[16],clock);
    nand n1_17(aNA1[17],d[17],clock);
    nand n1_18(aNA1[18],d[18],clock);
    nand n1_19(aNA1[19],d[19],clock);
    nand n1_20(aNA1[20],d[20],clock);
    nand n1_21(aNA1[21],d[21],clock);
    nand n1_22(aNA1[22],d[22],clock);
    nand n1_23(aNA1[23],d[23],clock);
    nand n1_24(aNA1[24],d[24],clock);
    nand n1_25(aNA1[25],d[25],clock);
    nand n1_26(aNA1[26],d[26],clock);
    nand n1_27(aNA1[27],d[27],clock);
    nand n1_28(aNA1[28],d[28],clock);
    nand n1_29(aNA1[29],d[29],clock);
    nand n1_30(aNA1[30],d[30],clock);
    nand n1_31(aNA1[31],d[31],clock);

    nand n2_0(aNA2[0],~d[0],clock);
    nand n2_1(aNA2[1],~d[1],clock);
    nand n2_2(aNA2[2],~d[2],clock);
    nand n2_3(aNA2[3],~d[3],clock);
    nand n2_4(aNA2[4],~d[4],clock);
    nand n2_5(aNA2[5],~d[5],clock);
    nand n2_6(aNA2[6],~d[6],clock);
    nand n2_7(aNA2[7],~d[7],clock);
    nand n2_8(aNA2[8],~d[8],clock);
    nand n2_9(aNA2[9],~d[9],clock);
    nand n2_10(aNA2[10],~d[10],clock);
    nand n2_11(aNA2[11],~d[11],clock);
    nand n2_12(aNA2[12],~d[12],clock);
    nand n2_13(aNA2[13],~d[13],clock);
    nand n2_14(aNA2[14],~d[14],clock);
    nand n2_15(aNA2[15],~d[15],clock);
    nand n2_16(aNA2[16],~d[16],clock);
    nand n2_17(aNA2[17],~d[17],clock);
    nand n2_18(aNA2[18],~d[18],clock);
    nand n2_19(aNA2[19],~d[19],clock);
    nand n2_20(aNA2[20],~d[20],clock);
    nand n2_21(aNA2[21],~d[21],clock);
    nand n2_22(aNA2[22],~d[22],clock);
    nand n2_23(aNA2[23],~d[23],clock);
    nand n2_24(aNA2[24],~d[24],clock);
    nand n2_25(aNA2[25],~d[25],clock);
    nand n2_26(aNA2[26],~d[26],clock);
    nand n2_27(aNA2[27],~d[27],clock);
    nand n2_28(aNA2[28],~d[28],clock);
    nand n2_29(aNA2[29],~d[29],clock);
    nand n2_30(aNA2[30],~d[30],clock);
    nand n2_31(aNA2[31],~d[31],clock);

    wire [31:0] aNA3,aNA4;

    nand n3_0(aNA3[0],aNA1[0],aNA4[0]);
    nand n3_1(aNA3[1],aNA1[1],aNA4[1]);
    nand n3_2(aNA3[2],aNA1[2],aNA4[2]);
    nand n3_3(aNA3[3],aNA1[3],aNA4[3]);
    nand n3_4(aNA3[4],aNA1[4],aNA4[4]);
    nand n3_5(aNA3[5],aNA1[5],aNA4[5]);
    nand n3_6(aNA3[6],aNA1[6],aNA4[6]);
    nand n3_7(aNA3[7],aNA1[7],aNA4[7]);
    nand n3_8(aNA3[8],aNA1[8],aNA4[8]);
    nand n3_9(aNA3[9],aNA1[9],aNA4[9]);
    nand n3_10(aNA3[10],aNA1[10],aNA4[10]);
    nand n3_11(aNA3[11],aNA1[11],aNA4[11]);
    nand n3_12(aNA3[12],aNA1[12],aNA4[12]);
    nand n3_13(aNA3[13],aNA1[13],aNA4[13]);
    nand n3_14(aNA3[14],aNA1[14],aNA4[14]);
    nand n3_15(aNA3[15],aNA1[15],aNA4[15]);
    nand n3_16(aNA3[16],aNA1[16],aNA4[16]);
    nand n3_17(aNA3[17],aNA1[17],aNA4[17]);
    nand n3_18(aNA3[18],aNA1[18],aNA4[18]);
    nand n3_19(aNA3[19],aNA1[19],aNA4[19]);
    nand n3_20(aNA3[20],aNA1[20],aNA4[20]);
    nand n3_21(aNA3[21],aNA1[21],aNA4[21]);
    nand n3_22(aNA3[22],aNA1[22],aNA4[22]);
    nand n3_23(aNA3[23],aNA1[23],aNA4[23]);
    nand n3_24(aNA3[24],aNA1[24],aNA4[24]);
    nand n3_25(aNA3[25],aNA1[25],aNA4[25]);
    nand n3_26(aNA3[26],aNA1[26],aNA4[26]);
    nand n3_27(aNA3[27],aNA1[27],aNA4[27]);
    nand n3_28(aNA3[28],aNA1[28],aNA4[28]);
    nand n3_29(aNA3[29],aNA1[29],aNA4[29]);
    nand n3_30(aNA3[30],aNA1[30],aNA4[30]);
    nand n3_31(aNA3[31],aNA1[31],aNA4[31]);

    nand n4_0(aNA4[0],aNA2[0],aNA3[0]);
    nand n4_1(aNA4[1],aNA2[1],aNA3[1]);
    nand n4_2(aNA4[2],aNA2[2],aNA3[2]);
    nand n4_3(aNA4[3],aNA2[3],aNA3[3]);
    nand n4_4(aNA4[4],aNA2[4],aNA3[4]);
    nand n4_5(aNA4[5],aNA2[5],aNA3[5]);
    nand n4_6(aNA4[6],aNA2[6],aNA3[6]);
    nand n4_7(aNA4[7],aNA2[7],aNA3[7]);
    nand n4_8(aNA4[8],aNA2[8],aNA3[8]);
    nand n4_9(aNA4[9],aNA2[9],aNA3[9]);
    nand n4_10(aNA4[10],aNA2[10],aNA3[10]);
    nand n4_11(aNA4[11],aNA2[11],aNA3[11]);
    nand n4_12(aNA4[12],aNA2[12],aNA3[12]);
    nand n4_13(aNA4[13],aNA2[13],aNA3[13]);
    nand n4_14(aNA4[14],aNA2[14],aNA3[14]);
    nand n4_15(aNA4[15],aNA2[15],aNA3[15]);
    nand n4_16(aNA4[16],aNA2[16],aNA3[16]);
    nand n4_17(aNA4[17],aNA2[17],aNA3[17]);
    nand n4_18(aNA4[18],aNA2[18],aNA3[18]);
    nand n4_19(aNA4[19],aNA2[19],aNA3[19]);
    nand n4_20(aNA4[20],aNA2[20],aNA3[20]);
    nand n4_21(aNA4[21],aNA2[21],aNA3[21]);
    nand n4_22(aNA4[22],aNA2[22],aNA3[22]);
    nand n4_23(aNA4[23],aNA2[23],aNA3[23]);
    nand n4_24(aNA4[24],aNA2[24],aNA3[24]);
    nand n4_25(aNA4[25],aNA2[25],aNA3[25]);
    nand n4_26(aNA4[26],aNA2[26],aNA3[26]);
    nand n4_27(aNA4[27],aNA2[27],aNA3[27]);
    nand n4_28(aNA4[28],aNA2[28],aNA3[28]);
    nand n4_29(aNA4[29],aNA2[29],aNA3[29]);
    nand n4_30(aNA4[30],aNA2[30],aNA3[30]);
    nand n4_31(aNA4[31],aNA2[31],aNA3[31]);

    assign q = aNA3;
    assign notq = aNA4;






endmodule