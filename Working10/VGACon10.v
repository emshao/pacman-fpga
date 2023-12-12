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
	input BTNC);
	
	
	// Lab Memory Files Location
	localparam FILES_PATH = "Memory/";
	


	wire clk25;    // 25MHz clock
	wire clkCPU;   // 25MHz clock
	wire clk10;    // 10Mhz active
	wire clkGhost;

	clk_wiz_0 pll(.clk25CPU(clkCPU), .clk25(clk25), .clk10(clk10), .reset(1'b0), .locked(), .clk_in1(clk));
	
	reg[18:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clkGhost = pixCounter[18]; // Set the clock high whenever the 20th bit is high
	always @(posedge clk10) begin
		pixCounter <= pixCounter + 1; // Since the reg is 20 bits, it will reset every 2^20 cycles
	end	

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,    // Standard VGA Width
		VIDEO_HEIGHT = 480,   // Standard VGA Height
		BITS_PER_COLOR = 12;  // Nexys A7 uses 12 bits/color

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
    
    wire showTitle, showPacman, showGhost;

	reg[9:0] pacman_x = 310;
	reg[8:0] pacman_y = 230;
	reg[9:0] ghost_x = 310;
	reg[8:0] ghost_y = 300;
	

	reg[3:0] startGame = 1;
	reg winScreen = 1'b0;
	reg lossScreen = 1'b0;
	wire doneCollecting;
	wire lostGame;
	wire allowedBoolL, allowedBoolR, allowedBoolU, allowedBoolD; 	 // boolean allowed to go here or not
	wire [31:0] r6V;


    // ---------- variables for Pacman Sprite to map location to pixel color --------------------------------------
	localparam 
		PACMAN_PIXEL_COUNT = 22*22, 	                                // Number of pixels on the screen
		PACMAN_PIXEL_ADR_WIDTH = $clog2(PACMAN_PIXEL_COUNT) + 1,    // Use built in log2 command
		PACMAN_COLOR_COUNT = 4,
		PACMAN_COLOR_ADR_WIDTH = 3;
		
	wire[PACMAN_PIXEL_ADR_WIDTH-1:0] pacmanImgAddress;  	        // Image address for pacman image data
	wire[PACMAN_COLOR_ADR_WIDTH-1:0] pacmanColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] pacmanColorData; 						// 12-bit color data at current pixel
	
	wire[PACMAN_COLOR_ADR_WIDTH-1:0] pacmanUpColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] pacmanUpColorData; 						// 12-bit color data at current pixel
	wire[PACMAN_COLOR_ADR_WIDTH-1:0] pacmanLeftColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] pacmanLeftColorData; 						// 12-bit color data at current pixel
	wire[PACMAN_COLOR_ADR_WIDTH-1:0] pacmanDownColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] pacmanDownColorData; 						// 12-bit color data at current active
	
	wire[PACMAN_PIXEL_ADR_WIDTH-1:0] ghostImgAddress;  	        // Image address for ghost image data
	wire[PACMAN_COLOR_ADR_WIDTH-1:0] ghostColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] ghostColorData;

    //reg[BITS_PER_COLOR-1:0] lastPacman;
    //initial begin
	//    lastPacman <= pacmanColorData;
    //end
	
	always @(posedge screenEnd) begin
		if(BTNR && allowedBoolR) begin
			pacman_x <= pacman_x + 1;
			//lastPacman <= pacmanColorData;
		end
		if(BTNL && allowedBoolL) begin
			pacman_x <= pacman_x - 1;
			//lastPacman <= pacmanLeftColorData;
		end
		if(BTND && allowedBoolD) begin
			pacman_y <= pacman_y + 1;
			//lastPacman <= pacmanDownColorData;
		end
		if(BTNU && allowedBoolU) begin
			pacman_y <= pacman_y - 1;
			//lastPacman <= pacmanUpColorData;
		end
		if(BTNC) begin
		    startGame <= 0;
		end

	end 
	
	reg touchedRight;
	always @(posedge clk10) begin
        if (ghost_x >= 397) begin
            touchedRight <= 1'b1;
        end
        if (ghost_x <= 217) begin
            touchedRight <= 1'b0;
        end
    end
	
	always @(posedge clkGhost) begin
	    if(touchedRight) begin
	       ghost_x <= ghost_x - 1;
        end
        else begin
            ghost_x = ghost_x + 1;
        end
	end
	
	always @(posedge clkCPU) begin
	   if(doneCollecting) begin
		    winScreen <= 1'b1;
	   end
	   
	end
	always @(posedge clkCPU) begin
	   if(lostGame) begin
		    lossScreen <= 1'b1;
	   end
	   
	end
	
	assign showPacman = (pacman_x < x && x < pacman_x + 22 && pacman_y < y && y < pacman_y + 22);
	assign showGhost = (ghost_x < x && x < ghost_x + 22 && ghost_y < y && y < ghost_y + 22);
	assign showTitle = (startGame>0);
	
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
		.clk(clk25), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr));				 // Color palette address
    
    VGARAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "level-colors.mem"}))  // Memory initialization
	ColorPalette(
	    .wEn(1'b0),
		.clk(clk25), 							   	   // Rising edge of the 100 MHz clk
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
		.clk(clk25), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(startColorAddr));				 // Color palette address
    
    VGARAM #(
		.DEPTH(S_PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(S_PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "start-colors.mem"}))  // Memory initialization
	StartColorPalette(
	    .wEn(1'b0),
		.clk(clk25), 							   	   // Rising edge of the 100 MHz clk
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
		.clk(clk25), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(winColorAddr));				 // Color palette address
    
    VGARAM #(
		.DEPTH(W_PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(W_PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "win-colors.mem"}))  // Memory initialization
	WinColorPalette(
	    .wEn(1'b0),
		.clk(clk25), 							   	   // Rising edge of the 100 MHz clk
		.addr(winColorAddr),					       // Address from the ImageData RAM
		.dataOut(winColorData));				       // Color at current pixel
	




	wire[PIXEL_ADDRESS_WIDTH-1:0] boolAddressL, boolAddressR, boolAddressU, boolAddressD;
	
    assign boolAddressL = (pacman_x-1) + 640*pacman_y;
    assign boolAddressR = (pacman_x+1) + 640*pacman_y;
    assign boolAddressU = pacman_x + 640*(pacman_y-1);
    assign boolAddressD = pacman_x + 640*(pacman_y+1);
   
    // Boolean map for where pacman is allowed to go
	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(2),      					// Set data width according to boolean
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "boolean-map.mem"})) // Memory initialization
	LAllowBoolData(
	    .wEn(1'b0),
		.clk(clk25), 						 // Falling edge of the 100 MHz clk
		.addr(boolAddressL),					 // Image data address
		.dataOut(allowedBoolL));				 // Allowed to go into this space or not
	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(2),      					// Set data width according to boolean
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "boolean-map.mem"})) // Memory initialization
	RAllowBoolData(
	    .wEn(1'b0),
		.clk(clk25), 						 // Falling edge of the 100 MHz clk
		.addr(boolAddressR),					 // Image data address
		.dataOut(allowedBoolR));				 // Allowed to go into this space or not
	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(2),      					// Set data width according to boolean
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "boolean-map.mem"})) // Memory initialization
	UAllowBoolData(
	    .wEn(1'b0),
		.clk(clk25), 						 // Falling edge of the 100 MHz clk
		.addr(boolAddressU),					 // Image data address
		.dataOut(allowedBoolU));				 // Allowed to go into this space or not
	VGARAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(2),      					// Set data width according to boolean
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "boolean-map.mem"})) // Memory initialization
	DAllowBoolData(
	    .wEn(1'b0),
		.clk(clk25), 						 // Falling edge of the 100 MHz clk
		.addr(boolAddressD),					 // Image data address
		.dataOut(allowedBoolD));				 // Allowed to go into this space or not
	
	
	
	assign pacmanImgAddress = (x - pacman_x) + 22*(y - pacman_y);				 // Address calculated coordinate
	assign ghostImgAddress = (x - ghost_x) + 22*(y - ghost_y);
	
	//normal (right)
	VGARAM #(
		.DEPTH(PACMAN_PIXEL_COUNT), 				    // Set RAM depth to contain every pixel (22*22)
		.ADDRESS_WIDTH(PACMAN_PIXEL_ADR_WIDTH),   		// Set address width according to the pixel count (log)
		.DATA_WIDTH(PACMAN_COLOR_ADR_WIDTH),      		// Set data width according to the color palette (1)
		.MEMFILE({FILES_PATH, "pacman-image.mem"}))   	// Memory initialization
	PacmanImageData(
	    .wEn(1'b0),
		.clk(clk25), 						 				// Falling edge of the 100 MHz clk
		.addr(pacmanImgAddress),					 	// Image data address
		.dataOut(pacmanColorAddr));				 		// Color palette address

	VGARAM #(	
		.DEPTH(PACMAN_COLOR_COUNT), 		       		// Set depth to contain every color	(2)
		.ADDRESS_WIDTH(PACMAN_COLOR_ADR_WIDTH),     	// Set address width according to the color count (1)
		.DATA_WIDTH(BITS_PER_COLOR), 		       		// Set data width according to the bits per color (12)
		.MEMFILE({FILES_PATH, "pacman-colors.mem"}))  	// Memory initialization
	PacmanColorPalette(
	    .wEn(1'b0),
		.clk(clk25), 							   	   		// Rising edge of the 100 MHz clk
		.addr(pacmanColorAddr),					       	// Address from the PacmanImageData RAM
		.dataOut(pacmanColorData));				       	// Color at current pixel
		
	//up
	VGARAM #(
		.DEPTH(PACMAN_PIXEL_COUNT), 				    // Set RAM depth to contain every pixel (22*22)
		.ADDRESS_WIDTH(PACMAN_PIXEL_ADR_WIDTH),   		// Set address width according to the pixel count (log)
		.DATA_WIDTH(PACMAN_COLOR_ADR_WIDTH),      		// Set data width according to the color palette (1)
		.MEMFILE({FILES_PATH, "pacman-up.mem"}))   	// Memory initialization
	PacmanImageDataUp(
	    .wEn(1'b0),
		.clk(clk25), 						 				// Falling edge of the 100 MHz clk
		.addr(pacmanImgAddress),					 	// Image data address
		.dataOut(pacmanUpColorAddr));				 		// Color palette address

	VGARAM #(	
		.DEPTH(PACMAN_COLOR_COUNT), 		       		// Set depth to contain every color	(2)
		.ADDRESS_WIDTH(PACMAN_COLOR_ADR_WIDTH),     	// Set address width according to the color count (1)
		.DATA_WIDTH(BITS_PER_COLOR), 		       		// Set data width according to the bits per color (12)
		.MEMFILE({FILES_PATH, "pacman-colors.mem"}))  	// Memory initialization
	PacmanColorPaletteUp(
	    .wEn(1'b0),
		.clk(clk25), 							   	   		// Rising edge of the 100 MHz clk
		.addr(pacmanUpColorAddr),					       	// Address from the PacmanImageData RAM
		.dataOut(pacmanUpColorData));				       	// Color at current pixel
	
	//left
	VGARAM #(
		.DEPTH(PACMAN_PIXEL_COUNT), 				    // Set RAM depth to contain every pixel (22*22)
		.ADDRESS_WIDTH(PACMAN_PIXEL_ADR_WIDTH),   		// Set address width according to the pixel count (log)
		.DATA_WIDTH(PACMAN_COLOR_ADR_WIDTH),      		// Set data width according to the color palette (1)
		.MEMFILE({FILES_PATH, "pacman-left.mem"}))   	// Memory initialization
	PacmanImageDataLeft(
	    .wEn(1'b0),
		.clk(clk25), 						 				// Falling edge of the 100 MHz clk
		.addr(pacmanImgAddress),					 	// Image data address
		.dataOut(pacmanLeftColorAddr));				 		// Color palette address

	VGARAM #(	
		.DEPTH(PACMAN_COLOR_COUNT), 		       		// Set depth to contain every color	(2)
		.ADDRESS_WIDTH(PACMAN_COLOR_ADR_WIDTH),     	// Set address width according to the color count (1)
		.DATA_WIDTH(BITS_PER_COLOR), 		       		// Set data width according to the bits per color (12)
		.MEMFILE({FILES_PATH, "pacman-colors.mem"}))  	// Memory initialization
	PacmanColorPaletteLeft(
	    .wEn(1'b0),
		.clk(clk25), 							   	   		// Rising edge of the 100 MHz clk
		.addr(pacmanLeftColorAddr),					       	// Address from the PacmanImageData RAM
		.dataOut(pacmanLeftColorData));				       	// Color at current pixel
	
	//down
	VGARAM #(
		.DEPTH(PACMAN_PIXEL_COUNT), 				    // Set RAM depth to contain every pixel (22*22)
		.ADDRESS_WIDTH(PACMAN_PIXEL_ADR_WIDTH),   		// Set address width according to the pixel count (log)
		.DATA_WIDTH(PACMAN_COLOR_ADR_WIDTH),      		// Set data width according to the color palette (1)
		.MEMFILE({FILES_PATH, "pacman-down.mem"}))   	// Memory initialization
	GhostImageData(
	    .wEn(1'b0),
		.clk(clk25), 						 				// Falling edge of the 100 MHz clk
		.addr(pacmanImgAddress),					 	// Image data address
		.dataOut(pacmanDownColorAddr));				 		// Color palette address

	VGARAM #(	
		.DEPTH(PACMAN_COLOR_COUNT), 		       		// Set depth to contain every color	(2)
		.ADDRESS_WIDTH(PACMAN_COLOR_ADR_WIDTH),     	// Set address width according to the color count (1)
		.DATA_WIDTH(BITS_PER_COLOR), 		       		// Set data width according to the bits per color (12)
		.MEMFILE({FILES_PATH, "pacman-colors.mem"}))  	// Memory initialization
	GhostColorPalette(
	    .wEn(1'b0),
		.clk(clk25), 							   	   		// Rising edge of the 100 MHz clk
		.addr(pacmanDownColorAddr),					       	// Address from the PacmanImageData RAM
		.dataOut(pacmanDownColorData));				       	// Color at current pixel
		
	//ghost
	VGARAM #(
		.DEPTH(PACMAN_PIXEL_COUNT), 				    // Set RAM depth to contain every pixel (22*22)
		.ADDRESS_WIDTH(PACMAN_PIXEL_ADR_WIDTH),   		// Set address width according to the pixel count (log)
		.DATA_WIDTH(PACMAN_COLOR_ADR_WIDTH),      		// Set data width according to the color palette (1)
		.MEMFILE({FILES_PATH, "ghost-image.mem"}))   	// Memory initialization
	PacmanImageDataDown(
	    .wEn(1'b0),
		.clk(clk25), 						 				// Falling edge of the 100 MHz clk
		.addr(ghostImgAddress),					 	// Image data address
		.dataOut(ghostColorAddr));				 		// Color palette address

	VGARAM #(	
		.DEPTH(PACMAN_COLOR_COUNT), 		       		// Set depth to contain every color	(2)
		.ADDRESS_WIDTH(PACMAN_COLOR_ADR_WIDTH),     	// Set address width according to the color count (1)
		.DATA_WIDTH(BITS_PER_COLOR), 		       		// Set data width according to the bits per color (12)
		.MEMFILE({FILES_PATH, "ghost-colors.mem"}))  	// Memory initialization
	PacmanColorPaletteDown(
	    .wEn(1'b0),
		.clk(clk25), 							   	   		// Rising edge of the 100 MHz clk
		.addr(ghostColorAddr),					       	// Address from the PacmanImageData RAM
		.dataOut(ghostColorData));				       	// Color at current pixel


    // ADD TO LIST WITH MORE COINS
//    reg [19:0] notTouchedReg = 20'b11111111111111111111;
    reg [19:0] notTouchedReg = 20'b00000000001111111111;
    always @(posedge clk25) begin
        if(touchingCoins[0]) begin
            notTouchedReg[0] <= 1'b0;
        end
	end
	always @(posedge clk25) begin
        if(touchingCoins[1]) begin
            notTouchedReg[1] <= 1'b0;
        end
	end
	always @(posedge clk25) begin
        if(touchingCoins[2]) begin
            notTouchedReg[2] <= 1'b0;
        end
	end
	always @(posedge clk25) begin
        if(touchingCoins[3]) begin
            notTouchedReg[3] <= 1'b0;
        end
	end
	always @(posedge clk25) begin
        if(touchingCoins[4]) begin
            notTouchedReg[4] <= 1'b0;
        end
	end
	always @(posedge clk25) begin
        if(touchingCoins[5]) begin
            notTouchedReg[5] <= 1'b0;
        end
	end
	always @(posedge clk25) begin
        if(touchingCoins[6]) begin
            notTouchedReg[6] <= 1'b0;
        end
	end
	always @(posedge clk25) begin
        if(touchingCoins[7]) begin
            notTouchedReg[7] <= 1'b0;
        end
	end
	always @(posedge clk25) begin
        if(touchingCoins[8]) begin
            notTouchedReg[8] <= 1'b0;
        end
	end
	always @(posedge clk25) begin
        if(touchingCoins[9]) begin
            notTouchedReg[9] <= 1'b0;
        end
	end

//        if(touchingCoins[10]) begin
//            notTouchedReg[10] <= 1'b0;
//        end
//    end
//    always @(posedge clk25) begin
//        if(touchingCoins[11]) begin
//            notTouchedReg[11] <= 1'b0;
//        end
//    end
//    always @(posedge clk25) begin
//        if(touchingCoins[12]) begin
//            notTouchedReg[12] <= 1'b0;
//        end
//    end
//    always @(posedge clk25) begin
//        if(touchingCoins[13]) begin
//            notTouchedReg[13] <= 1'b0;
//        end
//    end
//    always @(posedge clk25) begin
//        if(touchingCoins[14]) begin
//            notTouchedReg[14] <= 1'b0;
//        end
//    end
//    always @(posedge clk25) begin
//        if(touchingCoins[15]) begin
//            notTouchedReg[15] <= 1'b0;
//        end
//    end
//    always @(posedge clk25) begin
//        if(touchingCoins[16]) begin
//            notTouchedReg[16] <= 1'b0;
//        end
//    end
//    always @(posedge clk25) begin
//        if(touchingCoins[17]) begin
//            notTouchedReg[17] <= 1'b0;
//        end
//    end
//    always @(posedge clk25) begin
//        if(touchingCoins[18]) begin
//            notTouchedReg[18] <= 1'b0;
//        end
//    end
//    always @(posedge clk25) begin
//        if(touchingCoins[19]) begin
//            notTouchedReg[19] <= 1'b0;
//        end
//    end
    
	
	
	// ADD TO LIST WITH MORE COINS 
	wire [19:0] coins;
	assign coins[0] = (((x==150) || x==151 || x==152) && (y==196 || y==197 || y==198));
	assign coins[1] = (((x==503) || x==504 || x==505) && (y==369 || y==370 || y==371));
	assign coins[2] = (((x==236) || x==237 || x==238) && (y==369 || y==370 || y==371));
	assign coins[3] = (((x==85) || x==86 || x==87) && (y==369 || y==370 || y==371));
	assign coins[4] = (((x==85) || x==86 || x==87) && (y==448 || y==449 || y==450));
//	assign coins[5] = (((x==503) || x==504 || x==505) && (y==448 || y==449 || y==450));
	assign coins[5] = (((x==529) || x==530 || x==531) && (y==196 || y==197 || y==198));
	assign coins[6] = (((x==585) || x==586 || x==587) && (y==332 || y==333 || y==334));
	assign coins[7] = (((x==529) || x==530 || x==531) && (y==53 || y==54 || y==55));
	assign coins[8] = (((x==434) || x==435 || x==436) && (y==196 || y==197 || y==195));
	assign coins[9] = (((x==434) || x==435 || x==436) && (y==284 || y==285 || y==286));
	assign coins[10] = (((x==434) || x==435 || x==436) && (y==369 || y==370 || y==371));
	assign coins[11] = (((x==335) || x==336 || x==337) && (y==369 || y==370 || y==371));
	assign coins[12] = (((x==484) || x==485 || x==486) && (y==90 || y==91 || y==92));
	assign coins[13] = (((x==232) || x==233 || x==234) && (y==53 || y==54 || y==55));
	assign coins[14] = (((x==85) || x==86 || x==87) && (y==53 || y==54 || y==55));
	assign coins[15] = (((x==85) || x==86 || x==87) && (y==284 || y==285 || y==286));
	assign coins[16] = (((x==335) || x==336 || x==337) && (y==53 || y==54 || y==55));
	assign coins[17] = (((x==115) || x==116 || x==117) && (y==84 || y==85 || y==86));
	assign coins[18] = (((x==112) || x==113 || x==114) && (y==404 || y==405 || y==406));
	assign coins[19] = (((x==112) || x==113 || x==114) && (y==404 || y==405 || y==406));
	
	

	// Assign to output color from register if active
	reg[BITS_PER_COLOR-1:0] colorOut;
	
	always @(posedge clk25) begin
	    if (winScreen) begin
            colorOut <= winColorData;
	    end
	    else if (lossScreen) begin
	        colorOut <= winColorData;
	    end
	    else if (showTitle) begin
	        colorOut <= startColorData;
	    end
		else if (showPacman && active) begin
		    if(BTNU) begin
		        colorOut <= pacmanUpColorData;
		    end
		    else if(BTND) begin
		        colorOut <= pacmanDownColorData;
		    end
		    else if(BTNL) begin
		        colorOut <= pacmanLeftColorData;
		    end
		    else begin
		        colorOut <= pacmanColorData;
		    end
		    //colorOut <= lastPacman;
		end
		else if (showGhost && active) begin
		    colorOut <= ghostColorData;
		end
		else if (active && ((coins[0] && notTouchedReg[0]) || (coins[1] && notTouchedReg[1]) || (coins[2] && notTouchedReg[2]) || (coins[3] && notTouchedReg[3]) || (coins[4] && notTouchedReg[4]) || (coins[5] && notTouchedReg[5]) || (coins[6] && notTouchedReg[6]) || (coins[7] && notTouchedReg[7]) || (coins[8] && notTouchedReg[8]) || (coins[9] && notTouchedReg[9]) || (coins[10] && notTouchedReg[10]) || (coins[11] && notTouchedReg[11]) || (coins[12] && notTouchedReg[12]) || (coins[13] && notTouchedReg[13]) || (coins[14] && notTouchedReg[14]) || (coins[15] && notTouchedReg[15]) || (coins[16] && notTouchedReg[16]) || (coins[17] && notTouchedReg[17]) || (coins[18] && notTouchedReg[18]) || (coins[19] && notTouchedReg[19]))) begin
			colorOut <= 12'hff0;
		end
		else if (active) begin
			colorOut <= colorData;
		end
		else begin
			colorOut <= 12'd0;
		end
	end
	// Assign the output colors to their channels
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
	
	
	
	
	
	// CPU Information
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut; 
	wire[4:0] touchingCoins;
	
	localparam INSTR_FILE = "C:/Users/eys9/Downloads/pacmanCoinLoopGhost";
	
	
	// Main Processing Unit
	processor CPU(.clock(clkCPU), .reset(~reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// REGFILE
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		
		// PACMAN
		.isTouchingCoin(touchingCoins), .isDoneCollecting(),
        .pacman_x(pacman_x), .pacman_y(pacman_y), .canNotMove(doneCollecting),
        .ghost_x(ghost_x), .ghost_y(ghost_y),.lost(lostGame),
        
        .opOUT()); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clkCPU), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
		
	
	// Register File
	regfile RegisterFile(.clock(clkCPU), 
		.ctrl_writeEnable(rwe), .ctrl_reset(~reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),.reg6Val(r6V));
	
	
	// Processor Memory (RAM)
	VGARAM #(.DATA_WIDTH(32), .ADDRESS_WIDTH(12), .DEPTH(4096)) ProcMem(.clk(clkCPU), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));
	
endmodule