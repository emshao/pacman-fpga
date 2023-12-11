`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	input BTNU,
	input BTNL,
	input BTNR,
	input BTND,
	input BTNC,
	output[15:0] LED);
	
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/eys9/Downloads/Memory_Files/";
	

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	// reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    // assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	// always @(posedge clk) begin
	// 	pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	// end
	
	wire clk50; // 25MHz clock

	// reg pixCounter50 = 0;      // Pixel counter to divide the clock
    // assign clk50 = pixCounter50; // Set the clock high whenever the second bit (2) is high
	// always @(posedge clk) begin
	// 	pixCounter50 <= pixCounter50 + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	// end

	clk_wiz_0 pll(.clk50(clk50), .clk25(clk25), .reset(1'b0), .locked(), .clk_in1(clk));

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,    // Standard VGA Width
		VIDEO_HEIGHT = 480,   // Standard VGA Height
		BITS_PER_COLOR = 12;  // Nexys A7 uses 12 bits/color

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	wire [4:0] opcode;
    
    wire showTitle, showPacman, showWin;
	reg[9:0] pacman_x = 310;
	reg[8:0] pacman_y = 230;
	reg[3:0] startGame = 1;
	reg winScreen = 0;
	wire doneCollecting;
	wire [4:0] flag;
	wire allowedBool, allowedBoolL, allowedBoolR, allowedBoolU, allowedBoolD; 	 // boolean allowed to go here or not
	assign LED[0] = allowedBoolL;
	assign LED[1] = showWin;
	assign LED[2] = winScreen;
	assign LED[7:3] = opcode[4:0];
	assign LED[8] = flag[0];
	assign LED[9] = flag[1];
	assign LED[10] = flag[2];
	assign LED[11] = flag[3];
	assign LED[12] = flag[4];
	assign LED[13] = reset;
	assign LED[15:14] = 0;
	
	always @(posedge screenEnd) begin
		if(BTNR && allowedBoolR) begin
			pacman_x <= pacman_x + 1;
		end
		if(BTNL && allowedBoolL) begin
			pacman_x <= pacman_x - 1;
		end
		if(BTND && allowedBoolD) begin
			pacman_y <= pacman_y + 1;
		end
		if(BTNU && allowedBoolU) begin
			pacman_y <= pacman_y - 1;
		end
		if(BTNC) begin
		    startGame <= 0;
		end
	end  
	
	always begin
	   if(doneCollecting) begin
		    winScreen <= 1;
		end
	end
	
	assign showPacman = (pacman_x < x && x < pacman_x + 22 && pacman_y < y && y < pacman_y + 22);
	assign showTitle = (startGame>0);
	assign showWin = winScreen > 0;
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(~reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	   



	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		PALETTE_COLOR_COUNT = 6, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = 3; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
	
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "level-image.mem"})) // Memory initialization
	ImageData(
	    .wEn(1'b0),
		.clk(clk50), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr));				 // Color palette address
    
    VGARAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "level-colors.mem"}))  // Memory initialization
	ColorPalette(
	    .wEn(1'b0),
		.clk(clk50), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData));				       // Color at current pixel
		
		
		
		
		
		
	localparam 
		S_PALETTE_COLOR_COUNT = 4,
		S_PALETTE_ADDRESS_WIDTH = 2;
	wire[S_PALETTE_ADDRESS_WIDTH-1:0] startColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] startColorData; // 12-bit color data at current pixel

	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(S_PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "start-image.mem"})) // Memory initialization
	StartImageData(
	    .wEn(1'b0),
		.clk(clk50), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(startColorAddr));				 // Color palette address
    
    VGARAM #(
		.DEPTH(S_PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(S_PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "start-colors.mem"}))  // Memory initialization
	StartColorPalette(
	    .wEn(1'b0),
		.clk(clk50), 							   	   // Rising edge of the 100 MHz clk
		.addr(startColorAddr),					       // Address from the ImageData RAM
		.dataOut(startColorData));				       // Color at current pixel
	
	
	
	
	
	
	localparam 
		W_PALETTE_COLOR_COUNT = 8,
		W_PALETTE_ADDRESS_WIDTH = 3;
	wire[W_PALETTE_ADDRESS_WIDTH-1:0] winColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] winColorData; // 12-bit color data at current pixel

	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(W_PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "win-image.mem"})) // Memory initialization
	WinImageData(
	    .wEn(1'b0),
		.clk(clk50), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(winColorAddr));				 // Color palette address
    
    VGARAM #(
		.DEPTH(W_PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(W_PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "win-colors.mem"}))  // Memory initialization
	WinColorPalette(
	    .wEn(1'b0),
		.clk(clk50), 							   	   // Rising edge of the 100 MHz clk
		.addr(winColorAddr),					       // Address from the ImageData RAM
		.dataOut(winColorData));				       // Color at current pixel
	




	wire[PIXEL_ADDRESS_WIDTH-1:0] boolAddressL, boolAddressR, boolAddressU, boolAddressD, boolToUseR, boolToUseU, boolToUseD, boolAddress;
	

    assign boolAddressL = (pacman_x-1) + 640*pacman_y;
    assign boolAddressR = (pacman_x+1) + 640*pacman_y;
    assign boolAddressU = pacman_x + 640*(pacman_y-1);
    assign boolAddressD = pacman_x + 640*(pacman_y+1);
   
    



	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(2),      					// Set data width according to boolean
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "boolean-map.mem"})) // Memory initialization
	LAllowBoolData(
	    .wEn(1'b0),
		.clk(clk50), 						 // Falling edge of the 100 MHz clk
		.addr(boolAddressL),					 // Image data address
		.dataOut(allowedBoolL));				 // Allowed to go into this space or not
	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(2),      					// Set data width according to boolean
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "boolean-map.mem"})) // Memory initialization
	RAllowBoolData(
	    .wEn(1'b0),
		.clk(clk50), 						 // Falling edge of the 100 MHz clk
		.addr(boolAddressR),					 // Image data address
		.dataOut(allowedBoolR));				 // Allowed to go into this space or not
	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(2),      					// Set data width according to boolean
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "boolean-map.mem"})) // Memory initialization
	UAllowBoolData(
	    .wEn(1'b0),
		.clk(clk50), 						 // Falling edge of the 100 MHz clk
		.addr(boolAddressU),					 // Image data address
		.dataOut(allowedBoolU));				 // Allowed to go into this space or not
	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(2),      					// Set data width according to boolean
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "boolean-map.mem"})) // Memory initialization
	DAllowBoolData(
	    .wEn(1'b0),
		.clk(clk50), 						 // Falling edge of the 100 MHz clk
		.addr(boolAddressD),					 // Image data address
		.dataOut(allowedBoolD));				 // Allowed to go into this space or not
	
	
	
	
	
	
	
	
	
	
	// ---------- variables for Pacman Sprite to map location to pixel color --------------------------------------
	localparam 
		PACMAN_PIXEL_COUNT = 22*22, 	                                // Number of pixels on the screen
		PACMAN_PIXEL_ADR_WIDTH = $clog2(PACMAN_PIXEL_COUNT) + 1,    // Use built in log2 command
		PACMAN_COLOR_COUNT = 4,
		PACMAN_COLOR_ADR_WIDTH = 3;
		
	wire[PACMAN_PIXEL_ADR_WIDTH-1:0] pacmanImgAddress;  	        // Image address for pacman image data
	wire[PACMAN_COLOR_ADR_WIDTH-1:0] pacmanColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] pacmanColorData; 						// 12-bit color data at current pixel

	assign pacmanImgAddress = (x - pacman_x) + 22*(y - pacman_y);				 // Address calculated coordinate
	
	VGARAM #(
		.DEPTH(PACMAN_PIXEL_COUNT), 				    // Set RAM depth to contain every pixel (22*22)
		.ADDRESS_WIDTH(PACMAN_PIXEL_ADR_WIDTH),   		// Set address width according to the pixel count (log)
		.DATA_WIDTH(PACMAN_COLOR_ADR_WIDTH),      		// Set data width according to the color palette (1)
		.MEMFILE({FILES_PATH, "pacman-image.mem"}))   	// Memory initialization
	PacmanImageData(
	    .wEn(1'b0),
		.clk(clk50), 						 				// Falling edge of the 100 MHz clk
		.addr(pacmanImgAddress),					 	// Image data address
		.dataOut(pacmanColorAddr));				 		// Color palette address

	VGARAM #(	
		.DEPTH(PACMAN_COLOR_COUNT), 		       		// Set depth to contain every color	(2)
		.ADDRESS_WIDTH(PACMAN_COLOR_ADR_WIDTH),     	// Set address width according to the color count (1)
		.DATA_WIDTH(BITS_PER_COLOR), 		       		// Set data width according to the bits per color (12)
		.MEMFILE({FILES_PATH, "pacman-colors.mem"}))  	// Memory initialization
	PacmanColorPalette(
	    .wEn(1'b0),
		.clk(clk50), 							   	   		// Rising edge of the 100 MHz clk
		.addr(pacmanColorAddr),					       	// Address from the PacmanImageData RAM
		.dataOut(pacmanColorData));				       	// Color at current pixel



    
	

    wire outsideBox = y<160 || y>280 || x<250 || x>400;
	wire onCoin = outsideBox && (y>10 && y<470) && (x>10 && x<630) && ((y%56 == 55) || (y%56 == 0) || (y%56 == 1)) && ((x%80 == 26) || (x%80 == 27) || (x%80 == 28));
	wire eightyfiftysix = (x==280) || x==281 || y==220 || y==221;
	

	// Assign to output color from register if active
	reg[BITS_PER_COLOR-1:0] colorOut;
	always @(posedge clk50) begin
	    if (showWin) begin
            colorOut <= winColorData;
	    end
	    else if (showTitle) begin
	        colorOut <= startColorData;
	    end
		else if (showPacman && active) begin
			colorOut <= pacmanColorData;
		end
		else if (eightyfiftysix && active) begin
			colorOut <= 12'hff0;
		end
		else if (active) begin
			colorOut <= colorData;
		end
		else begin
			colorOut <= 12'd0;
		end
	end

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
	
	
	
	
	
	// CPU Information
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut; 
	
	localparam INSTR_FILE = "C:/Users/eys9/Downloads/pacmanCode";
	
	
	// Main Processing Unit
	processor CPU(.clock(clk50), .reset(~reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		
		//MISC
		.isTouchingCoin(flag), .isDoneCollecting(),
        .pacman_x(pacman_x), .pacman_y(pacman_x), .canNotMove(doneCollecting),
        
        .opOUT(opcode)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clk50), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clk50), 
		.ctrl_writeEnable(rwe), .ctrl_reset(~reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	VGARAM #(.DATA_WIDTH(32), .ADDRESS_WIDTH(12), .DEPTH(4096)) ProcMem(.clk(clk50), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));
	
	
	
	
	
endmodule