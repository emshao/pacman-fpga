module mux_2_2(out,select,in0,in1);
    input select;
    input [1:0] in0, in1;
    output [1:0] out;
    assign out = select ? in1 : in0;
endmodule