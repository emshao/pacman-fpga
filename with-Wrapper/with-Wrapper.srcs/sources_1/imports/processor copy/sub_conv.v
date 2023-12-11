module sub_conv(sub,yin,yout);
    input sub;
    input [31:0] yin;
    output [31:0] yout;

    xor sub0(yout[0],sub,yin[0]);
    xor sub1(yout[1],sub,yin[1]);
    xor sub2(yout[2],sub,yin[2]);
    xor sub3(yout[3],sub,yin[3]);
    xor sub4(yout[4],sub,yin[4]);
    xor sub5(yout[5],sub,yin[5]);
    xor sub6(yout[6],sub,yin[6]);
    xor sub7(yout[7],sub,yin[7]);
    xor sub8(yout[8],sub,yin[8]);
    xor sub9(yout[9],sub,yin[9]);
    xor sub10(yout[10],sub,yin[10]);
    xor sub11(yout[11],sub,yin[11]);
    xor sub12(yout[12],sub,yin[12]);
    xor sub13(yout[13],sub,yin[13]);
    xor sub14(yout[14],sub,yin[14]);
    xor sub15(yout[15],sub,yin[15]);
    xor sub16(yout[16],sub,yin[16]);
    xor sub17(yout[17],sub,yin[17]);
    xor sub18(yout[18],sub,yin[18]);
    xor sub19(yout[19],sub,yin[19]);
    xor sub20(yout[20],sub,yin[20]);
    xor sub21(yout[21],sub,yin[21]);
    xor sub22(yout[22],sub,yin[22]);
    xor sub23(yout[23],sub,yin[23]);
    xor sub24(yout[24],sub,yin[24]);
    xor sub25(yout[25],sub,yin[25]);
    xor sub26(yout[26],sub,yin[26]);
    xor sub27(yout[27],sub,yin[27]);
    xor sub28(yout[28],sub,yin[28]);
    xor sub29(yout[29],sub,yin[29]);
    xor sub30(yout[30],sub,yin[30]);
    xor sub31(yout[31],sub,yin[31]);

endmodule