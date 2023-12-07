module mult(
	data_operandANoReg, data_operandBNoReg, 
	ctrl_MULT,  
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandANoReg, data_operandBNoReg;
    input ctrl_MULT, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here
    //latching inputs
    wire [31:0] Ainv,Binv,data_operandA,data_operandB;
    dlatch latchA(data_operandANoReg,ctrl_MULT,data_operandA,Ainv);
    dlatch latchB(data_operandBNoReg,ctrl_MULT,data_operandB,Binv);

    wire topBitIn,topBitOut;
    wire bottomBit;
    wire notClk;
    not notClock(notClk,clock);
    wire [31:0] bottomBitIn,bottomBitOut;
    regSingle bottomBitGate(clock,ctrl_MULT,notCTRL,bottomBitIn,bottomBitOut);

    wire [63:0] regIn,regOut;
    wire [2:0] BoothOp;
    register64 prodReg(clock,ctrl_MULT,1'b1,regIn,regOut);
    assign BoothOp[2:1] = regOut[1:0];
    assign BoothOp[0] = bottomBitOut[0];

    wire [31:0] aShifted;
    assign aShifted = data_operandA << 1;

    wire [31:0] aS,sS,aNS,sNS,dN;
    wire c32aS,c32sS,c32aNS,c32sNS,c32dN;
    wire [31:0] orraS,orrsS,orraNS,orrsNS,orrdN;
    wire [31:0] anddaS,anddsS,anddaNS,anddsNS,andddN;

    cla_32_for_mult adderS(1'b0,regOut[63:32],aShifted,aS,c32aS,orraS,anddaS);
    cla_32_for_mult adderNS(1'b0,regOut[63:32],data_operandA,aNS,c32aNS,orraNS,anddaNS);
    cla_32_for_mult subS(1'b1,regOut[63:32],aShifted,sS,c32sS,orrsS,anddsS);
    cla_32_for_mult subNS(1'b1,regOut[63:32],data_operandA,sNS,c32sNS,orrsNS,anddsNS);
    cla_32_for_mult doN(1'b0,regOut[63:32],0,dN,c32dN,orrdN,andddN);

    //counter
    wire [4:0] count;
    wire notCTRL,countEnable,nC4;
    not notC4(nC4,count[4]);
    not nCTRL(notCTRL,ctrl_MULT);
    and countEn(countEnable,notCTRL,nC4);
    m32counter countMult(notCTRL,clock,ctrl_MULT,count);
    
    wire [31:0] postMuxTopVal;
    mux_8_30 muxS30(regIn[61:32],BoothOp,dN[31:2],aNS[31:2],aNS[31:2],aS[31:2],sS[31:2],sNS[31:2],sNS[31:2],dN[31:2]);
    mux_8_32 muxS2(postMuxTopVal,BoothOp,dN,aNS,aNS,aS,sS,sNS,sNS,dN);
    mux_2_2 muxMid(regIn[31:30],ctrl_MULT,postMuxTopVal[1:0],data_operandB[31:30]);
    wire toBeXRed;
    mux_8_1 mux1S(toBeXRed,BoothOp,c32dN,c32aNS,c32aNS,c32aS,c32sS,c32sNS,c32sNS,c32dN);
    xor xRed1(regIn[62],toBeXRed,postMuxTopVal[31]);
    assign regIn[63] = regIn[62];

    assign bottomBitIn[0] = regOut[1];

    wire [29:0] newRegInCTRL,newRegInOTHER;
    assign newRegInCTRL = data_operandB;
    assign newRegInOTHER = regOut[31:2];
    mux_2_30 muxRI(regIn[29:0],ctrl_MULT,newRegInOTHER,newRegInCTRL);   

    assign data_resultRDY = count[4];

    //making sure the sign of the result makes sense
    wire [2:0] ABResNeg;
    assign ABResNeg[0] = data_operandA[31];
    assign ABResNeg[1] = data_operandB[31];
    assign ABResNeg[2] = regOut[31];
    wire wrongSignButZero;
    mux_8_1 muxWrongSign(wrongSignButZero,ABResNeg,1'b0,1'b1,1'b1,1'b0,1'b1,1'b0,1'b0,1'b1);

    wire AZero,BZero,eitherZero,neitherZero;
    comp_32 compAZero(.A(data_operandA),.B(0),.EQ0(AZero),.GT0());
    comp_32 compBZero(.A(data_operandB),.B(0),.EQ0(BZero),.GT0());
    or eitherZeroOr(eitherZero,AZero,BZero);
    not neitherZeroNot(neitherZero,eitherZero);
    wire wrongSign;
    and wrongSignAnd(wrongSign,neitherZero,wrongSignButZero);


    //seeing if all the top bits are the same
    wire EQZ,GTZ,EQ1,GT1;
    comp_32 compHighBits1(.A(regOut[63:32]),.B(0),.EQ0(EQZ),.GT0(GTZ));
    comp_32 compHighBits2(.A(~regOut[63:32]),.B(0),.EQ0(EQ1),.GT0(GT1));
    wire eitherEq;
    or almostEq(eitherEq,EQZ,EQ1);

    //accounting for edge case where one of the inputs is the max possible positive number
    wire [31:0] maxPoss,posOne,negOne;
    assign maxPoss[31:0] = 32'b01111111111111111111111111111111;
    assign posOne[31:0] = 32'b00000000000000000000000000000001;
    assign negOne[31:0] = 32'b1;
    wire AMax,BMax,AGT1,BGT1,AEQ1,BEQ1,AEQn1,BEQn1,AGTn1,BGTn1,ALTn1,BLTn1;
    comp_32 compAMax(.A(data_operandA),.B(maxPoss),.EQ0(AMax),.GT0());
    comp_32 compBMax(.A(data_operandB),.B(maxPoss),.EQ0(BMax),.GT0());
    comp_32 compAGT1(.A(data_operandA),.B(posOne),.EQ0(AEQ1),.GT0(AGT1));
    comp_32 compBGT1(.A(data_operandB),.B(posOne),.EQ0(BEQ1),.GT0(BGT1));
    comp_32 compAGTn1(.A(data_operandA),.B(negOne),.EQ0(AEQn1),.GT0(AGTn1));
    comp_32 compBGTn1(.A(data_operandB),.B(negOne),.EQ0(BEQn1),.GT0(BGTn1));
    wire AEQGTn1,BEQGTn1;
    or orAEQGT1(AEQGTn1,AEQn1,AGTn1);
    or orBEQGT1(BEQGTn1,BEQn1,BGTn1);
    not notAGTn1(ALTn1,AEQGTn1);
    not notBGTn1(BLTn1,BEQGTn1);
    wire BTooBig,ATooBig;
    or BBigOr(BTooBig,BGT1,BLTn1);
    or ABigOr(ATooBig,AGT1,ALTn1);
    wire AMaxBad,BMaxBad;
    and AMaxBadAnd(AMaxBad,AMax,BTooBig);
    and BMaxBadAnd(BMaxBad,BMax,ATooBig);
    wire eitherBadBig;
    or eitherBadBigOr(eitherBadBig,AMaxBad,BMaxBad);

    wire classicOvf;
    not classOvf(classicOvf,eitherEq);
    or ovfOrrr(data_exception,classicOvf,wrongSign,eitherBadBig);

    assign data_result = regOut[31:0];   

endmodule