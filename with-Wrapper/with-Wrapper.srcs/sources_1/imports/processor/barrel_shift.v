module barrel_shift(shiftIn,shAmt,right,shiftOut);
    input [31:0] shiftIn;
    input [4:0] shAmt;
    input right;
    output [31:0] shiftOut;
    wire [31:0] shift16,shift8,shift4,shift2,shift1;
    wire [31:0] s16muX,s8muX,s4muX,s2muX;

    shift_16 s16(shiftIn,right,shift16);
    mux_2_32 s16mux(s16muX,shAmt[4],shiftIn,shift16);

    shift_8 s8(s16muX,right,shift8);
    mux_2_32 s8mux(s8muX,shAmt[3],s16muX,shift8);

    shift_4 s4(s8muX,right,shift4);
    mux_2_32 s4mux(s4muX,shAmt[2],s8muX,shift4);

    shift_2 s2(s4muX,right,shift2);
    mux_2_32 s2mux(s2muX,shAmt[1],s4muX,shift2);

    shift_1 s1(s2muX,right,shift1);
    mux_2_32 s1mux(shiftOut,shAmt[0],s2muX,shift1);


endmodule