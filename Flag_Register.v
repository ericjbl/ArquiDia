module FlagRegister(output reg [3:0] Q, input [3:0] D, input Clk, Le);
always@(posedge Clk)
begin
if(Le)
	Q <= D;
else
	Q <= Q;
end
endmodule
