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
	localparam FILES_PATH = "C:/Users/Emily Shao/Desktop/lab6_kit/Memory_Files/";
	

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end

	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,    // Standard VGA Width
		VIDEO_HEIGHT = 480,   // Standard VGA Height
		BITS_PER_COLOR = 12;  // Nexys A7 uses 12 bits/color

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
    
    wire showTitle, showPacman, showWin;
	reg[9:0] pacman_x = 310;
	reg[8:0] pacman_y = 230;
	reg startGame = 1'b1;
	
	always @(posedge screenEnd) begin
		if(BTNR) begin
			pacman_x <= pacman_x + 1;
		end
		if(BTNL) begin
			pacman_x <= pacman_x - 1;
		end
		if(BTND) begin
			pacman_y <= pacman_y + 1;
		end
		if(BTNU) begin
			pacman_y <= pacman_y - 1;
		end
		if(BTNC) begin
		    startGame <= 0;
		end
	end  
	
	assign showPacman = (pacman_x < x && x < pacman_x + 22 && pacman_y < y && y < pacman_y + 22);
	assign showTitle = (startGame>0);
	assign showWin = (startGame<-3);
	
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

	VGAROM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "level-image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr));				 // Color palette address
    
    VGAROM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "level-colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData));				       // Color at current pixel
		
	localparam 
		S_PALETTE_COLOR_COUNT = 4,
		S_PALETTE_ADDRESS_WIDTH = 2;
	wire[S_PALETTE_ADDRESS_WIDTH-1:0] startColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] startColorData; // 12-bit color data at current pixel

	VGAROM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(S_PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "start-image.mem"})) // Memory initialization
	StartImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(startColorAddr));				 // Color palette address
    
    VGAROM #(
		.DEPTH(S_PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(S_PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "start-colors.mem"}))  // Memory initialization
	StartColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(startColorAddr),					       // Address from the ImageData RAM
		.dataOut(startColorData));				       // Color at current pixel
	
	localparam 
		W_PALETTE_COLOR_COUNT = 8,
		W_PALETTE_ADDRESS_WIDTH = 3;
	wire[W_PALETTE_ADDRESS_WIDTH-1:0] winColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] winColorData; // 12-bit color data at current pixel

	VGAROM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(W_PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "win-image.mem"})) // Memory initialization
	WinImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(winColorAddr));				 // Color palette address
    
    VGAROM #(
		.DEPTH(W_PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(W_PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "win-colors.mem"}))  // Memory initialization
	WinColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(winColorAddr),					       // Address from the ImageData RAM
		.dataOut(winColorData));				       // Color at current pixel
	
	
	
	// ---------- variables for Pacman Sprite to map location to pixel color --------------------------------------
	localparam 
		PACMAN_PIXEL_COUNT = 22*22, 	                                // Number of pixels on the screen
		PACMAN_PIXEL_ADR_WIDTH = $clog2(PACMAN_PIXEL_COUNT) + 1,    // Use built in log2 command
		PACMAN_COLOR_COUNT = 2,
		PACMAN_COLOR_ADR_WIDTH = 1;
		
	wire[PACMAN_PIXEL_ADR_WIDTH-1:0] pacmanImgAddress;  	        // Image address for pacman image data
	wire[PACMAN_COLOR_ADR_WIDTH-1:0] pacmanColorAddr; 	 // Color address for the color palette
	wire[BITS_PER_COLOR-1:0] pacmanColorData; 						// 12-bit color data at current pixel

	assign pacmanImgAddress = (x-pacman_x) + 22*(y - pacman_y);				 // Address calculated coordinate
	
	// ROM for pixels within Pacman Sprite
	VGAROM #(
		.DEPTH(PACMAN_PIXEL_COUNT), 				    // Set RAM depth to contain every pixel (22*22)
		.ADDRESS_WIDTH(PACMAN_PIXEL_ADR_WIDTH),   		// Set address width according to the pixel count (log)
		.DATA_WIDTH(PACMAN_COLOR_ADR_WIDTH),      		// Set data width according to the color palette (1)
		.MEMFILE({FILES_PATH, "pacman-image.mem"}))   	// Memory initialization
	PacmanImageData(
		.clk(clk), 						 				// Falling edge of the 100 MHz clk
		.addr(pacmanImgAddress),					 	// Image data address
		.dataOut(pacmanColorAddr));				 		// Color palette address

	// ROM for colors within Pacman Sprite
	VGAROM #(	
		.DEPTH(PACMAN_COLOR_COUNT), 		       		// Set depth to contain every color	(2)
		.ADDRESS_WIDTH(PACMAN_COLOR_ADR_WIDTH),     	// Set address width according to the color count (1)
		.DATA_WIDTH(BITS_PER_COLOR), 		       		// Set data width according to the bits per color (12)
		.MEMFILE({FILES_PATH, "pacman-colors.mem"}))  	// Memory initialization
	PacmanColorPalette(
		.clk(clk), 							   	   		// Rising edge of the 100 MHz clk
		.addr(pacmanColorAddr),					       	// Address from the PacmanImageData RAM
		.dataOut(pacmanColorData));				       	// Color at current pixel
// ------------------------------------------------------------------------------------------------------------	
	
	wire onCoin = (y>10 && y<470) && (x>10 && x<630) && (y<170 || y>250) && (x<250 || x>400) && ((y%28 == 27) || (y%28 == 0) || (y%28 == 1)) && ((x%50 == 24)||(x%50 == 25)||(x%50 == 26));

	// Assign to output color from register if active
	reg[BITS_PER_COLOR-1:0] colorOut;
	always @(posedge clk) begin
	    if (showTitle) begin
	        colorOut <= startColorData;
	    end
		else if (showPacman && active) begin
			colorOut <= pacmanColorData;
		end
		else if (onCoin && active) begin
			colorOut <= 112'hff0;
		end
		else if (active) begin
			colorOut <= colorData;
		end
		else if (showWin) begin
            colorOut <= winColorData;
	    end
		else begin
			colorOut <= 12'd0;
		end
	end

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
endmodule