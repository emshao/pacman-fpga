`timescale 1 ns / 100 ps
module cla_8_tb;
    wire [7:0] ex,wy,s,pee,gee;
    wire c0,P,G;

    integer i;
    assign {ex,wy} = i[15:0];

    cla_8 testcla(.ex(ex), .wy(wy), .c0(c0), .s(s), .pee(pee),.gee(gee), .P(P), .G(G));

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