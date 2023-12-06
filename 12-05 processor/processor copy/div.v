module div(data_operandANotAbs, data_operandBNotAbs, 
	ctrl_DIV,  
	clock, 
	data_result, data_exception, data_resultRDY);

    input[31:0] data_operandANotAbs, data_operandBNotAbs;
    input ctrl_DIV, clock;
    output[31:0] data_result;
    output data_exception, data_resultRDY;

    //making both operands positive
    wire [31:0] invA,invB;
    wire ovf1A,ovf1B;
    wire [31:0] or1A,and1A,or1B,and1B;
    cla_32_for_mult invA32(1'b1,0,data_operandANotAbs,invA,ovf1A,or1A,and1A);
    cla_32_for_mult invB32(1'b1,0,data_operandBNotAbs,invB,ovf1B,or1B,and1B);

    wire [31:0] data_operandANotL,data_operandBNotL,Ainvv,Binvv;
    mux_2_32 absA(data_operandANotL,data_operandANotAbs[31],data_operandANotAbs,invA);
    mux_2_32 absB(data_operandBNotL,data_operandBNotAbs[31],data_operandBNotAbs,invB);

    //latching data
    wire[31:0] data_operandA,data_operandB;
    dlatch latchA(data_operandANotL,ctrl_DIV,data_operandA,Ainvv);
    dlatch latchB(data_operandBNotL,ctrl_DIV,data_operandB,Binvv);
    
    wire [63:0] regIn,regOut;
    register64 resReg(clock,ctrl_DIV,1'b1,regIn,regOut);

    wire [1:0] LSBChoose;
    assign LSBChoose[1] = ctrl_DIV;
    assign LSBChoose[0] = topBits[31];
    mux_4_1 LSBMux(regIn[0],LSBChoose,1'b1,1'b0,data_operandA[0],data_operandA[0]);

    wire [63:0] rOShifted;
    assign rOShifted = regOut << 1;
    mux_2_31 bottomBitsChoose(regIn[31:1],ctrl_DIV,rOShifted[31:1],data_operandA[31:1]);

    wire [31:0] plussV,minussV;
    wire c32pV,c32mV;
    wire [31:0] orrpV,orrmV,anddpV,anddmV;
    cla_32_for_mult plusV(1'b0,rOShifted[63:32],data_operandB,plussV,c32pV,orrpV,anddpV);
    cla_32_for_mult minusV(1'b1,rOShifted[63:32],data_operandB,minussV,c32mV,orrmV,anddmV);

    wire [31:0] topBits;
    mux_2_32 chooseTop(topBits,regOut[63],minussV,plussV);
    assign regIn[63:32] = topBits;

    //fixing the sign of the quotient
    wire [31:0] invRes;
    wire ovf1Res;
    wire [31:0] or1Res,and1Res;
    cla_32_for_mult invRes32(1'b1,0,regOut[31:0],invRes,ovf1Res,or1Res,and1Res);

    wire signsDiff;
    xor signsDiffXor(signsDiff,data_operandANotAbs[31],data_operandBNotAbs[31]);
    mux_2_32 resMux(data_result,signsDiff,regOut[31:0],invRes);


    //calculating exception
    wire GTZ;
    comp_32 compExcept(.A(data_operandB),.B(0),.EQ0(data_exception),.GT0(GTZ));

    //data_resultRDY (counter)
    wire [5:0] count;
    wire notCTRL,countEnable,nC5;
    not notC4(nC5,count[5]);
    not nCTRL(notCTRL,ctrl_DIV);
    and countEn(countEnable,notCTRL,nC5);
    m64counter countDiv(notCTRL,clock,ctrl_DIV,count);
    
    assign data_resultRDY = count[5];

endmodule