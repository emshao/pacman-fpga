module tff(t,clk,en,reset,q);
    input t,en,reset;
    input clk;
    output q;

    wire tbar,a1,a2,orr,qbar;
    not notT(tbar,t);

    dffe_ref defef(q,orr,clk,en,reset);
    not notQ(qbar,q);

    and and1(a1,tbar,q);
    and and2(a2,t,qbar);
    or orr1(orr,a1,a2);

endmodule