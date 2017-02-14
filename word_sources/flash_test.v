`timescale 1ns / 1ps
//by Evgeniy Liventsev
//National Research University MIET
module flash_test
(
  //module interface
  input        clk,
  input        rst,
  input  [7:0] data_for_flash,
  output [7:0] data_from_flash,
  input [21:0] address,
  input        we,
  input        oe,
  output       ready,

  //flash interface
  inout  [7:0]  flash_data,
  output [21:0] flash_address,
  output        flash_nwe,
  output        flash_nrst,
  output        flash_nce,
  output        flash_noe
);

assign flash_nce  = 1'b0;
assign flash_nrst = 1'b1;

reg [3:0] state;
localparam idle                          = 4'd0;
localparam write_op_set_address_and_data = 4'd1;
localparam read_op_first_stage           = 4'd2;
localparam write_op_pull_down_we         = 4'd3;
localparam wait_for_flash_to_program     = 4'd4;
localparam read_op_set_address           = 4'd5;
localparam read_op_pull_down_oe          = 4'd6;
localparam read_flash_data               = 4'd7;

always @(posedge clk or posedge rst) begin
  if (rst) state <= idle;
  else begin
    case (state)
      idle: if (we) state <= write_op_set_address_and_data;
            else if (oe) state <= read_op_set_address;
      write_op_set_address_and_data: state <= write_op_pull_down_we;
      write_op_pull_down_we: if (write_op_complete) state <= wait_for_flash_to_program; 
                             else if (write_cycle_complete) state <= write_op_set_address_and_data;
      wait_for_flash_to_program: if (flash_programm_is_complete) state <= idle;
      read_op_set_address:  state <= read_op_pull_down_oe;
      read_op_pull_down_oe: if (flash_data_is_ready) state <= read_flash_data;
      read_flash_data: state <= idle;
    endcase
  end
end

reg [2:0] write_cycle_counter;
wire write_op_complete = (write_cycle_counter == 3'd3) & write_cycle_complete;
always @(posedge clk or posedge rst) begin
  if (rst) write_cycle_counter <= 0;
  else begin
    if (state == idle) write_cycle_counter <= 0;
    else if (write_cycle_complete) write_cycle_counter <= write_cycle_counter + 1;
  end
end

reg [2:0] oe_we_pull_down_in_cycles;
wire write_cycle_complete = oe_we_pull_down_in_cycles == 3'd3;
wire flash_data_is_ready = oe_we_pull_down_in_cycles == 3'd3;
always @(posedge clk or posedge rst) begin
  if (rst) oe_we_pull_down_in_cycles <= 0;
  else begin
    if (write_cycle_complete | flash_data_is_ready) oe_we_pull_down_in_cycles <= 0;
    else if ((state == write_op_pull_down_we) | (state == read_op_pull_down_oe))
      oe_we_pull_down_in_cycles <= oe_we_pull_down_in_cycles + 1;
  end
end

reg [15:0] flash_programm_pause_counter;
wire flash_programm_is_complete = flash_programm_pause_counter == 16'd20;
always @(posedge clk or posedge rst) begin
  if (rst) flash_programm_pause_counter <= 0;
  else begin
    if (state == wait_for_flash_to_program) begin
      if (flash_programm_is_complete) flash_programm_pause_counter <= 0;
      else flash_programm_pause_counter <= flash_programm_pause_counter + 1;
    end
  end
end

reg [21:0] flash_address_reg;
always @(posedge clk or posedge rst) begin
  if (rst) flash_address_reg <= 0;
  else if ((state == idle) & we|oe) flash_address_reg <= address;
end

reg [21:0] flash_address_dc;
wire flash_reading = (state == read_op_set_address) |
                     (state == read_op_pull_down_oe) |
                     (state == read_flash_data);
assign flash_address = flash_reading ? flash_address_reg : flash_address_dc;
always @(*) begin
  case (write_cycle_counter)
    3'd0: flash_address_dc <= 22'hAAA;
    3'd1: flash_address_dc <= 22'h555;
    3'd2: flash_address_dc <= 22'hAAA;
    3'd3: flash_address_dc <= flash_address_reg;
    default: flash_address_dc <= 22'd0;
  endcase
end

reg [7:0] data_for_flash_reg;
always @(posedge clk or posedge rst) begin
  if (rst) data_for_flash_reg <= 0;
  else if ((state == idle) & we) data_for_flash_reg <= data_for_flash;
end

reg [7:0] flash_data_dc;
assign flash_data = flash_reading? 8'hzz : flash_data_dc;
always @(*) begin
  case (write_cycle_counter)
    3'd0: flash_data_dc <= 8'hAA;
    3'd1: flash_data_dc <= 8'h55;
    3'd2: flash_data_dc <= 8'hA0;
    3'd3: flash_data_dc <= data_for_flash_reg;
    default: flash_data_dc <= 8'h00;
  endcase
end

reg [7:0] flash_data_reg;
always @(posedge clk or posedge rst) begin
  if (rst) flash_data_reg <= 8'h00;
  else if (state == read_flash_data) flash_data_reg <= flash_data;
end
assign data_from_flash = flash_data_reg;
assign ready = (state == idle);

assign flash_nwe = ~(state == write_op_pull_down_we);
assign flash_noe = ~(state == read_op_pull_down_oe);

endmodule
