/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */

    wire [4:0] rD,almostReadRegA,opcode,shamt,ALUop,readRegBFake;
    wire [1:0] zS;
    wire [16:0] imm;
    wire [26:0] targ;
    wire [21:0] zL;
    instr_decode decodeee(.instruction(fdInstrOut),.opcode(opcode),.rD(rD),.rs(almostReadRegA),.rt(readRegBFake),.shamt(shamt),.ALUop(ALUop),.zeroesShort(zS),.imm(),.targ(targ),.zeroesLong(zL));
	
    //CHANGE THIS WHEN FINISH PIPELINING
    //assign ctrl_writeReg = rD;

    //adjust so it chooses (mux) bw readRegBFake and rD UPDATE: DONE
    //(if R type, then should be readRegBFake, otherwise rD I think)
    //assign ctrl_readRegB = readRegBFake;
    assign ctrl_readRegB = (opcode == 5'b00000) ? readRegBFake : rD;
    assign ctrl_readRegA = (opcode == 5'b10110) ? 5'b11110 : almostReadRegA;
    wire [31:0] data_operandA,data_operandB,data_result1,data_result2;
    wire notEq1,lessThan1,overflow1;
    wire notEq2,lessThan2,overflow2;
    wire [4:0] dxOpcode,dxALUOp,dxShamt,dxRD;
    wire [26:0] dxTarg;

    instr_decode decodeee3(.instruction(dxInstrOut),.opcode(dxOpcode),.rD(dxRD),.rs(temp_ADX),.rt(temp_BDX),.shamt(dxShamt),.ALUop(dxALUOp),.zeroesShort(),.imm(imm),.targ(dxTarg),.zeroesLong());
    wire [31:0] fullDxTarg;
    assign fullDxTarg[31:27] = dxPCOut[31:27];
    assign fullDxTarg[26:0] = dxTarg;

    wire [31:0] full_imm;
    assign full_imm[16:0] = imm;
    assign full_imm[31] = full_imm[16];
    assign full_imm[30] = full_imm[16];
    assign full_imm[29] = full_imm[16];
    assign full_imm[28] = full_imm[16];
    assign full_imm[27] = full_imm[16];
    assign full_imm[26] = full_imm[16];
    assign full_imm[25] = full_imm[16];
    assign full_imm[24] = full_imm[16];
    assign full_imm[23] = full_imm[16];
    assign full_imm[22] = full_imm[16];
    assign full_imm[21] = full_imm[16];
    assign full_imm[20] = full_imm[16];
    assign full_imm[19] = full_imm[16];
    assign full_imm[18] = full_imm[16];
    assign full_imm[17] = full_imm[16];
    wire [4:0] realALUop;

    //THIS WILL CHANGE BUT FOR NOW JUST SETTING TO 1 UPDATE: DONE
    //assign ctrl_writeEnable = 1'b1;
    

    //assign data_operandA = data_readRegA;
    //mux_2_32 muxB(.out(data_operandB),.select(opEq0),.in0(full_imm),.in1(data_readRegB));
    // mux_2_5 muxAlO(.out(realALUop),.select(opEq0),.in0(5'b00000),.in1(ALUop));

    wire [31:0] dxBReal;
    assign dxBReal = bexComm ? 32'b00000000000000000000000000000000 : dxBOut;

    alu aluuu1(.data_operandA(finalA),.data_operandB(finalB),.ctrl_ALUopcode(dxALUOp),.ctrl_shiftamt(dxShamt),.data_result(data_result1),.isNotEqual(notEq1),.isLessThan(lessThan1),.overflow(overflow1));
    alu aluuu2(.data_operandA(finalA),.data_operandB(full_imm),.ctrl_ALUopcode(5'b00000),.ctrl_shiftamt(dxShamt),.data_result(data_result2),.isNotEqual(notEq2),.isLessThan(lessThan2),.overflow(overflow2));
    //assign data_writeReg = data_result1;
    wire [31:0] ALURes;
    wire [31:0] finalOvf,almostALURes;
    //assign data_writeReg = (opcode == 5'b00000) ? data_result1 : data_result2; 
    assign almostALURes = (dxOpcode == 5'b00000) ? data_result1 : data_result2; 
    assign finalOvf[0] = (dxOpcode == 5'b00000) ? overflow1 : overflow2;
    wire [31:0] excALURes;
    wire opC0,opCAI,OvfAnd0,OvfAndAI;
    assign opC0 = (dxOpcode == 5'b00000);
    assign opCAI = (dxOpcode == 5'b00101);
    and andOvf0(OvfAnd0,opC0,finalOvf);
    and andOvfAI(OvfAndAI,opCAI,finalOvf);
    wire [31:0] maybe_ALU1,maybe_ALU2;
    mux_2_32 muxALU1(.out(maybe_ALU1),.select(OvfAnd0),.in0(almostALURes),.in1(excALURes));
    mux_2_32 muxALU2(.out(maybe_ALU2),.select(OvfAndAI),.in0(almostALURes),.in1(32'b00000000000000000000000000000010));
    mux_2_32 muxALU3(.out(ALURes),.select(OvfAndAI),.in0(maybe_ALU1),.in1(maybe_ALU2));
    mux_32_32 muxExcALURes(.out(excALURes),.select(dxALUOp),.in0(32'b00000000000000000000000000000001),.in1(32'b00000000000000000000000000000011),.in2(almostALURes),.in3(almostALURes),.in4(almostALURes),.in5(almostALURes),.in6(32'b00000000000000000000000000000100),.in7(32'b00000000000000000000000000000101),.in8(almostALURes),.in9(almostALURes),.in10(almostALURes),.in11(almostALURes),.in12(almostALURes),.in13(almostALURes),.in14(almostALURes),.in15(almostALURes),.in16(almostALURes),.in17(almostALURes),.in18(almostALURes),.in19(almostALURes),.in20(almostALURes),.in21(almostALURes),.in22(almostALURes),.in23(almostALURes),.in24(almostALURes),.in25(almostALURes),.in26(almostALURes),.in27(almostALURes),.in28(almostALURes),.in29(almostALURes),.in30(almostALURes),.in31(almostALURes));

    //assign data_writeReg = 1;

    wire notClk;
    not notClock(notClk,clock);
    wire [31:0] pcIn,pcOut;
    regSingle pcReg(.clk(notClk),.reset(reset),.writeEnable(shouldDefStall),.valIn(pcIn),.valOut(pcOut));
    wire [31:0] pcP1;
    alu pcPlusOne(.data_operandA(pcOut),.data_operandB(32'b00000000000000000000000000000001),.ctrl_ALUopcode(5'b00000),.ctrl_shiftamt(5'b00000),.data_result(pcP1),.isNotEqual(),.isLessThan(),.overflow());
    //assign data_writeReg = pcP1;
    assign address_imem = pcOut;
    //assign pcIn = pcP1;
    wire [31:0] potentialJump;
    wire [1:0] jumpLogic;
    assign jumpLogic[1] = jOrJal;
    assign jumpLogic[0] = shouldJr;
    mux_4_32 muxPotJ(.out(potentialJump), .select(jumpLogic), .in0(pcP1), .in1(finalB), .in2(fullDxTarg), .in3(pcP1));
    mux_2_32 muxPCIn(.out(pcIn),.select(shouldBranch),.in0(potentialJump),.in1(PCpN));

    wire [31:0] fdInstrIn;
    wire fdNOP;
    //CHANGE W COMPLEXITY PROB
    assign fdNOP = shouldBranchOrJump;
    mux_2_32 muxFDInstrIn(.out(fdInstrIn),.select(fdNOP),.in0(q_imem),.in1(32'b00000000000000000000000000000000));
    wire fdReset,dxReset;
    wire [31:0] fdPCOut,fdInstrOut,almostFdInstrOut;
    regSingle fdpcReg(.clk(notClk),.reset(reset),.writeEnable(shouldDefStall),.valIn(pcP1),.valOut(fdPCOut));
    regSingle fdinstrReg(.clk(notClk),.reset(fdReset),.writeEnable(shouldDefStall),.valIn(fdInstrIn),.valOut(almostFdInstrOut));

    wire dxNOP;
    assign dxNOP = shouldBranchOrJump;
    mux_2_32 muxDXInstrIn(.out(fdInstrOut),.select(dxNOP),.in0(almostFdInstrOut),.in1(32'b00000000000000000000000000000000));
    wire [31:0] dxPCOut,dxInstrOut,dxAOut,dxBOut;
    regSingle dxpcReg(.clk(notClk),.reset(reset),.writeEnable(shouldStall),.valIn(fdPCOut),.valOut(dxPCOut));
    regSingle dxinstrReg(.clk(notClk),.reset(reset),.writeEnable(shouldStall),.valIn(fdInstrOut),.valOut(dxInstrOut));
    regSingle dxAReg(.clk(notClk),.reset(reset),.writeEnable(shouldStall),.valIn(data_readRegA),.valOut(dxAOut));
    regSingle dxBReg(.clk(notClk),.reset(reset),.writeEnable(shouldStall),.valIn(data_readRegB),.valOut(dxBOut));

    //do N + dxPCOut, then pass that into mux for branching thing
    wire [31:0] PCpN;
    alu pcPlusN(.data_operandA(dxPCOut),.data_operandB(full_imm),.ctrl_ALUopcode(5'b00000),.ctrl_shiftamt(5'b00000),.data_result(PCpN),.isNotEqual(),.isLessThan(),.overflow());
    //branching logic
    wire bneComm,bltComm,bneRes,bltRes,shouldBranch;
    assign bneComm = (dxOpcode == 5'b00010);
    assign bltComm = (dxOpcode == 5'b00110);
    and andBne(bneRes,bneComm,notEq1);
    and andBlt(bltRes,bltComm,lessThan1);
    or orBranch(shouldBranch,bneRes,bltRes);
    //assign dxReset = shouldBranch;
    //assign fdReset = shouldBranch;

    //jump logic
    wire shouldJ,shouldJal,shouldJr;
    assign shouldJ = (dxOpcode == 5'b00001);
    assign shouldJal = (dxOpcode == 5'b00011);
    assign shouldJr = (dxOpcode == 5'b00100);

    wire shouldBex;
    wire bexComm;
    assign bexComm = (dxOpcode == 5'b10110);
    and andBex(shouldBex,bexComm,notEq1);

    wire jOrJal;
    or orJOrJal(jOrJal,shouldJ,shouldJal,shouldBex);

    wire shouldBranchOrJump;
    or orBranchOrJump(shouldBranchOrJump,shouldBranch,shouldJ,shouldJal,shouldJr,shouldBex);
    assign dxReset = shouldBranchOrJump;

    //MULDIV
    wire multALU,divALU;
    assign multALU = (dxALUOp == 5'b00110);
    assign divALU = (dxALUOp == 5'b00111);
    wire rTyyy;
    assign rTyyy = (dxOpcode == 5'b00000);
    wire isMult,isDiv;
    wire notReady;
    not notReadyReg(notReady,multdivRDY);
    and andMult(isMult,multALU,rTyyy);
    and andDiv(isDiv,divALU,rTyyy);


    wire [31:0] multdivRes;
    wire multdivExc,multdivRDY;

    multdiv multtt(
	.data_operandA(finalA), .data_operandB(finalB), 
	.ctrl_MULT(ctrl_MULT), .ctrl_DIV(ctrl_DIV), 
	.clock(clock), 
	.data_result(multdivRes), .data_exception(multdivExc), .data_resultRDY(multdivRDY));

    wire [31:0] fullMDExc;
    assign fullMDExc[0] = multdivExc;

    //do mult logic
    wire multOrDiv,multDivWorking;
    or mOD(multOrDiv,isMult,isDiv,multdivRDY);
    tff multIsHappening(multOrDiv,clock,1'b1,reset,multDivWorking);
    wire [31:0] multdivResReg,multdivExcReg;
    wire [31:0] multdivRegIn;
    wire [31:0] mDExcVal;
    assign mDExcVal = (isMult) ? 32'b00000000000000000000000000000100 : 32'b00000000000000000000000000000101;
    assign multdivRegIn = (multdivExc) ? mDExcVal : multdivRes;
    regSingle multdivResRegg(.clk(notClk),.reset(reset),.writeEnable(shouldDefStall),.valIn(multdivRegIn),.valOut(multdivResReg));
    regSingle multdivExcRegg(.clk(notClk),.reset(reset),.writeEnable(shouldDefStall),.valIn(fullMDExc),.valOut(multdivExcReg));
    //finish :(

    wire stall, S2M,S2D;
    or stallOr(stall,isMult && notReady,isDiv && notReady);
    dffe_ref S2MReg(S2M,isMult && notReady,clock,1'b1,reset);
    dffe_ref S2DReg(S2D,isDiv && notReady,clock,1'b1,reset);
    wire notS2M,notS2D;
    not notS2MReg(notS2M,S2M);
    not notS2DReg(notS2D,S2D);
    wire ctrl_MULT,ctrl_DIV;
    and andMultReg(ctrl_MULT,isMult,notS2M);
    and andDivReg(ctrl_DIV,isDiv,notS2D);

    wire stallCases1,sCfDdX1,sCfDdX2,sCfDxM1,sCfDxM2;
    wire shouldStalll;

    assign sCfDdX1 = (ctrl_readRegA==ctrl_writeRegDX);
    assign sCfDdX2 = (ctrl_readRegB==ctrl_writeRegDX);
    assign sCfDxM1 = (ctrl_readRegA==ctrl_writeRegXM);
    assign sCfDxM2 = (ctrl_readRegB==ctrl_writeRegXM);
    or stallCases1Or(stallCases1,sCfDdX1,sCfDdX2,sCfDxM1,sCfDxM2);
    not notStallCases1(shouldStalll,stallCases1);
    
    wire [4:0] tempRDdX,tempRDxM,ctrl_writeRegDX,ctrl_writeRegXM;
    mux_32_5 muxCtrlWriteDX(.out(tempRDdX),.select(dxOpcode),.in0(dxRD),.in1(dxRD),.in2(dxRD),.in3(5'b11111),.in4(dxRD),.in5(dxRD),.in6(dxRD),.in7(dxRD),.in8(dxRD),.in9(dxRD),.in10(dxRD),.in11(dxRD),.in12(dxRD),.in13(dxRD),.in14(dxRD),.in15(dxRD),.in16(dxRD),.in17(dxRD),.in18(dxRD),.in19(dxRD),.in20(dxRD),.in21(5'b11110),.in22(dxRD),.in23(dxRD),.in24(dxRD),.in25(dxRD),.in26(dxRD),.in27(dxRD),.in28(dxRD),.in29(dxRD),.in30(dxRD),.in31(dxRD));
    //and then choose final based on if there was an exception in ALUStage
    wire excValDX;
    or excValOrDX(excValDX,opC0,opCAI);
    wire shouldExceptDX;
    wire shouldWriteRStatDX;
    wire mulOrDivDX,mulOrDivExcDX;
    wire mulDX,divDX;
    and mulDXAnd(mulDX,(dxOpcode==5'b00000),(dxALUOp==5'b00110));
    and divDXAnd(divDX,(dxOpcode==5'b00000),(dxALUOp==5'b00111));
    or orMulOrDivDX(mulOrDivDX,mulDX,divDX);
    and mulOrDivExcAndDX(mulOrDivExcDX,mulOrDivDX,fullMDExc[0]);
    and andExceptDX(shouldWriteRStatDX,finalOvf[0],excValDX);
    or orExceptDX(shouldExceptDX,shouldWriteRStatDX,mulOrDivExcDX);
    mux_2_5 muxFinalWriteDX(.out(ctrl_writeRegDX),.select(shouldExceptDX),.in0(tempRDdX),.in1(5'b11110));
    
    mux_32_5 muxCtrlWriteXM(.out(tempRDxM),.select(xmOpcode),.in0(xmRD),.in1(xmRD),.in2(xmRD),.in3(5'b11111),.in4(xmRD),.in5(xmRD),.in6(xmRD),.in7(xmRD),.in8(xmRD),.in9(xmRD),.in10(xmRD),.in11(xmRD),.in12(xmRD),.in13(xmRD),.in14(xmRD),.in15(xmRD),.in16(xmRD),.in17(xmRD),.in18(xmRD),.in19(xmRD),.in20(xmRD),.in21(5'b11110),.in22(xmRD),.in23(xmRD),.in24(xmRD),.in25(xmRD),.in26(xmRD),.in27(xmRD),.in28(xmRD),.in29(xmRD),.in30(xmRD),.in31(xmRD));
    //and then choose final based on if there was an exception in ALUStage
    wire excValXM;
    or excValOrXM(excValXM,(dxOpcode==5'b00000),(dxOpcode==5'b00101));
    wire shouldExceptXM;
    wire shouldWriteRStatXM;
    wire mulOrDivXM,mulOrDivExcXM;
    wire mulXM,divXM;
    and mulXMAnd(mulXM,(xmOpcode==5'b00000),(xmALUOp==5'b00110));
    and divXMAnd(divXM,(xmOpcode==5'b00000),(xmALUOp==5'b00111));
    or orMulOrDivXM(mulOrDivXM,mulXM,divXM);
    and mulOrDivExcAndXM(mulOrDivExcXM,mulOrDivXM,multdivExcReg[0]);
    and andExceptXM(shouldWriteRStatXM,xmExceptOut[0],excValXM);
    or orExceptXM(shouldExceptXM,shouldWriteRStatXM,mulOrDivExcXM);
    mux_2_5 muxFinalWriteXM(.out(ctrl_writeRegXM),.select(shouldExceptXM),.in0(tempRDxM),.in1(5'b11110));


    wire shouldStall;
    not notStall(shouldStall,stall);
    wire shouldDefStalll;
    and andDefStall(shouldDefStalll,shouldStall,shouldStalll);
    wire shouldDefStall;
    wire stallCondsEx;
    //and stallCondsExAnd(stallCondsEx,stallConds,)
    wire stallCondsN;
    not notStallCondsN(stallCondsN,stallConds);
    wire defStallPos;
    or orDefStallPos(defStallPos,stall,stallConds);
    not notDefStallPos(shouldDefStall,defStallPos);
    //and andDefStalll(shouldDefStall,shouldStall,stallCondsN);
    //assign shouldDefStall = shouldStall;
    //or orDefStall(shouldDefStall,shouldDefStalll,pcOut == 32'b00000000000000000000000000000000,pcOut == 32'b00000000000000000000000000000001,fdInstrOut == 32'b00000000000000000000000000000000);

    wire [31:0] dataa;
    wire [31:0] xmInstrOut,xmALUResOut,xmPCOut,xmExceptOut;
    regSingle xmpcReg(.clk(notClk),.reset(reset),.writeEnable(shouldStall),.valIn(dxPCOut),.valOut(xmPCOut));
    regSingle xminstrReg(.clk(notClk),.reset(reset),.writeEnable(shouldStall),.valIn(dxInstrOut),.valOut(xmInstrOut));
    regSingle xmALUResReg(.clk(notClk),.reset(reset),.writeEnable(shouldStall),.valIn(ALURes),.valOut(xmALUResOut));
    regSingle xmExceptReg(.clk(notClk),.reset(reset),.writeEnable(shouldStall),.valIn(finalOvf),.valOut(xmExceptOut));
    regSingle xmMemDataReg(.clk(notClk),.reset(reset),.writeEnable(shouldStall),.valIn(finalB),.valOut(dataa));
    assign address_dmem = xmALUResOut;

    wire [31:0] mwDataMemOut,mwALUResOut,mwInstrOut,mwPCOut,mwExceptOut,mwMDResOut,mwMDExcOut;
    regSingle mwpcReg(.clk(notClk),.reset(reset),.writeEnable(1'b1),.valIn(xmPCOut),.valOut(mwPCOut));
    regSingle mwDataMemReg(.clk(notClk),.reset(reset),.writeEnable(1'b1),.valIn(q_dmem),.valOut(mwDataMemOut));
    regSingle mwALUResReg(.clk(notClk),.reset(reset),.writeEnable(1'b1),.valIn(xmALUResOut),.valOut(mwALUResOut));
    regSingle mwExceptReg(.clk(notClk),.reset(reset),.writeEnable(1'b1),.valIn(xmExceptOut),.valOut(mwExceptOut));
    regSingle mwInstrReg(.clk(notClk),.reset(reset),.writeEnable(1'b1),.valIn(xmInstrOut),.valOut(mwInstrOut));
    regSingle mwMDResReg(.clk(notClk),.reset(reset),.writeEnable(1'b1),.valIn(multdivResReg),.valOut(mwMDResOut));
    regSingle mwMDExcReg(.clk(notClk),.reset(reset),.writeEnable(1'b1),.valIn(multdivExcReg),.valOut(mwMDExcOut));
    
    
    
    wire [31:0] tempXMALUForBy;
    mux_32_32 muxDataWriteXM(.out(tempXMALUForBy),.select(xmOpcode),.in0(xmALUResOut),.in1(xmALUResOut),.in2(xmALUResOut),.in3(xmPCOut),.in4(xmALUResOut),.in5(xmALUResOut),.in6(xmALUResOut),.in7(xmALUResOut),.in8(q_dmem),.in9(xmALUResOut),.in10(xmALUResOut),.in11(xmALUResOut),.in12(xmALUResOut),.in13(xmALUResOut),.in14(xmALUResOut),.in15(xmALUResOut),.in16(xmALUResOut),.in17(xmALUResOut),.in18(xmALUResOut),.in19(xmALUResOut),.in20(xmALUResOut),.in21(LongTargXM),.in22(xmALUResOut),.in23(xmALUResOut),.in24(xmALUResOut),.in25(xmALUResOut),.in26(xmALUResOut),.in27(xmALUResOut),.in28(xmALUResOut),.in29(xmALUResOut),.in30(xmALUResOut),.in31(xmALUResOut));
    wire [31:0] valToByALUA;
    assign valToByALUA = (mulOrDivXM) ? multdivResReg : tempXMALUForBy;
    wire [31:0] LongTargXM;
    assign LongTargXM[31:27] = xmPCOut[31:27];
    assign LongTargXM[26:0] = xmTarg;
    wire [31:0] actualALUByVal;
    wire [31:0] actualRDByVal;
    assign actualALUByVal = (ctrl_writeRegXM == 5'b00000) ? 32'b00000000000000000000000000000000 : valToByALUA;
    assign actualRDByVal = (ctrl_writeReg == 5'b00000) ? 32'b00000000000000000000000000000000 : data_writeReg;


    //TO DO MUX FOR A AND B FOR ALU AND MULTDIV WITH VALTOBYALUA,DATAWRITEREG,ANDTHEACTUALVALSTHATARERN
    //ANDCTRL IS ASPERSLIDE
    wire [1:0] muxCtrlByA,muxCtrlByB;
    wire [4:0] temp_ADX,temp_BDX;
    wire [4:0] real_ADX,real_BDX;
    
    assign real_BDX = (dxOpcode == 5'b00000) ? temp_BDX : dxRD;
    assign real_ADX = (dxOpcode == 5'b10110) ? 5'b11110 : temp_ADX;
    assign muxCtrlByB[0] = (real_BDX == ctrl_writeRegXM) && (ctrl_writeEnableXM == 1'b1);
    assign muxCtrlByB[1] = (real_BDX == ctrl_writeReg) && (ctrl_writeEnable == 1'b1);
    assign muxCtrlByA[0] = (real_ADX == ctrl_writeRegXM) && (ctrl_writeEnableXM == 1'b1);
    assign muxCtrlByA[1] = (real_ADX == ctrl_writeReg) && (ctrl_writeEnable == 1'b1);

    wire [31:0] finalA,finalB;
    mux_4_32 muxByA(.out(finalA),.select(muxCtrlByA),.in0(dxAOut),.in1(actualALUByVal),.in2(actualRDByVal),.in3(actualALUByVal));
    mux_4_32 muxByB(.out(finalB),.select(muxCtrlByB),.in0(dxBReal),.in1(actualALUByVal),.in2(actualRDByVal),.in3(actualALUByVal));
 

    //bypassing into memory
    wire memByCtrl;
    wire [4:0] temp_AXM,temp_BXM;
    wire [4:0] real_AXM,real_BXM;
    assign real_BXM = (xmOpcode == 5'b00000) ? temp_BXM : xmRD;
    assign real_AXM = (xmOpcode == 5'b10110) ? 5'b11110 : temp_AXM;
    assign memByCtrl = (real_BXM == ctrl_writeReg) && (ctrl_writeEnable == 1'b1);
    mux_2_32 muxDataBy(.out(data),.select(memByCtrl),.in0(dataa),.in1(actualRDByVal));
    

    //stalling
    wire stallCond1,stallCond31,stallCond32,stallCond3,stallCond12,stallCond2;
    wire stallConds;
    assign stallCond1 = (dxOpcode == 5'b01000);
    assign stallCond32 = (opcode != 5'b00111);
    assign stallCond12 = (ctrl_readRegA == ctrl_writeRegDX);
    assign stallCond31 = (ctrl_readRegB == ctrl_writeRegDX);
    wire bothNOPs,notBothNOPs;
    assign bothNOPs = (dxInstrOut == 32'b00000000000000000000000000000000) && (fdInstrOut == 32'b00000000000000000000000000000000);
    not notBothNOPsGate(notBothNOPs,bothNOPs);
    and stallCond3And(stallCond3,stallCond31,stallCond32,notBothNOPs);
    wire stall23,stall2AndNOP;
    and stallCond2AndNOP(stall2AndNOP,stallCond12,notBothNOPs);
    or stall23Or(stall23,stall2AndNOP,stallCond3);
    //and stallCond1And(stallCond1,stallCond11,stallCond12,notBothNOPs);
    and stallCond1And(stallConds,stallCond1,stall23);


    //DO21AND22


    //choose bw these two vals (ALUResOut and DataMemOut) for data_writeReg
    //and then do decode of mwInstrOut to get ctrl_writeReg
    wire [4:0] mwOpcode, mwRD, mwRS,mwRT,mwShamt, mwALUop;
    wire [1:0] mwZeroesShort;
    wire [16:0] mwImm;
    wire [26:0] mwTarg;
    wire [21:0] mwZeroesLong;

    wire [31:0] LongTarg;
    wire [4:0] tempCtrlWriteReg;
    wire shouldWriteRStat;
    assign LongTarg[31:27] = mwPCOut[31:27];
    assign LongTarg[26:0] = mwTarg;
    instr_decode decodeee2(.instruction(mwInstrOut),.opcode(mwOpcode),.rD(mwRD),.rs(mwRS),.rt(mwRT),.shamt(mwShamt),.ALUop(mwALUop),.zeroesShort(mwZeroesShort),.imm(mwImm),.targ(mwTarg),.zeroesLong(mwZeroesLong));
    wire [31:0] tempDataWriteReg;
    mux_32_32 muxDataWrite(.out(tempDataWriteReg),.select(mwOpcode),.in0(mwALUResOut),.in1(mwALUResOut),.in2(mwALUResOut),.in3(mwPCOut),.in4(mwALUResOut),.in5(mwALUResOut),.in6(mwALUResOut),.in7(mwALUResOut),.in8(mwDataMemOut),.in9(mwALUResOut),.in10(mwALUResOut),.in11(mwALUResOut),.in12(mwALUResOut),.in13(mwALUResOut),.in14(mwALUResOut),.in15(mwALUResOut),.in16(mwALUResOut),.in17(mwALUResOut),.in18(mwALUResOut),.in19(mwALUResOut),.in20(mwALUResOut),.in21(LongTarg),.in22(mwALUResOut),.in23(mwALUResOut),.in24(mwALUResOut),.in25(mwALUResOut),.in26(mwALUResOut),.in27(mwALUResOut),.in28(mwALUResOut),.in29(mwALUResOut),.in30(mwALUResOut),.in31(mwALUResOut));
    assign data_writeReg = (mulOrDivMW) ? mwMDResOut : tempDataWriteReg;
    mux_32_5 muxCtrlWrite(.out(tempCtrlWriteReg),.select(mwOpcode),.in0(mwRD),.in1(mwRD),.in2(mwRD),.in3(5'b11111),.in4(mwRD),.in5(mwRD),.in6(mwRD),.in7(mwRD),.in8(mwRD),.in9(mwRD),.in10(mwRD),.in11(mwRD),.in12(mwRD),.in13(mwRD),.in14(mwRD),.in15(mwRD),.in16(mwRD),.in17(mwRD),.in18(mwRD),.in19(mwRD),.in20(mwRD),.in21(5'b11110),.in22(mwRD),.in23(mwRD),.in24(mwRD),.in25(mwRD),.in26(mwRD),.in27(mwRD),.in28(mwRD),.in29(mwRD),.in30(mwRD),.in31(mwRD));
    //and then choose final based on if there was an exception in ALUStage
    wire excVal;
    or excValOr(excVal,(mwOpcode==5'b00000),(mwOpcode==5'b00101));
    wire shouldExcept;
    wire mulOrDivMW,mulOrDivExc;
    wire mulMW,divMW;
    and mulMWAnd(mulMW,(mwOpcode==5'b00000),(mwALUop==5'b00110));
    and divMWAnd(divMW,(mwOpcode==5'b00000),(mwALUop==5'b00111));
    or orMulOrDivMW(mulOrDivMW,mulMW,divMW);
    and mulOrDivExcAnd(mulOrDivExc,mulOrDivMW,mwMDExcOut[0]);
    and andExcept(shouldWriteRStat,mwExceptOut[0],excVal);
    or orExcept(shouldExcept,shouldWriteRStat,mulOrDivExc);
    mux_2_5 muxFinalWrite(.out(ctrl_writeReg),.select(shouldExcept),.in0(tempCtrlWriteReg),.in1(5'b11110));


    //MAKE ALL THE ENABLES (BIGGG MUXES)

    //wren
    wire [4:0] xmOpcode,xmRD,xmALUOp;
    wire [26:0] xmTarg;
    instr_decode decodeee4(.instruction(xmInstrOut),.opcode(xmOpcode),.rD(xmRD),.rs(temp_AXM),.rt(temp_BXM),.shamt(),.ALUop(xmALUOp),.zeroesShort(),.imm(),.targ(xmTarg),.zeroesLong());
    mux_32_1 muxMemWE(.out(wren),.select(xmOpcode),.in0(1'b0),.in1(1'b0),.in2(1'b0),.in3(1'b0),.in4(1'b0),.in5(1'b0),.in6(1'b0),.in7(1'b1),.in8(1'b0),.in9(1'b0),.in10(1'b0),.in11(1'b0),.in12(1'b0),.in13(1'b0),.in14(1'b0),.in15(1'b0),.in16(1'b0),.in17(1'b0),.in18(1'b0),.in19(1'b0),.in20(1'b0),.in21(1'b0),.in22(1'b0),.in23(1'b0),.in24(1'b0),.in25(1'b0),.in26(1'b0),.in27(1'b0),.in28(1'b0),.in29(1'b0),.in30(1'b0),.in31(1'b0));


    //reg write enable
    wire ctrl_writeEnableXM;
    mux_32_1 muxRegWE(.out(ctrl_writeEnable),.select(mwOpcode),.in0(1'b1),.in1(1'b0),.in2(1'b0),.in3(1'b1),.in4(1'b0),.in5(1'b1),.in6(1'b0),.in7(1'b0),.in8(1'b1),.in9(1'b0),.in10(1'b0),.in11(1'b0),.in12(1'b0),.in13(1'b0),.in14(1'b0),.in15(1'b0),.in16(1'b0),.in17(1'b0),.in18(1'b0),.in19(1'b0),.in20(1'b0),.in21(1'b1),.in22(1'b0),.in23(1'b0),.in24(1'b0),.in25(1'b0),.in26(1'b0),.in27(1'b0),.in28(1'b0),.in29(1'b0),.in30(1'b0),.in31(1'b0));
    mux_32_1 muxRegXMWE(.out(ctrl_writeEnableXM),.select(xmOpcode),.in0(1'b1),.in1(1'b0),.in2(1'b0),.in3(1'b1),.in4(1'b0),.in5(1'b1),.in6(1'b0),.in7(1'b0),.in8(1'b1),.in9(1'b0),.in10(1'b0),.in11(1'b0),.in12(1'b0),.in13(1'b0),.in14(1'b0),.in15(1'b0),.in16(1'b0),.in17(1'b0),.in18(1'b0),.in19(1'b0),.in20(1'b0),.in21(1'b1),.in22(1'b0),.in23(1'b0),.in24(1'b0),.in25(1'b0),.in26(1'b0),.in27(1'b0),.in28(1'b0),.in29(1'b0),.in30(1'b0),.in31(1'b0));



	/* END CODE */

endmodule
