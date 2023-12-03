module shift_1(shiftIn,right,shiftOut);
    input [31:0] shiftIn;
    input right;
    output [31:0] shiftOut;
    wire [31:0] shiftLeft,shiftRight;

    assign shiftLeft[31:1] = shiftIn[30:0];
    assign shiftLeft[0] = 1'b0;
    assign shiftRight[30:0] = shiftIn[31:1];
    assign shiftRight[31] = shiftIn[31];

    mux_2_32 sLorR(shiftOut,right,shiftLeft,shiftRight);
endmodule