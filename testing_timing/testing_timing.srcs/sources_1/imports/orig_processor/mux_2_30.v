module mux_2_30(out,select,in0,in1);
    input select;
    input [29:0] in0, in1;
    output [29:0] out;
    assign out = select ? in1 : in0;
endmodule