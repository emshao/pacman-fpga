`timescale 1 ns / 100 ps
module comp_8_tb;
    wire EQ1, GT1;
    wire [7:0] A, B;
    wire EQ0, GT0;

    integer i;
    assign {EQ1,GT1,A,B} = i[17:0];

    comp_8 test_comp_8(.EQ1(EQ1), .GT1(GT1), .A(A), .B(B), .EQ0(EQ0), .GT0(GT0));

    initial begin
        for(i=1; i < 524288; i = i+1) begin
            #20;
            if(EQ1 && !GT1 && A > B && (EQ0 || !GT0)) begin
                $display("ERROR: A > B but EQ0:%b, GT0:%b",EQ0,GT0);
            end
            else if(EQ1 && !GT1 && A == B && (GT0 || !EQ0)) begin
                $display("ERROR: A == B but GT0:%b",GT0);
            end
            else if(EQ1 && !GT1 && A < B && (EQ0 || GT0)) begin
                $display("ERROR: A < B but EQ0:%b, GT0:%b",EQ0,GT0);
            end
            else if(!EQ1 && GT1 && (EQ0 || !GT0)) begin
                $display("ERROR: !EQ1 && GT1 but EQ0:%b, GT0:%b",EQ0,GT0);
            end
            else if(!EQ1 && !GT1 && (EQ0 || GT0)) begin
                $display("ERROR: !EQ1 && !GT1 but EQ0:%b, GT0:%b",EQ0,GT0);
            end
            else 
                $display("PASSED: EQ1:%b,GT1:%b,A:%b, B:%b, EQ0:%b, GT0:%b",EQ1,GT1,A,B,EQ0,GT0);
            //$display("PASSED: EQ1:%b,GT1:%b,A:%b, B:%b, EQ0:%b, GT0:%b",EQ1,EQ0,A,B,EQ0,GT0);

        end
        //$display("PASSED: EQ1:%b,GT1:%b,A:%b, B:%b, EQ0:%b, GT0:%b",EQ1,EQ0,A,B,EQ0,GT0);
        $finish;
    end

    // always
    //     #10 B[0] = ~B[0];
    // always
    //     #20 B[1] = ~B[1];
    // always 
    //     #40 A[0] = ~A[0];
    // always
    //     #80 A[1] = ~A[1];
    // always
    //     #160 GT1 = ~GT1;
    // always
    //     #320 EQ1 = ~EQ1;
    
    // always @(A,B,GT1,EQ1) begin
    //     #1;
    //     $display("EQ1:%b, GT1:%b A:%b, B:%b => EQ0:%b, GT0:%b",EQ1,GT1,A,B,EQ0,GT0);
    // end



endmodule