reg [2:0] read_state;
localparam rr1     = 3'd0;
localparam rr2     = 3'd1;
localparam rr3     = 3'd2;
localparam rr4     = 3'd3;

always @(posedge clk or posedge rst) begin
  if (rst) read_state <= r_idle;
  else begin
    case (read_state) begin
      rr1: if (start_rea) state <= rr2;
      rr2: state <= rr3;
      rr3: state <= rr4;
      rr4: state <= rr1;
    endcase
  end
end

assign r_done   = (read_state == rr4);
wire read_nce   = (read_state == rr1);
wire read_noe   = ((read_state == rr1) |
                   (read_state == rr2));
wire read_nwe   = 1'b1;
wire start_read = (main_state == r) |
                  (main_state == rs);

reg [7:0] r_data;
always @(posedge clk or posedge rst) begin
  if (rst)         r_data <= 8'h00;
  else if (r_done) r_data <= flash_data;
end