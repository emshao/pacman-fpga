`timescale 1ns/100ps
module div_tb;

    // module inputs
    reg clock = 0, ctrl_Mult, ctrl_Div, interrupt;
    reg signed [31:0] operandA, operandB;

    // expected module outputs
    reg exp_except;
    reg signed [31:0] exp_result;

    // module outputs
    wire ready, except;
    wire signed [63:0] result;
    wire bottomBit;

    // Instantiate multdiv
    div tester(operandA, operandB, ctrl_Div, clock,
        result, except, ready);

	// Initialize our strings
	reg[511:0] testName, outDir;

	// Where to store file error codes
	integer 	expFile,		diffFile, 	  actFile,
				expScan;

	// Metadata
	integer errors = 0,
			tests = 0;

	reg[7:0] counter = 0;
	integer i = 0;

	initial begin
        operandA = 24;
        operandB = 2;
		ctrl_Div = 1'b1;
        $display("result at step: %b,ctrl: %b,opA:%b,opB:%b,exc: %b",result,ctrl_Mult,operandA,operandB,except);
        // #100;
        // ctrl_Mult = ~ctrl_Mult;
        @(negedge clock);
            ctrl_Div = 0;

		// Display the tests and errors
		//$display("Finished %0d test%c with %0d error%c \n", tests, "s"*(tests != 1), errors, "s"*(errors != 1));

		#6600;
		$finish;
	end

    always 
    	#100 
        clock = !clock;
    always @(posedge clock) begin
        #20;
        i = i + 1;
        $display("result at step %b/2: %b,ctrl: %b, exc: %b,done: %b",i,result,ctrl_Div,except,ready);

    end


endmodule
