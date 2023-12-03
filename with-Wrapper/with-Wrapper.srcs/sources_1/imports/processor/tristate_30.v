module tristate_30(in,oe,out);
    input [29:0] in;
    input oe;
    output [29:0] out;
    assign out = oe ? in : 30'bz;

endmodule