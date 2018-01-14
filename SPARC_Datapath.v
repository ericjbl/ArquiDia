module DataPath(output reg [31:0] Instruction, output reg MOC, BCOND, TCOND, input);

	wire[31:0] PortC;

	ALU SPARC_ALU(PortC, );
	RAM SPARC_RAM();
	Register_Windows SPARC_Register_Windows();


//*********************************
//	DataPath Registers
//*********************************
	Register_32Bits MAR();
	Register_32Bits MDR();
	Register_32Bits IR();
	Register_32Bits PC();

	Register_32Bits NPC();
	Register_32Bits WIM();
	Register_32Bits TBR();
	Register_32Bits PSR();
	FlagRegister FR();


//*********************************
//	Adders
//*********************************
	32Bit_Adder AddShifter();
	32Bit_Adder AddNPC();
	32Bit_Adder AddSumNPC();


//*********************************
//	DataPath Multiplexers
//*********************************
	Mux32_4x1 MuxA();
	Mux32_4x1 MuxB();
	Mux32_2x1 MuxC();
	Mux32_2x1 MuxM();

	Mux32_4x1 MuxNP();
	Mux32_4x1 MuxP();
	Mux5_2x1 MuxSa();
	Mux6_2x1 MuxOP();
	Mux32_2x1 MuxS();

endmodule




//********************************
//	Multiplexer Modules
//********************************
module Mux32_2x1(output reg [31:0] Out, input [31:0] A, B, input S);
always@(S,A,B)
begin
        if(S)
                Out = B;
        else
                Out = A;
end
endmodule


module Mux32_4x1(output reg [31:0] Out, input [31:0] A, B, C, D, input [1:0] S);
always@(S,A,B,C,D)
begin
        case(S)
        2'b00:
                Out = A;
        2'b01:
                Out = B;
        2'b10:
                Out = C;
        2'b11:
                Out = D;
        endcase
end
endmodule


module Mux32_8x1(output [31:0] Out, input [31:0] In0, In1, In2, In3, In4, In5, In6, In7,
                input [2:0] S);
        wire [31:0] w1, w2;

        Mux32_4x1 MuxA(w1, In0, In1, In2, In3, S[1:0]);
        Mux32_4x1 MuxB(w2, In4, In5, In6, In7, S[1:0]);
        Mux32_2x1 MuxC(Out, w1, w2, S[2]);

endmodule


module Mux32_32x1(output [31:0] Out, input [31:0] In0, In1, In2, In3,
        In4, In5, In6, In7, In8, In9, In10, In11, In12, In13, In14, In15, In16,
        In17, In18, In19, In20, In21, In22, In23, In24, In25, In26, In27, In28,
        In29, In30, In31, input [4:0] S);

        wire [31:0] w1, w2, w3, w4;

        Mux32_8x1 MuxA(w1, In0, In1, In2, In3, In4, In5, In6, In7, S[2:0]);
        Mux32_8x1 MuxB(w2, In8, In9, In10, In11, In12, In13, In14, In15, S[2:0]);
        Mux32_8x1 MuxC(w3, In16, In17, In18, In19, In20, In21, In22, In23, S[2:0]);
        Mux32_8x1 MuxD(w4, In24, In25, In26, In27, In28, In29, In30, In31, S[2:0]);

        Mux32_4x1 MuxE(Out, w1, w2, w3, w4, S[4:3]);

endmodule


module Mux5_2x1(output reg [4:0] Out, input [4:0] A, B, input S);
always@(S,A,B)
begin
        if(S)
                Out = B;
        else
                Out = A;
end
endmodule


module Mux6_2x1(output reg [5:0] Out, input [5:0] A, B, input S);
always@(S,A,B)
begin
        if(S)
                Out = B;
        else
                Out = A;
end
endmodule


//*****************************
//	Decoder Modules
//*****************************
module Decoder_5x32(output reg [31:0] Eout, input [4:0] Ein, input Ld);
always@(Ein)
	if(!Ld)
		Eout = 0;
	else
		case(Ein)
		5'b00000: Eout = 32'h00000001;
		5'b00001: Eout = 32'h00000002;
		5'b00010: Eout = 32'h00000004;
		5'b00011: Eout = 32'h00000008;

		5'b00100: Eout = 32'h00000010;
                5'b00101: Eout = 32'h00000020;
                5'b00110: Eout = 32'h00000040;
                5'b00111: Eout = 32'h00000080;

		5'b01000: Eout = 32'h00000100;
                5'b01001: Eout = 32'h00000200;
                5'b01010: Eout = 32'h00000400;
                5'b01011: Eout = 32'h00000800;

                5'b01100: Eout = 32'h00001000;
                5'b01101: Eout = 32'h00002000;
                5'b01110: Eout = 32'h00004000;
                5'b01111: Eout = 32'h00008000;

		5'b10000: Eout = 32'h00010000;
                5'b10001: Eout = 32'h00020000;
                5'b10010: Eout = 32'h00040000;
                5'b10011: Eout = 32'h00080000;

                5'b10100: Eout = 32'h00100000;
                5'b10101: Eout = 32'h00200000;
                5'b10110: Eout = 32'h00400000;
                5'b10111: Eout = 32'h00800000;

                5'b11000: Eout = 32'h01000000;
                5'b11001: Eout = 32'h02000000;
                5'b11010: Eout = 32'h04000000;
                5'b11011: Eout = 32'h08000000;

                5'b11100: Eout = 32'h10000000;
                5'b11101: Eout = 32'h20000000;
                5'b11110: Eout = 32'h40000000;
                5'b11111: Eout = 32'h80000000;
	
		endcase
endmodule


module Decoder_2x4(output reg [3:0] Eout, input [1:0] Ein, input Ld);
always@(Ein)
        if(!Ld)
                Eout = 0;
        else
                case(Ein)
		
		2'b00:
			Eout = 4'b0001; 
		2'b01:
			Eout = 4'b0010;
		2'b10:
			Eout = 4'b0100;
		2'b11:
			Eout = 4'b1000;
		endcase
endmodule


//*****************************
//	Register Modules
//*****************************
module Register_32Bits(output reg [31:0] Q, input [31:0] D, input Clk, Clr, Le);
always@(posedge Clk, Clr) //Reminder: Possible Change to Clr in negedge
begin
if(Clr)
        Q <= 32'h00000000;
else if(Le)
        Q <= D;
else
        Q <= Q;
end
endmodule


//*******************************
//	Adders
//*******************************
module 32Bit_Adder(output [31:0] S, output Cout, input [31:0] A, B, input Cin);
	assign {Cout,S} = A + B + Cin;
endmodule
