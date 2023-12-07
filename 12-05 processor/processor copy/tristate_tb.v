`timescale 1 ns / 100 ps
module tristate_tb;

    
    
    reg [31:0] in;
    reg oe;
    wire [31:0] out;
    tristate testT(in,oe,out);



    initial begin
        in = 0;
        oe = 0;
        #40;
        // for(i=0; i < 8; i = i+1) begin
        //     #20;
        //     $display("in0:%b,in1:%b,in2:%b,in3:%b,in4:%b,in5:%b,in6:%b,in7:%b,select:%b => out:%b",in0,in1,in2,in3,in4,in5,in6,in7,select,out);
        // end

        $finish;
    end

    always
        #10 oe = ~oe;
    always
        #20 in = ~in;

    always @(oe,in) begin
        #1;
        $display("in:%b, oe:%b => out:%b",in,oe,out);
        
    end

    // initial begin
    //     $dumpfile("full_adder_waveform.vcd");
    //     $dumpvars(0,full_adder_tb);
    // end

endmodule