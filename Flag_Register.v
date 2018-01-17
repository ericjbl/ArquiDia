module TestFR;

//Inputs
reg C,N,V,Z, Clk, Le;

//Outputs
wire[3:0] Q;

FlagRegister myFR(Q, {C, N, V, Z}, Clk, Le);

initial begin
        Clk = 1'b0;
        forever #5 Clk = ~Clk;
end

initial fork
	Le =1'b1;
	C = 1'b1;
	N = 1'b1;
	V = 1'b0;
	Z = 1'b1;
join

initial begin
	#10 C = 1'b0;
	#15 V = 1'b1;
end

initial begin
        $display("Q	C N V Z		Time");
        $monitor("%b	%b %b %b %b	%d", Q, C, N, V, Z, $time);
end

endmodule


module FlagRegister(output reg [3:0] Q, input [3:0] D, input Clk, Le);
always@(posedge Clk)
begin
if(Le)
	Q <= D;
else
	Q <= Q;
end
endmodule
