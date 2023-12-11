module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	wire [31:0] writeRegDecode, readRegADecode, readRegBDecode;
	decoder_32 wRD(writeRegDecode,ctrl_writeReg);
	decoder_32 rRAD(readRegADecode,ctrl_readRegA);
	decoder_32 rRBD(readRegBDecode,ctrl_readRegB);

	wire en0,en1,en2,en3,en4,en5,en6,en7,en8,en9,en10,en11,en12,en13,en14,en15,en16,en17,en18,en19,en20,en21,en22,en23,en24,en25,en26,en27,en28,en29,en30,en31;
	and a0(en0,ctrl_writeEnable,writeRegDecode[0]);
	and a1(en1,ctrl_writeEnable,writeRegDecode[1]);
	and a2(en2,ctrl_writeEnable,writeRegDecode[2]);
	and a3(en3,ctrl_writeEnable,writeRegDecode[3]);
	and a4(en4,ctrl_writeEnable,writeRegDecode[4]);
	and a5(en5,ctrl_writeEnable,writeRegDecode[5]);
	and a6(en6,ctrl_writeEnable,writeRegDecode[6]);
	and a7(en7,ctrl_writeEnable,writeRegDecode[7]);
	and a8(en8,ctrl_writeEnable,writeRegDecode[8]);
	and a9(en9,ctrl_writeEnable,writeRegDecode[9]);
	and a10(en10,ctrl_writeEnable,writeRegDecode[10]);
	and a11(en11,ctrl_writeEnable,writeRegDecode[11]);
	and a12(en12,ctrl_writeEnable,writeRegDecode[12]);
	and a13(en13,ctrl_writeEnable,writeRegDecode[13]);
	and a14(en14,ctrl_writeEnable,writeRegDecode[14]);
	and a15(en15,ctrl_writeEnable,writeRegDecode[15]);
	and a16(en16,ctrl_writeEnable,writeRegDecode[16]);
	and a17(en17,ctrl_writeEnable,writeRegDecode[17]);
	and a18(en18,ctrl_writeEnable,writeRegDecode[18]);
	and a19(en19,ctrl_writeEnable,writeRegDecode[19]);
	and a20(en20,ctrl_writeEnable,writeRegDecode[20]);
	and a21(en21,ctrl_writeEnable,writeRegDecode[21]);
	and a22(en22,ctrl_writeEnable,writeRegDecode[22]);
	and a23(en23,ctrl_writeEnable,writeRegDecode[23]);
	and a24(en24,ctrl_writeEnable,writeRegDecode[24]);
	and a25(en25,ctrl_writeEnable,writeRegDecode[25]);
	and a26(en26,ctrl_writeEnable,writeRegDecode[26]);
	and a27(en27,ctrl_writeEnable,writeRegDecode[27]);
	and a28(en28,ctrl_writeEnable,writeRegDecode[28]);
	and a29(en29,ctrl_writeEnable,writeRegDecode[29]);
	and a30(en30,ctrl_writeEnable,writeRegDecode[30]);
	and a31(en31,ctrl_writeEnable,writeRegDecode[31]);

	wire [31:0] r0W,r1W,r2W,r3W,r4W,r5W,r6W,r7W,r8W,r9W,r10W,r11W,r12W,r13W,r14W,r15W,r16W,r17W,r18W,r19W,r20W,r21W,r22W,r23W,r24W,r25W,r26W,r27W,r28W,r29W,r30W,r31W;
	register r0(clock,ctrl_reset,1'b0,32'b00000000000000000000000000000000,r0W);
	register r1(clock,ctrl_reset,en1,data_writeReg,r1W);
	register r2(clock,ctrl_reset,en2,data_writeReg,r2W);
	register r3(clock,ctrl_reset,en3,data_writeReg,r3W);
	register r4(clock,ctrl_reset,en4,data_writeReg,r4W);
	register r5(clock,ctrl_reset,en5,data_writeReg,r5W);
	register r6(clock,ctrl_reset,en6,data_writeReg,r6W);
	register r7(clock,ctrl_reset,en7,data_writeReg,r7W);
	register r8(clock,ctrl_reset,en8,data_writeReg,r8W);
	register r9(clock,ctrl_reset,en9,data_writeReg,r9W);
	register r10(clock,ctrl_reset,en10,data_writeReg,r10W);
	register r11(clock,ctrl_reset,en11,data_writeReg,r11W);
	register r12(clock,ctrl_reset,en12,data_writeReg,r12W);
	register r13(clock,ctrl_reset,en13,data_writeReg,r13W);
	register r14(clock,ctrl_reset,en14,data_writeReg,r14W);
	register r15(clock,ctrl_reset,en15,data_writeReg,r15W);
	register r16(clock,ctrl_reset,en16,data_writeReg,r16W);
	register r17(clock,ctrl_reset,en17,data_writeReg,r17W);
	register r18(clock,ctrl_reset,en18,data_writeReg,r18W);
	register r19(clock,ctrl_reset,en19,data_writeReg,r19W);
	register r20(clock,ctrl_reset,en20,data_writeReg,r20W);
	register r21(clock,ctrl_reset,en21,data_writeReg,r21W);
	register r22(clock,ctrl_reset,en22,data_writeReg,r22W);
	register r23(clock,ctrl_reset,en23,data_writeReg,r23W);
	register r24(clock,ctrl_reset,en24,data_writeReg,r24W);
	register r25(clock,ctrl_reset,en25,data_writeReg,r25W);
	register r26(clock,ctrl_reset,en26,data_writeReg,r26W);
	register r27(clock,ctrl_reset,en27,data_writeReg,r27W);
	register r28(clock,ctrl_reset,en28,data_writeReg,r28W);
	register r29(clock,ctrl_reset,en29,data_writeReg,r29W);
	register r30(clock,ctrl_reset,en30,data_writeReg,r30W);
	register r31(clock,ctrl_reset,en31,data_writeReg,r31W);

	//feeding output from each register into a tristate w enable
	// = decode result from ctrl_readRegA
	//and routing result into data_readRegA
	tristate tA0(r0W,readRegADecode[0],data_readRegA);
	tristate tA1(r1W,readRegADecode[1],data_readRegA);
	tristate tA2(r2W,readRegADecode[2],data_readRegA);
	tristate tA3(r3W,readRegADecode[3],data_readRegA);
	tristate tA4(r4W,readRegADecode[4],data_readRegA);
	tristate tA5(r5W,readRegADecode[5],data_readRegA);
	tristate tA6(r6W,readRegADecode[6],data_readRegA);
	tristate tA7(r7W,readRegADecode[7],data_readRegA);
	tristate tA8(r8W,readRegADecode[8],data_readRegA);
	tristate tA9(r9W,readRegADecode[9],data_readRegA);
	tristate tA10(r10W,readRegADecode[10],data_readRegA);
	tristate tA11(r11W,readRegADecode[11],data_readRegA);
	tristate tA12(r12W,readRegADecode[12],data_readRegA);
	tristate tA13(r13W,readRegADecode[13],data_readRegA);
	tristate tA14(r14W,readRegADecode[14],data_readRegA);
	tristate tA15(r15W,readRegADecode[15],data_readRegA);
	tristate tA16(r16W,readRegADecode[16],data_readRegA);
	tristate tA17(r17W,readRegADecode[17],data_readRegA);
	tristate tA18(r18W,readRegADecode[18],data_readRegA);
	tristate tA19(r19W,readRegADecode[19],data_readRegA);
	tristate tA20(r20W,readRegADecode[20],data_readRegA);
	tristate tA21(r21W,readRegADecode[21],data_readRegA);
	tristate tA22(r22W,readRegADecode[22],data_readRegA);
	tristate tA23(r23W,readRegADecode[23],data_readRegA);
	tristate tA24(r24W,readRegADecode[24],data_readRegA);
	tristate tA25(r25W,readRegADecode[25],data_readRegA);
	tristate tA26(r26W,readRegADecode[26],data_readRegA);
	tristate tA27(r27W,readRegADecode[27],data_readRegA);
	tristate tA28(r28W,readRegADecode[28],data_readRegA);
	tristate tA29(r29W,readRegADecode[29],data_readRegA);
	tristate tA30(r30W,readRegADecode[30],data_readRegA);
	tristate tA31(r31W,readRegADecode[31],data_readRegA);


	//same thing but for readRegB
	tristate tB0(r0W,readRegBDecode[0],data_readRegB);
	tristate tB1(r1W,readRegBDecode[1],data_readRegB);
	tristate tB2(r2W,readRegBDecode[2],data_readRegB);
	tristate tB3(r3W,readRegBDecode[3],data_readRegB);
	tristate tB4(r4W,readRegBDecode[4],data_readRegB);
	tristate tB5(r5W,readRegBDecode[5],data_readRegB);
	tristate tB6(r6W,readRegBDecode[6],data_readRegB);
	tristate tB7(r7W,readRegBDecode[7],data_readRegB);
	tristate tB8(r8W,readRegBDecode[8],data_readRegB);
	tristate tB9(r9W,readRegBDecode[9],data_readRegB);
	tristate tB10(r10W,readRegBDecode[10],data_readRegB);
	tristate tB11(r11W,readRegBDecode[11],data_readRegB);
	tristate tB12(r12W,readRegBDecode[12],data_readRegB);
	tristate tB13(r13W,readRegBDecode[13],data_readRegB);
	tristate tB14(r14W,readRegBDecode[14],data_readRegB);
	tristate tB15(r15W,readRegBDecode[15],data_readRegB);
	tristate tB16(r16W,readRegBDecode[16],data_readRegB);
	tristate tB17(r17W,readRegBDecode[17],data_readRegB);
	tristate tB18(r18W,readRegBDecode[18],data_readRegB);
	tristate tB19(r19W,readRegBDecode[19],data_readRegB);
	tristate tB20(r20W,readRegBDecode[20],data_readRegB);
	tristate tB21(r21W,readRegBDecode[21],data_readRegB);
	tristate tB22(r22W,readRegBDecode[22],data_readRegB);
	tristate tB23(r23W,readRegBDecode[23],data_readRegB);
	tristate tB24(r24W,readRegBDecode[24],data_readRegB);
	tristate tB25(r25W,readRegBDecode[25],data_readRegB);
	tristate tB26(r26W,readRegBDecode[26],data_readRegB);
	tristate tB27(r27W,readRegBDecode[27],data_readRegB);
	tristate tB28(r28W,readRegBDecode[28],data_readRegB);
	tristate tB29(r29W,readRegBDecode[29],data_readRegB);
	tristate tB30(r30W,readRegBDecode[30],data_readRegB);
	tristate tB31(r31W,readRegBDecode[31],data_readRegB);

endmodule
