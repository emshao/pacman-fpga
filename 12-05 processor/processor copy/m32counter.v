module m32counter(en,clk,reset,count);
    input en,clk,reset;
    output [4:0] count;

    wire q0,q1,q2,q3,q4,clken;
    and cen(clken,clk,en);

    wire toq1,toq2,toq3,toq4;
    wire toc0,toc1,toc2,toc3;
    tff tff0(en,clk,en,reset,count[0]);
    and atoq1(toq1,count[0],en);
    tff tff1(toq1,clk,en,reset,count[1]);
    and atoq2(toq2,count[1],toq1);
    tff tff2(toq2,clk,en,reset,count[2]);
    and atoq3(toq3,count[2],toq2);
    tff tff3(toq3,clk,en,reset,count[3]);
    and atoq4(toq4,count[3],toq3);
    tff tff4(toq4,clk,en,reset,count[4]);

endmodule