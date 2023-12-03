module cla_32(sub,ex,wyy,S,ovf,orr,andd);
    input sub;
    input [31:0] ex,wyy;
    wire [31:0] wy;
    output [31:0] S;
    output ovf;
    output [31:0] orr,andd;
    wire P0,G0,P1,G1,P2,G2,P3,G3;

    //modifying y based on sub bit
    sub_conv subtract_y(.sub(sub), .yin(wyy), .yout(wy));

    wire fakec311,fakec312,fakec313,realc31;
    //first 8 bits
    cla_8 add07(.ex(ex[7:0]), .wy(wy[7:0]), .c0(sub), .s(S[7:0]), .pee(orr[7:0]),.gee(andd[7:0]),.P(P0), .G(G0),.cee7(fakec311));
    wire toc8,c8;
    and c8and(toc8,P0,sub);
    or c8or(c8,G0,toc8);

    //second 8 bits
    cla_8 add815(.ex(ex[15:8]), .wy(wy[15:8]), .c0(c8), .s(S[15:8]), .pee(orr[15:8]),.gee(andd[15:8]), .P(P1), .G(G1),.cee7(fakec312));
    wire toc161,toc162,c16;
    and c16and1(toc161,P1,G0);
    and c16and2(toc162,P0,P1,sub);
    or c16or(c16,G1,toc161,toc162);

    //third 8 bits
    cla_8 add1623(.ex(ex[23:16]), .wy(wy[23:16]), .c0(c16), .s(S[23:16]), .pee(orr[23:16]),.gee(andd[23:16]), .P(P2), .G(G2),.cee7(fakec313));
    wire toc241,toc242,toc243,c24;
    and c24and1(toc241,P2,G1);
    and c24and2(toc242,P1,P2,G0);
    and c24and3(toc243,P0,P1,P2,sub);
    or c24or(c24,G2,toc241,toc242,toc243);

    //fourth 8 bits!
    cla_8 add2431(.ex(ex[31:24]), .wy(wy[31:24]), .c0(c24), .s(S[31:24]), .pee(orr[31:24]),.gee(andd[31:24]), .P(P3), .G(G3),.cee7(realc31));
    wire toc321,toc322,toc323,toc324,c32;
    and c32and1(toc321,P3,G2);
    and c32and2(toc322,P2,P3,G1);
    and c32and3(toc323,P1,P2,P3,G0);
    and c32and4(toc324,P0,P1,P2,P3,sub);
    or c32or(c32,G3,toc321,toc322,toc323,toc324);

    xor ovfxor(ovf,c32,realc31);

endmodule