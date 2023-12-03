module dlatch_1(d,clock,q,notq);
    input d;
    input clock;
    output q,notq;

    wire aNA1,aNA2,notd;
    not notD(notd,d);

    nand n1(aNA1,d,clock);
    nand n2(aNA2,notd,clock);
    

    wire aNA3,aNA4;

    nand n3(aNA3,aNA1,aNA4);
    nand n4(aNA4,aNA2,aNA3);
    
    assign q = aNA3;
    assign notq = aNA4;

endmodule