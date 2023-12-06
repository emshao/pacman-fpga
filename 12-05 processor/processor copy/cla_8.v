module cla_8(ex,wy,c0,s,pee,gee,P,G,cee7);
    input [7:0] ex,wy;
    input c0;

    output [7:0] s;
    output [7:0] pee,gee;
    output P,G;
    output cee7;
    wire G01,G02,G03,G04,G05,G06,G07;

    wire c1,c2,c3,c4,c5,c6,c7;

    assign cee7 = c7;


    //defining p07, g07 (or 815, etc.)
    or p0gate(pee[0],ex[0],wy[0]);
    or p1gate(pee[1],ex[1],wy[1]);
    or p2gate(pee[2],ex[2],wy[2]);
    or p3gate(pee[3],ex[3],wy[3]);
    or p4gate(pee[4],ex[4],wy[4]);
    or p5gate(pee[5],ex[5],wy[5]);
    or p6gate(pee[6],ex[6],wy[6]);
    or p7gate(pee[7],ex[7],wy[7]);

    and g0gate(gee[0],ex[0],wy[0]);
    and g1gate(gee[1],ex[1],wy[1]);
    and g2gate(gee[2],ex[2],wy[2]);
    and g3gate(gee[3],ex[3],wy[3]);
    and g4gate(gee[4],ex[4],wy[4]);
    and g5gate(gee[5],ex[5],wy[5]);
    and g6gate(gee[6],ex[6],wy[6]);
    and g7gate(gee[7],ex[7],wy[7]);

    //big P
    and P0(P,pee[0],pee[1],pee[2],pee[3],pee[4],pee[5],pee[6],pee[7]);
    //big G
    and G01and(G01,gee[0],pee[1],pee[2],pee[3],pee[4],pee[5],pee[6],pee[7]);
    and G02and(G02,gee[1],pee[2],pee[3],pee[4],pee[5],pee[6],pee[7]);
    and G03and(G03,gee[2],pee[3],pee[4],pee[5],pee[6],pee[7]);
    and G04and(G04,gee[3],pee[4],pee[5],pee[6],pee[7]);
    and G05and(G05,gee[4],pee[5],pee[6],pee[7]);
    and G06and(G06,gee[5],pee[6],pee[7]);
    and G07and(G07,gee[6],pee[7]);
    or G0(G,G01,G02,G03,G04,G05,G06,G07,gee[7]);

    //getting the carry bits
    wire toc1;
    and c1and(toc1,pee[0],c0);
    or c1or(c1,gee[0],toc1);

    wire toc21,toc22;
    and c2and1(toc21,c0,pee[0],pee[1]);
    and c2and2(toc22,gee[0],pee[1]);
    or c2or(c2,toc21,toc22,gee[1]);

    wire toc31,toc32,toc33;
    and c3and1(toc31,c0,pee[0],pee[1],pee[2]);
    and c3and2(toc32,gee[0],pee[1],pee[2]);
    and c3and3(toc33,gee[1],pee[2]);
    or c3or(c3,toc31,toc32,toc33,gee[2]);

    wire toc41,toc42,toc43,toc44;
    and c4and1(toc41,c0,pee[0],pee[1],pee[2],pee[3]);
    and c4and2(toc42,gee[0],pee[1],pee[2],pee[3]);
    and c4and3(toc43,gee[1],pee[2],pee[3]);
    and c4and4(toc44,gee[2],pee[3]);
    or c4or(c4,toc41,toc42,toc43,toc44,gee[3]);

    wire toc51,toc52,toc53,toc54,toc55;
    and c5and1(toc51,c0,pee[0],pee[1],pee[2],pee[3],pee[4]);
    and c5and2(toc52,gee[0],pee[1],pee[2],pee[3],pee[4]);
    and c5and3(toc53,gee[1],pee[2],pee[3],pee[4]);
    and c5and4(toc54,gee[2],pee[3],pee[4]);
    and c5and5(toc55,gee[3],pee[4]);
    or c5or(c5,toc51,toc52,toc53,toc54,toc55,gee[4]);

    wire toc61,toc62,toc63,toc64,toc65,toc66;
    and c6and1(toc61,c0,pee[0],pee[1],pee[2],pee[3],pee[4],pee[5]);
    and c6and2(toc62,gee[0],pee[1],pee[2],pee[3],pee[4],pee[5]);
    and c6and3(toc63,gee[1],pee[2],pee[3],pee[4],pee[5]);
    and c6and4(toc64,gee[2],pee[3],pee[4],pee[5]);
    and c6and5(toc65,gee[3],pee[4],pee[5]);
    and c6and6(toc66,gee[4],pee[5]);
    or c6or(c6,toc61,toc62,toc63,toc64,toc65,toc66,gee[5]);

    wire toc71,toc72,toc73,toc74,toc75,toc76,toc77;
    and c7and1(toc71,c0,pee[0],pee[1],pee[2],pee[3],pee[4],pee[5],pee[6]);
    and c7and2(toc72,gee[0],pee[1],pee[2],pee[3],pee[4],pee[5],pee[6]);
    and c7and3(toc73,gee[1],pee[2],pee[3],pee[4],pee[5],pee[6]);
    and c7and4(toc74,gee[2],pee[3],pee[4],pee[5],pee[6]);
    and c7and5(toc75,gee[3],pee[4],pee[5],pee[6]);
    and c7and6(toc76,gee[4],pee[5],pee[6]);
    and c7and7(toc77,gee[5],pee[6]);
    or c7or(c7,toc71,toc72,toc73,toc74,toc75,toc76,toc77,gee[6]);

    //getting the sum!
    wire tos0,tos1,tos2,tos3,tos4,tos5,tos6,tos7;

    xor s0xor1(tos0,ex[0],wy[0]);
    xor s0xor2(s[0],tos0,c0);

    xor s1xor1(tos1,ex[1],wy[1]);
    xor s1xor2(s[1],tos1,c1);

    xor s2xor1(tos2,ex[2],wy[2]);
    xor s2xor2(s[2],tos2,c2);

    xor s3xor1(tos3,ex[3],wy[3]);
    xor s3xor2(s[3],tos3,c3);

    xor s4xor1(tos4,ex[4],wy[4]);
    xor s4xor2(s[4],tos4,c4);

    xor s5xor1(tos5,ex[5],wy[5]);
    xor s5xor2(s[5],tos5,c5);

    xor s6xor1(tos6,ex[6],wy[6]);
    xor s6xor2(s[6],tos6,c6);

    xor s7xor1(tos7,ex[7],wy[7]);
    xor s7xor2(s[7],tos7,c7);

endmodule