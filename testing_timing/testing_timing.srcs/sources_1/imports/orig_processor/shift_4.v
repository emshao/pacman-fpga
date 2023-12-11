module shift_4(shiftIn,right,shiftOut);
    input [31:0] shiftIn;
    input right;
    output [31:0] shiftOut;
    wire [31:0] shiftLeft,shiftRight;

    assign shiftLeft[31:4] = shiftIn[27:0];
    assign shiftLeft[3:0] = 4'b0000;
    assign shiftRight[27:0] = shiftIn[31:4];

    assign shiftRight[31] = shiftIn[31];
    assign shiftRight[30] = shiftIn[31];
    assign shiftRight[29] = shiftIn[31];
    assign shiftRight[28] = shiftIn[31];

    mux_2_32 sLorR(shiftOut,right,shiftLeft,shiftRight);
endmodule
