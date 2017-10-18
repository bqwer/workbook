module flash_controller
( //module interface
  input        clk,
  input  [7:0] data_for_flash,
  output [7:0] data_from_flash,
  input [21:0] address,
  input        we,
  input        oe,
  input        erase,
  output       error,
  output       ready,

  //flash interface
  inout  [7:0]  flash_data,
  output [21:0] flash_address,
  output        flash_nwe,
  output        flash_nrst,
  output        flash_nce,
  output        flash_noe );
endmodule