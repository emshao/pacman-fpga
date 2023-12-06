`timescale 1 ns / 100 ps
//NOTE: NOT FINISHED (LOWKEY DONT WANT TO)
module instr_decode_tb();
    wire [31:0] instruction;
    wire [4:0] opcode,rD,rs,rt,shamt,ALUop;
    wire [1:0] zeroesShort;
    wire [16:0] imm;
    wire [26:0] targ;
    wire [21:0] zeroesLong;

    instr_decode decodeee(.instruction(instruction),.opcode(opcode),.rD(rD),.rs(rs),.rt(rt),.shamt(shamt),.ALUop(ALUop),.zeroesShort(zeroesShort),.imm(imm),.targ(targ),.zeroesLong(zeroesLong));

    integer i;
    integer j;
    assign instruction = i[31:0];

    initial begin;
        for(i=1; i < 131072000; i = i+248000) begin
            #20;
            $display("i:%b,opcode:%b,rd:%b,rs:%b,rt:%b",instruction,opcode,rD,rs,rt);
            
            // else 
            //     $display("PASSED: EQ1:%b,GT1:%b,A:%b, B:%b, EQ0:%b, GT0:%b",EQ1,GT1,A,B,EQ0,GT0);
            
        end

        $finish;

    end


endmodule