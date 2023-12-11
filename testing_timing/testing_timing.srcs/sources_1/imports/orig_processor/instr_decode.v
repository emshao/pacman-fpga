module instr_decode(instruction,opcode,rD,rs,rt,shamt,ALUop,zeroesShort,imm,targ,zeroesLong);
    input [31:0] instruction;
    output [4:0] opcode,rD,rs,rt,shamt,ALUop;
    output [1:0] zeroesShort;
    output [16:0] imm;
    output [26:0] targ;
    output [21:0] zeroesLong;

    assign opcode = instruction[31:27];
    assign rD = instruction[26:22];
    assign rs = instruction[21:17];
    assign rt = instruction[16:12];
    assign shamt = instruction[11:7];
    assign ALUop = instruction[6:2];
    assign zeroesShort = instruction[1:0];
    assign imm = instruction[16:0];
    assign targ = instruction[26:0];
    assign zeroesLong = instruction[21:0];


endmodule