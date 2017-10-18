reg sw_event;
always @(SW) begin
  if ((SW[0] + SW[1] + SW[2] + SW[3]
     + SW[4] + SW[5] + SW[6] + SW[7]
     + SW[8] + SW[9]) > 4'd3) sw_event <= 1'b1;
  else sw_event <= 1'b0;
end

reg [2:0] event_sync_reg;
wire synced_event;
assign synced_event = event_sync_reg[1]
                      & ~event_sync_reg[0];

always @(posedge CLK50) begin
  event_sync_reg[2]   <= sw_event;
  event_sync_reg[1:0] <= event_sync_reg[2:1];
end
