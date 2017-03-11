module decoder(
  input [2:0] a,
  input [2:0] b,
  input [2:0] c,
  input [2:0] d,
  input [1:0] s,
  output reg [2:0] y);

always @(a,b,c,d,s) begin
  case (s)
    3'b00:   y <= a;
    3'b01:   y <= b;
    3'b10:   y <= c;
    3'b11:   y <= d;
    default: y <= a;
  endcase;
end;

endmodule;

