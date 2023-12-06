`timescale 1 ns / 100 ps
module comp_2_tb;
    reg EQ1, GT1;
    reg [1:0] A, B;
    wire EQ0, GT0;

    comp_2 test_comp_2(.EQ1(EQ1), .GT1(GT1), .A(A), .B(B), .EQ0(EQ0), .GT0(GT0));

    initial begin
        A=0;
        B=0;
        EQ1=0;
        GT1=0;

        #640;
        $finish;
    end

    always
        #10 B[0] = ~B[0];
    always
        #20 B[1] = ~B[1];
    always 
        #40 A[0] = ~A[0];
    always
        #80 A[1] = ~A[1];
    always
        #160 GT1 = ~GT1;
    always
        #320 EQ1 = ~EQ1;
    
    always @(A,B,GT1,EQ1) begin
        #1;
        $display("EQ1:%b, GT1:%b A:%b, B:%b => EQ0:%b, GT0:%b",EQ1,GT1,A,B,EQ0,GT0);
    end



endmodule