`include "RAM.v"
`include "Register_Windows.v"
`include "Condition_Tester.v"
`include "Flag_Register.v"
`include "Shifter_And_SignExtender.v"

module DataPath(output reg [31:0] wIROut, output reg MOC, BCOND, TCOND, input[1:0] type,);

	wire[31:0] wALUOut, wDataOut, wMAROut, wMDROut, wPCOut, wNPCOut, wShifterOut, wAddShifterOut, wAddNPCOut, wAddSumNPCOut,
		wMuxMOut, wMuxPOut, wMuxNPOut, wIROut, wWIMOut, wPortA, wPortB, wMuxAOut, wMuxBOut, wMuxCOut,
		wMuxSaOut, wMuxScOut, wMuxOPOut, wMuxFOut;

	wire[28:0] wTBROut;
	wire[27:0] wPSROut;
	wire[3:0] wTTROut;
	wire[3:0] wFROut;
	wire TCond;
	supply0 Gnd;

	ALU SPARC_ALU(wALUOut, ); //TODO
	RamAccess SPARC_RAM(wDataOut, MOC, MOV, RW, wMAROut[8:0], wMDROut, type);
	Register_Windows SPARC_Register_Windows(wPortA, wPortB, wALUOut, ); //TODO


	Condition_Tester SPARC_Condition_Tester(); //TODO
	Shifter_And_Sign_Extender SPARC_Shifter(wShifterOut, wIROut);

//*********************************
//	DataPath Registers
//*********************************
	Register_32Bits MAR(wMAROut, wALUOut, Clk, Gnd, MAR_Ld);
	Register_32Bits MDR(wMDROut, wMuxMOut, Clk, Gnd, MDR_Ld);


	Register_32Bits IR(wIROut, wDataOut, Clk, Gnd, IR_Ld);
	Register_32Bits PC(wPCOut, wMuxPOut, Clk, Gnd, PC_Ld);


	Register_32Bits NPC(wNPCOut, wMuxNPOut, Clk, nPC_Clr, NPC_Ld);
	and(wWIM_Ld, WIM_Ld, wPSROut[7]);
	Register_32Bits WIM(wWIMOut, wALUOut, Clk, Gnd, wWIM_Ld);


	and(wTBR_Ld, TBR_Ld, wPSROut[7]);
	Register_29Bits TBR(wTBROut, {wALUOut[31:7], wALUOut[3:0]}, Clk, Gnd, wTBR_Ld);
	Register_4Bits TTR(wTTROut, wALUOut[6:4], CLk, Gnd, TTR_Ld);

	and(wPSR_TCond, PSR_Ld, wTCond);
	and(wPSR_Sup, PSR_Ld, wPSROut[7]);
	or(wPSR_Ld, wPSR_TCond, wPSR_Sup);
	Register_28Bits PSR(wPSROut, wALUOut, Clk, Gnd, wPSR_Ld);

	FlagRegister FR(wFROut, {}, Clk, FR_Ld); //TODO


//*********************************
//	Adders
//*********************************
	32Bit_Adder AddShifter(wAddShifterOut, wPCOut, wShifterOut);
	32Bit_Adder AddNPC(wAddNPCOut, 32'h00000004, wNPCOut);
	32Bit_Adder AddSumNPC(wAddSumNPCOut, 32'h00000004, wAddNPCOut);


//*********************************
//	DataPath Multiplexers
//*********************************
	Mux32_4x1 MuxA(wMuxAOut, wPortA, {wPSROut[31:24], wFROut, wPSROut[19:0]}, wWIMOut, {wTBROut[28:4], wTTROut, wTBROut[3:0]}, MA); 
	Mux32_4x1 MuxB(wMuxBOut, wPortB, wShifterOut, wMuxCOut, wMDROut, MB); 


	Mux32_2x1 MuxC(wMuxCOut, wPCOut, wNPCOut, MC);
	Mux32_2x1 MuxM(wMuxMOut, wDataOut,  wALUOut, MM);


	Mux32_4x1 MuxNP(wMuxNPOut, wALUOut, wAddSumNPCOut, wAddShifterOut, wAddNPCOut, MNP);
	Mux32_4x1 MuxP(wMuxPOut, 32'h00000000, {wTBROut[28:4], wTTROut, wTBROut[3:0]}, wAddNPCOut, wNPCOut);
	Mux5_2x1 MuxSa(wMuxSaOut, wIROut[18:14], wIROut[29:25], MSa); 


	Mux5_4x1 MuxSc(wMuxScOut, wIROut[29:25], 5'h0F, 5'h11, 5'h12);
	Mux6_2x1 MuxOP(wMuxOPOut, wIROut[24:19], OpXX, MOP);
	Mux4_2x1 MuxF(wMuxFOut, , wALUOut[23:20], MF); //TODO

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

module Mux6_2x1(output reg [5:0] Out, input [5:0] A, B, input S);
always@(S,A,B)
begin
        if(S)
                Out = B;
        else
                Out = A;
end
endmodule


module Mux5_4x1(output reg [4:0] Out, input [4:0] A, B, C, D, input [1:0] S);
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


module Mux5_2x1(output reg [4:0] Out, input [4:0] A, B, input S);
always@(S,A,B)
begin
        if(S)
                Out = B;
        else
                Out = A;
end
endmodule


module Mux4_2x1(output reg [3:0] Out, input [3:0] A, B, input S);
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


module Register_29Bits(output reg [28:0] Q, input [28:0] D, input Clk, Clr, Le);
always@(posedge Clk, Clr) //Reminder: Possible Change to Clr in negedge
begin
if(Clr)
        Q <= 29'h00000000;
else if(Le)
        Q <= D;
else
        Q <= Q;
end
endmodule


module Register_28Bits(output reg [27:0] Q, input [27:0] D, input Clk, Clr, Le);
always@(posedge Clk, Clr) //Reminder: Possible Change to Clr in negedge
begin
if(Clr)
        Q <= 28'h0000000;
else if(Le)
        Q <= D;
else
        Q <= Q;
end
endmodule


module Register_4Bits(output reg [3:0] Q, input [3:0] D, input Clk, Clr, Le);
always@(posedge Clk, Clr) //Reminder: Possible Change to Clr in negedge
begin
if(Clr)
        Q <= 4'h0;
else if(Le)
        Q <= D;
else
        Q <= Q;
end
endmodule



//*******************************
//	Adders
//*******************************
module 32Bit_Adder(output [31:0] S, input [31:0] A, B);
	assign {Cout,S} = A + B;
endmodule
