reg [3:0] main_state;

localparam idle = 4'd0;
localparam r    = 4'd1;
localparam w1   = 4'd2;
localparam w2   = 4'd3;
localparam w3   = 4'd4;
localparam w4   = 4'd5;
localparam e1   = 4'd6;
localparam e2   = 4'd7;
localparam e3   = 4'd8;
localparam e4   = 4'd9;
localparam e5   = 4'd10;
localparam e6   = 4'd11;
localparam rs   = 4'd12;
localparam st   = 4'd13;
localparam err  = 4'd14;

wire r_done, w_done;
wire wire status_ok;
wire error;

always @(posedge clk or posedge rst) begin
  if (rst) main_state <= idle;
  else begin
    case (main_state)
      idle: if (we)         main_state <= w1;
            else if (oe)    main_state <= r;
            else if (erase) main_state <= e1;

      w1: if (w_done) main_state <= w2;
      w2: if (w_done) main_state <= w3;
      w3: if (w_done) main_state <= w4;
      w4: if (w_done) main_state <= st;

      e1: if (w_done) main_state <= e2;
      e2: if (w_done) main_state <= e3;
      e3: if (w_done) main_state <= e4;
      e4: if (w_done) main_state <= e5;
      e5: if (w_done) main_state <= e6;
      e6: if (w_done) main_state <= st;

      r:  if (r_done) main_state <= idle;
      rs: if (r_done) main_state <= st;
      st: begin
            if (status_ok)  main_state <= idle;
            else if (error) main_state <= err;
            else            main_state <= rs;
          end

      err: main_state <= idle;
    endcase
  end
end

reg [7:0] w_data;
always @(posedge clk or posedge rst) begin
  if (rst) w_data <= 8'h00;
  else begin
    if ( main_stat == idle) begin
      if ( we )    w_data <= data_for_flash;
      if ( erase ) w_data <= 8'hFF;
    end
  end
end