module shift_16(shiftIn,right,shiftOut);
    input [31:0] shiftIn;
    input right;
    output [31:0] shiftOut;
    wire [31:0] shiftLeft,shiftRight;

    assign shiftLeft[31:16] = shiftIn[15:0];
    assign shiftLeft[15:0] = 16'b0000000000000000;
    assign shiftRight[15:0] = shiftIn[31:16];
    assign shiftRight[31] = shiftIn[31];
    assign shiftRight[30] = shiftIn[31];
    assign shiftRight[29] = shiftIn[31];
    assign shiftRight[28] = shiftIn[31];
    assign shiftRight[27] = shiftIn[31];
    assign shiftRight[26] = shiftIn[31];
    assign shiftRight[25] = shiftIn[31];
    assign shiftRight[24] = shiftIn[31];
    assign shiftRight[23] = shiftIn[31];
    assign shiftRight[22] = shiftIn[31];
    assign shiftRight[21] = shiftIn[31];
    assign shiftRight[20] = shiftIn[31];
    assign shiftRight[19] = shiftIn[31];
    assign shiftRight[18] = shiftIn[31];
    assign shiftRight[17] = shiftIn[31];
    assign shiftRight[16] = shiftIn[31];

    mux_2_32 sLorR(shiftOut,right,shiftLeft,shiftRight);
endmodule