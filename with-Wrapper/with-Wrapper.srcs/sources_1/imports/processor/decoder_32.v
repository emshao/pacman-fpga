module decoder_32(out,select);
    input [4:0] select;
    output [31:0] out;

    wire not0,not1,not2,not3,not4;
    not n0(not0,select[0]);
    not n1(not1,select[1]);
    not n2(not2,select[2]);
    not n3(not3,select[3]);
    not n4(not4,select[4]);

    and a0(out[0],not0,not1,not2,not3,not4);
    and a1(out[1],select[0],not1,not2,not3,not4);
    and a2(out[2],not0,select[1],not2,not3,not4);
    and a3(out[3],select[0],select[1],not2,not3,not4);
    and a4(out[4],not0,not1,select[2],not3,not4);
    and a5(out[5],select[0],not1,select[2],not3,not4);
    and a6(out[6],not0,select[1],select[2],not3,not4);
    and a7(out[7],select[0],select[1],select[2],not3,not4);
    and a8(out[8],not0,not1,not2,select[3],not4);
    and a9(out[9],select[0],not1,not2,select[3],not4);
    and a10(out[10],not0,select[1],not2,select[3],not4);
    and a11(out[11],select[0],select[1],not2,select[3],not4);
    and a12(out[12],not0,not1,select[2],select[3],not4);
    and a13(out[13],select[0],not1,select[2],select[3],not4);
    and a14(out[14],not0,select[1],select[2],select[3],not4);
    and a15(out[15],select[0],select[1],select[2],select[3],not4);
    and a16(out[16],not0,not1,not2,not3,select[4]);
    and a17(out[17],select[0],not1,not2,not3,select[4]);
    and a18(out[18],not0,select[1],not2,not3,select[4]);
    and a19(out[19],select[0],select[1],not2,not3,select[4]);
    and a20(out[20],not0,not1,select[2],not3,select[4]);
    and a21(out[21],select[0],not1,select[2],not3,select[4]);
    and a22(out[22],not0,select[1],select[2],not3,select[4]);
    and a23(out[23],select[0],select[1],select[2],not3,select[4]);
    and a24(out[24],not0,not1,not2,select[3],select[4]);
    and a25(out[25],select[0],not1,not2,select[3],select[4]);
    and a26(out[26],not0,select[1],not2,select[3],select[4]);
    and a27(out[27],select[0],select[1],not2,select[3],select[4]);
    and a28(out[28],not0,not1,select[2],select[3],select[4]);
    and a29(out[29],select[0],not1,select[2],select[3],select[4]);
    and a30(out[30],not0,select[1],select[2],select[3],select[4]);
    and a31(out[31],select[0],select[1],select[2],select[3],select[4]);


endmodule