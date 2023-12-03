module shift_2(shiftIn,right,shiftOut);
    input [31:0] shiftIn;
    input right;
    output [31:0] shiftOut;
    wire [31:0] shiftLeft,shiftRight;

    assign shiftLeft[31:2] = shiftIn[29:0];
    assign shiftLeft[1:0] = 2'b00;
    assign shiftRight[29:0] = shiftIn[31:2];
    assign shiftRight[31] = shiftIn[31];
    assign shiftRight[30] = shiftIn[31];

    mux_2_32 sLorR(shiftOut,right,shiftLeft,shiftRight);
endmodule
