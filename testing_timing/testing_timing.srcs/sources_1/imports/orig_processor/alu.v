module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire zero,one;
    assign zero = 1'b0;
    assign one = 1'b1;

    wire [31:0] add_result, sub_result, and_result, or_result, sll_result, sra_result;
    wire [31:0] fake_and, fake_or;
    wire overflow_add, overflow_sub;

    cla_32 adder(.sub(zero),.ex(data_operandA),.wyy(data_operandB),.S(add_result),.ovf(overflow_add),.orr(or_result),.andd(and_result));
    cla_32 subtractor(.sub(one),.ex(data_operandA),.wyy(data_operandB),.S(sub_result),.ovf(overflow_sub),.orr(fake_or),.andd(fake_and));

    barrel_shift shift_left(.shiftIn(data_operandA),.shAmt(ctrl_shiftamt),.right(zero),.shiftOut(sll_result));
    barrel_shift shift_right(.shiftIn(data_operandA),.shAmt(ctrl_shiftamt),.right(one),.shiftOut(sra_result));

    //define overflow
    mux_2_1 overflowChoose(.out(overflow),.select(ctrl_ALUopcode[0]),.in0(overflow_add),.in1(overflow_sub));

    wire [31:0] subLT_result;
    wire subLT_ovf;
    cla_32 subLT(.sub(one),.ex(data_operandB),.wyy(data_operandA),.S(subLT_result),.ovf(subLT_ovf),.orr(),.andd());
    //define isLessThan
    wire almostLessThan,invertedAlmostLessThan;
    mux_2_1 lessThanChoose(.out(almostLessThan),.select(subLT_result[31]),.in0(zero),.in1(one));
    not notLessThan(invertedAlmostLessThan,almostLessThan);
    mux_2_1 lessThanFR(.out(isLessThan),.select(subLT_ovf),.in0(almostLessThan),.in1(invertedAlmostLessThan));

    //define isNotEqual
    wire EQ,GT;
    comp_32 compAB(.A(data_operandA),.B(data_operandB),.EQ0(EQ),.GT0(GT));
    not notEQ(isNotEqual,EQ);

    //define actual result
    mux_8_32 opChoose(.out(data_result),.select(ctrl_ALUopcode[2:0]),.in0(add_result),.in1(sub_result),.in2(and_result),.in3(or_result),.in4(sll_result),.in5(sra_result),.in6(0),.in7(0));
    



endmodule