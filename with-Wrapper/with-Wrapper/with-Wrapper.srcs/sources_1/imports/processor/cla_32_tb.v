`timescale 1 ns / 100 ps
//NOTE: NOT FINISHED (LOWKEY DONT WANT TO)
module cla_32_tb();
    wire [31:0] ex,wyy,s;
    wire sub;
    reg [31:0] orr, andd;

    integer i;
    integer j;
    assign ex = i[31:0];
    assign y = j[31:0];

    cla_32 testcla(.sub(sub), .ex(ex), .wyy(wyy), .S(s), .c32(c32), .orr(orr), .andd(andd));

    initial begin;
        for(i=1; i < 131072; i = i+1) begin
            #20;
            if(ex + wy != s) begin
                $display("ERROR: x:%b, y:%b, s:%b",ex,wy,s);
            end
            
            // else 
            //     $display("PASSED: EQ1:%b,GT1:%b,A:%b, B:%b, EQ0:%b, GT0:%b",EQ1,GT1,A,B,EQ0,GT0);
            
        end

        $finish;

    end


endmodule