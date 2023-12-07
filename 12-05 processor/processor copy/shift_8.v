module shift_8(shiftIn,right,shiftOut);
    input [31:0] shiftIn;
    input right;
    output [31:0] shiftOut;
    wire [31:0] shiftLeft,shiftRight;

    assign shiftLeft[31:8] = shiftIn[23:0];
    assign shiftLeft[7:0] = 8'b00000000;
    assign shiftRight[23:0] = shiftIn[31:8];
    assign shiftRight[31] = shiftIn[31];
    assign shiftRight[30] = shiftIn[31];
    assign shiftRight[29] = shiftIn[31];
    assign shiftRight[28] = shiftIn[31];
    assign shiftRight[27] = shiftIn[31];
    assign shiftRight[26] = shiftIn[31];
    assign shiftRight[25] = shiftIn[31];
    assign shiftRight[24] = shiftIn[31];

    mux_2_32 sLorR(shiftOut,right,shiftLeft,shiftRight);
endmodule
