`timescale 1ns / 1ps

module flash_test_top(
	input CLOCK_50,
	input [9:0] SW,
	input [3:0] KEY,
	output [6:0] HEX0,
	output [6:0] HEX1,	
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [9:0] LEDR,


	output [21:0] FL_ADDR,
	inout [7:0] FL_DQ,
	output FL_OE_N,
	output FL_RST_N,
	output FL_WE_N
	);


 wire rst;
 wire we;
 wire oe;
	debounce d0(.clk(CLOCK_50),
				.inp(KEY[0]),
				.outp(rst));

	debounce d1(.clk(CLOCK_50),
				.inp(KEY[1]),
				.outp(we));

	debounce d2(.clk(CLOCK_50),
				.inp(KEY[2]),
				.outp(oe));



wire [7:0] data_from_flash;

	hex_decoder(.data(SW[3:0]),
				.led(HEX0));

	hex_decoder(.data(SW[7:4]),
				.led(HEX1));


	hex_decoder(.data(data_from_flash[3:0]),
				.led(HEX2));

	hex_decoder(.data(data_from_flash[7:4]),
				.led(HEX3));

wire [21:0] address;
assign address = {19'h1B000,SW[9:8]};

wire [7:0] data_for_flash;
assign data_for_flash = SW[7:0];

wire ready;
assign LEDR[0] = ready;

flash_test
(
  //module interface
  .clk(CLOCK_50),
  .rst(rst),
  .data_for_flash(data_for_flash),
  .data_from_flash(data_from_flash),
  .address(address),
  .we(we),
  .oe(oe),
  .ready(ready),

  //flash interface
  .flash_data(FL_DQ),
  .flash_address(FL_ADDR),
  .flash_nwe(FL_WE_N),
  .flash_nrst(FL_RST_N),
  .flash_nce(),
  .flash_noe(FL_OE_N)
);

endmodule

module debounce(input  clk,
				input  inp,
				output outp);
                
  reg [2:0] sync_reg;

  always @(posedge clk) begin
      sync_reg[0] <= inp;
      sync_reg[1] <= sync_reg[0];
      sync_reg[2] <= sync_reg[1];
  end

  assign outp = ~sync_reg[2] & sync_reg[1];

endmodule

module hex_decoder(input [3:0] data,
					output reg [6:0] led);

always @*
	case (data)
		4'b0000 :      	//Hexadecimal 0
			led = 7'b1000000;
		4'b0001 :    	//Hexadecimal 1
			led = 7'b1111001  ;
		4'b0010 :  		// Hexadecimal 2
			led = 7'b0100100 ; 
		4'b0011 : 		// Hexadecimal 3
			led = 7'b0110000 ;
		4'b0100 :		// Hexadecimal 4
			led = 7'b0011001 ;
		4'b0101 :		// Hexadecimal 5
			led = 7'b0010010 ;  
		4'b0110 :		// Hexadecimal 6
			led = 7'b0000010 ;
		4'b0111 :		// Hexadecimal 7
			led = 7'b1111000;
		4'b1000 :     	//Hexadecimal 8
			led = 7'b0000000;
		4'b1001 :    	//Hexadecimal 9
			led = 7'b0010000 ;
		4'b1010 :  		// Hexadecimal A
			led = 7'b0001000 ; 
		4'b1011 : 		// Hexadecimal B
			led = 7'b0000011;
		4'b1100 :		// Hexadecimal C
			led = 7'b1000110 ;
		4'b1101 :		// Hexadecimal D
			led = 7'b0100001 ;
		4'b1110 :		// Hexadecimal E
			led = 7'b0000110 ;
		4'b1111 :		// Hexadecimal F
			led = 7'b0001110 ;
	endcase

endmodule