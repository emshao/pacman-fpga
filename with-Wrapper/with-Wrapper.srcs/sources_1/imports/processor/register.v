module register(clk,reset,writeEnable,valIn,valOut);
    input clk,reset,writeEnable;
    input [31:0] valIn;
    output [31:0] valOut;

    wire cEn;
    and cEnAnd(cEn,writeEnable,clk);

    dffe_ref d0(valOut[0], valIn[0], clk, cEn, reset);
    dffe_ref d1(valOut[1], valIn[1], clk, cEn, reset);
    dffe_ref d2(valOut[2], valIn[2], clk, cEn, reset);
    dffe_ref d3(valOut[3], valIn[3], clk, cEn, reset);
    dffe_ref d4(valOut[4], valIn[4], clk, cEn, reset);
    dffe_ref d5(valOut[5], valIn[5], clk, cEn, reset);
    dffe_ref d6(valOut[6], valIn[6], clk, cEn, reset);
    dffe_ref d7(valOut[7], valIn[7], clk, cEn, reset);
    dffe_ref d8(valOut[8], valIn[8], clk, cEn, reset);
    dffe_ref d9(valOut[9], valIn[9], clk, cEn, reset);
    dffe_ref d10(valOut[10], valIn[10], clk, cEn, reset);
    dffe_ref d11(valOut[11], valIn[11], clk, cEn, reset);
    dffe_ref d12(valOut[12], valIn[12], clk, cEn, reset);
    dffe_ref d13(valOut[13], valIn[13], clk, cEn, reset);
    dffe_ref d14(valOut[14], valIn[14], clk, cEn, reset);
    dffe_ref d15(valOut[15], valIn[15], clk, cEn, reset);
    dffe_ref d16(valOut[16], valIn[16], clk, cEn, reset);
    dffe_ref d17(valOut[17], valIn[17], clk, cEn, reset);
    dffe_ref d18(valOut[18], valIn[18], clk, cEn, reset);
    dffe_ref d19(valOut[19], valIn[19], clk, cEn, reset);
    dffe_ref d20(valOut[20], valIn[20], clk, cEn, reset);
    dffe_ref d21(valOut[21], valIn[21], clk, cEn, reset);
    dffe_ref d22(valOut[22], valIn[22], clk, cEn, reset);
    dffe_ref d23(valOut[23], valIn[23], clk, cEn, reset);
    dffe_ref d24(valOut[24], valIn[24], clk, cEn, reset);
    dffe_ref d25(valOut[25], valIn[25], clk, cEn, reset);
    dffe_ref d26(valOut[26], valIn[26], clk, cEn, reset);
    dffe_ref d27(valOut[27], valIn[27], clk, cEn, reset);
    dffe_ref d28(valOut[28], valIn[28], clk, cEn, reset);
    dffe_ref d29(valOut[29], valIn[29], clk, cEn, reset);
    dffe_ref d30(valOut[30], valIn[30], clk, cEn, reset);
    dffe_ref d31(valOut[31], valIn[31], clk, cEn, reset);

endmodule