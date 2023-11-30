module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // add your code here

    //logic to choose between the result of the multiplier or the divider
    wire mulOrDiv,chooser,notChooser;
    or mDOr(mulOrDiv,ctrl_MULT,ctrl_DIV);
    dlatch_1 latchChooser(ctrl_MULT,mulOrDiv,chooser,notChooser);
    mux_2_32 chooseResult(data_result,chooser,div_res,mul_res);
    mux_2_1 chooseExc(data_exception,chooser,div_exception,mul_exception);
    wire data_resultAlmostRDY,d2;
    mux_2_1 chooseRDY(data_resultAlmostRDY,chooser,div_RDY,mul_RDY);
    dffe_ref dffRDY(d2,data_resultAlmostRDY,clock,1'b1,1'b0);
    wire nottD2;
    not notD2(nottD2,d2);
    and rdyAnd(data_resultRDY,nottD2,data_resultAlmostRDY);

    //multiplier and divider
    wire[31:0] mul_res,div_res;
    wire mul_exception,div_exception,mul_RDY,div_RDY;
    mult multiplyy(data_operandA,data_operandB,ctrl_MULT,clock,mul_res,mul_exception,mul_RDY);
    div dividee(data_operandA,data_operandB,ctrl_DIV,clock,div_res,div_exception,div_RDY);

endmodule