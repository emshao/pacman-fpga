`timescale 1 ns/ 100 ps

module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data,
	input BTNU,
	input BTNL,
	input BTNR,
	input BTND);

	reg[9:0] xreg;
	reg[8:0] yreg; 
	wire inSquare;
	wire up, down, left, right;

	assign up = BTNU;
	assign down = BTND;
	assign left = BTNL;
	assign right = BTNR;
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/Emily Shao/Box/on desktop transfer/ECE350/lab6-7_kit/lab6_kit/";

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock

	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
	always @(posedge clk) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
	end


	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;

	initial begin
		assign xreg = 0;
		assign yreg = 0;
	end

	assign inSquare = (x>xreg) & (x<(xreg+50)) & (y>yreg) & (y<(yreg+50));
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
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
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1, // Use built in log2 Command
		PIXEL_COUNT_SPRITE = 4700*50, 
		PIXEL_COUNT_ASCII = 256,
		BITS_PER_SPRITE = 1,
		BITS_PER_ASCII = 7,  
		PIXEL_ADR_SPRITE = $clog2(PIXEL_COUNT_SPRITE) + 1, // 18
		PIXEL_ADR_ASCII = $clog2(PIXEL_COUNT_ASCII) + 1; // 9


	wire key_is_ready;
	reg [7:0] scan_code;
	wire [7:0] rx_data_out;
	wire [6:0] ascii;
	wire spriteAddr;

	RAM #(		
		.DEPTH(PIXEL_COUNT_ASCII), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(BITS_PER_ASCII),      // Set data width according to the sprite
		.ADDRESS_WIDTH(PIXEL_ADR_ASCII),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "ascii.mem"})) // Memory initialization
	AccessASCII(
		.clk(clk), 
		.addr(scan_code),  // scan value, 8-bit
		.dataOut(ascii),  // get out the ascii value, 8-bit
		.wEn(1'b0));

	// map ascii value to sprite value
	always @(posedge(key_is_ready)) begin
		scan_code = rx_data_out;
	end


	wire [9:0] xsquare;
	wire [8:0] ysquare;

	assign xsquare = x - xreg;
	assign ysquare = y - yreg;

	wire [PIXEL_ADR_SPRITE-1:0] mapping;
	assign mapping = (ascii - 1) * 2500 + xsquare + ysquare*50;
	


	RAM #(		
		.DEPTH(PIXEL_COUNT_SPRITE), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(BITS_PER_SPRITE),      					// Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADR_SPRITE),     // 18
		.MEMFILE({FILES_PATH, "sprites.mem"})) // Memory initialization
	AccessSprite(
		.clk(clk), 						 
		.addr(mapping), // input finder, 18-bit
		.dataOut(spriteAddr), // should be outputting boolean, 1-bit
		.wEn(1'b0));
	
	
	PS2Interface ps2(
		.ps2_clk(ps2_clk),
		.clk(clk),
		.ps2_data(ps2_data),
		.rx_data(rx_data_out),
		.read_data(key_is_ready));

	
	always @(posedge screenEnd) begin
		if(right) begin
			xreg <= xreg + 1;
		end
		if(left) begin
			xreg <= xreg - 1;
		end
		if(up) begin
			yreg <= yreg + 1;
		end
		if(down) begin
			yreg <= yreg - 1;
		end
		$display("mapping: %b \n", mapping);
		$display("spriteAddr: %b \n", spriteAddr);
	end  

	

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "imageMine.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
	wire[BITS_PER_COLOR-1:0] squareData = 12'hfff; // 12-bit color data for the square at current pixel
	

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colorsMine.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] beforeSquare; 		// Output color 
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color if active

	mux_4_12b colorChooser(.out(beforeSquare), .select({inSquare, spriteAddr}), .in0(colorData), .in1(12'h444), .in2(squareData), .in3(12'h000));

	// Assign to output color from register if active
	// assign beforeSquare = (inSquare & spriteAddr) ? squareData : colorData;
	assign colorOut = active ? beforeSquare : 12'hfff; // When not active, output black

	// Quickly assign the output colors to their channels using concatenation
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
endmodule