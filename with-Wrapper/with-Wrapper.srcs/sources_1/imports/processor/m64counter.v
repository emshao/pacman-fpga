module m64counter(en,clk,reset,count);
    input en,clk,reset;
    output [5:0] count;

    wire q0,q1,q2,q3,q4,q5,clken;
    and cen(clken,clk,en);

    wire toq1,toq2,toq3,toq4,toq5;
    wire toc0,toc1,toc2,toc3,toc5;
    tff tff0(en,clk,en,reset,count[0]);
    and atoq1(toq1,count[0],en);
    tff tff1(toq1,clk,en,reset,count[1]);
    and atoq2(toq2,count[1],toq1);
    tff tff2(toq2,clk,en,reset,count[2]);
    and atoq3(toq3,count[2],toq2);
    tff tff3(toq3,clk,en,reset,count[3]);
    and atoq4(toq4,count[3],toq3);
    tff tff4(toq4,clk,en,reset,count[4]);
    and atoq5(toq5,count[4],toq4);
    tff tff5(toq5,clk,en,reset,count[5]);


endmodule