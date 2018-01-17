/*
  TestBench for Register Windows Module
*/
module Test_Register_Windows;

//Inputs
reg [31:0] PortC;
reg [4:0] Sa, Sb, Load_Select, Clear_Select;
reg [1:0] Cwp;
reg RF_Load_Enable, RF_Clear_Enable, Register_Windows_Enable, Clk;

//Outputs
wire [31:0] PortA, PortB;

parameter sim_time = 5000;

Register_Windows myRW(PortA, PortB, PortC, Sa, Sb, Load_Select, Clear_Select, Cwp,
			RF_Load_Enable, RF_Clear_Enable, Register_Windows_Enable, Clk);

initial #sim_time $finish;

//Clock Setup
initial begin
        Clk = 1'b0;
        forever #5 Clk = ~Clk;
end



//Set default initial values as desired
initial fork

	RF_Load_Enable <= 1'b1;
	RF_Clear_Enable <= 1'b0;
	Register_Windows_Enable <= 1'b1;
	Cwp <= 2'b11;	//Begin at Window 3
	
	Load_Select <= 5'b00000;
	Clear_Select <= 5'b00000;

        PortC <= 32'h00000000;

	Sa <= 5'b00000;
	Sb <= 5'b00000;	

join


/*Uncomment this block to test Global Registers (R0 - R7)
initial begin     
	repeat(7)begin
		 #10 PortC = PortC + 32'h00000001;
		  Load_Select = Load_Select + 5'b00001;
		  Sa = Sa + 5'b00001;
		  Sb = Sb + 5'b00001;
	end
end      
*/



/*Uncomment to test overlapping register values within a Register Set
initial begin

	//Current Example: Set24 { R24_W3, R8_W2, R32_W1, R48_W0 }
	Load_Select <= 5'b01100;
	Sa <= 5'b01100;
	Sb <= 5'b01100;

	repeat(4) begin
		#10 PortC = PortC + 32'h00000001;
		Cwp = Cwp + 2'b01; //Window Order 3, 0, 1, 2
	end
	
	RF_Load_Enable = 1'b0; //Disable Loading in order to see the different outputs
	Register_Windows_Enable = 1'b0;

	repeat(4) #10 Cwp = Cwp + 2'b01;
end
*/



///*Tests all (4) windows sequentially and loop around (Round Robin) (A lot of Output!!!)
initial begin
	repeat(5) begin
		 Load_Select <= 5'b01000;
       		 PortC <= 32'h00000008;

       		 Sa <= 5'b01000;
       		 Sb <= 5'b01000; 
		repeat(24) begin
			#10 PortC = PortC + 32'h00000001;
			Load_Select = Load_Select + 5'b00001;
			Sa = Sa + 5'b00001;
			Sb = Sb + 5'b00001;
		end
		Cwp = Cwp - 2'b01; //Window Order 3, 2, 1, 0
	end

	// NOTE: Crowded output, but Round Robin functionality and 
	// preserved register values are succesfully shown here.
	
end
//*/




/*
 * The display statements used for PortA and PortB were separated
 * to reduce the amount of output that prints on onscreen.
*/

///*Display block used for PortA Debugging
initial begin
        $display("PortC          Load_Select    Cwp    Sa		PortA			Time");
        $monitor("%h       %b          %b     %b      %h	 %d ", PortC, Load_Select, Cwp, Sa, PortA, $time);
end
//*/



/*Display block used for PortB Debugging
initial begin
        $display("PortC          Load_Select   Cwp     Sb       	 PortB                   Time");
        $monitor("%h       %b          %b     %b      %h         %d ", PortC, Load_Select, Cwp, Sb, PortB, $time);
end
*/

endmodule






/*
	Module for a Register Windows implementation based on
	SPARC Architecture. Designed as Phase 1 of course Project
	for ICOM4215 Computer Architecture class.

	@author Johnny R. Sanchez Marrero
*/
module Register_Windows(output [31:0] PortA, PortB, input [31:0] PortC, input [4:0] Sa, Sb, Load_Select,
		Clear_Select, input [1:0] Cwp, input RF_Load_Enable, RF_Clear_Enable, Register_Windows_Enable, Clk);

	//Decoder Outputs
	wire [31:0] Load_Enable_Decoder_Out, Register_Clear_Decoder_Out;
        wire [3:0]  Current_Window_Decoder_Out;


	//Global Register Outputs (R0 - R7)
	wire [31:0] wR0_Out, wR1_Out, wR2_Out, wR3_Out, wR4_Out, wR5_Out, wR6_Out, wR7_Out;


	//Windowed Register Outputs (R8 - R31)
	wire [31:0] wR8_Out, wR9_Out, wR10_Out, wR11_Out, wR12_Out, wR13_Out, wR14_Out, wR15_Out, wR16_Out,
			wR17_Out, wR18_Out, wR19_Out, wR20_Out, wR21_Out, wR22_Out, wR23_Out, wR24_Out, wR25_Out,
			wR26_Out, wR27_Out, wR28_Out, wR29_Out, wR30_Out, wR31_Out;

	//Windowed Register Outputs (R32 - R55)
	wire [31:0] wR32_Out, wR33_Out, wR34_Out, wR35_Out, wR36_Out, wR37_Out, wR38_Out, wR39_Out, wR40_Out,
                        wR41_Out, wR42_Out, wR43_Out, wR44_Out, wR45_Out, wR46_Out, wR47_Out, wR48_Out, wR49_Out,
                        wR50_Out, wR51_Out, wR52_Out, wR53_Out, wR54_Out, wR55_Out;

	//Windowed Register Outputs (R56 - R33)
	wire [31:0] wR56_Out, wR57_Out, wR58_Out, wR59_Out, wR60_Out, wR61_Out, wR62_Out, wR63_Out, wR64_Out,
                        wR65_Out, wR66_Out, wR67_Out, wR68_Out, wR69_Out, wR70_Out, wR71_Out;


	//Outputs for each Register Set (Total of 24 Register Sets, Set_R8 - Set_R31)
	wire [31:0] Set_R8_Out, Set_R9_Out, Set_R10_Out, Set_R11_Out, Set_R12_Out, Set_R13_Out, Set_R14_Out,
			 Set_R15_Out, Set_R16_Out, Set_R17_Out, Set_R18_Out, Set_R19_Out, Set_R20_Out, Set_R21_Out,
			 Set_R22_Out, Set_R23_Out, Set_R24_Out, Set_R25_Out, Set_R26_Out, Set_R27_Out, Set_R28_Out,
			 Set_R29_Out, Set_R30_Out, Set_R31_Out;


//*******************************
//	Decoders
//*******************************

	/*
	 * Load_Enable_Decoder:
	 *
	 * Selects which Register will be allowed
	 * to store the value coming in from PortC.
	 */
	Decoder_5x32 Load_Enable_Decoder(Load_Enable_Decoder_Out, Load_Select, RF_Load_Enable);

        /*
         * Register_Clear_Decoder:
         *
         * Selects which Register will be cleared
         * to zero (0).
         */
	Decoder_5x32 Register_Clear_Decoder(Register_Clear_Decoder_Out, Clear_Select, RF_Clear_Enable);


        /*
         * Current_Window_Decoder:
         *
         * Indicates the currently "open" window
	 * based on input from the Current Window Pointer.
         */

	Decoder_2x4 Current_Window_Decoder(Current_Window_Decoder_Out, Cwp, Register_Windows_Enable);

//*******************************


//*******************************
//	Multiplexers
//*******************************
	
	/*
	 * For each register set within the Register Window, there is a
	 * Mux_4x1 that groups these registers and "hides" or "reveals"
	 * them based on the Current Window Pointer (Cwp), which is used
	 * as the select lines for each Mux_4x1. Consult the Block Diagram
	 * for visual aid.
	 *
	 */


	//Muxes for Sets R8 - R11
	Mux32_4x1 Set_R8_Mux(Set_R8_Out, wR24_Out, wR48_Out, wR32_Out, wR8_Out, Cwp);
        Mux32_4x1 Set_R9_Mux(Set_R9_Out, wR25_Out, wR49_Out, wR33_Out, wR9_Out, Cwp);
        Mux32_4x1 Set_R10_Mux(Set_R10_Out, wR26_Out, wR50_Out, wR34_Out, wR10_Out, Cwp);
        Mux32_4x1 Set_R11_Mux(Set_R11_Out, wR27_Out, wR51_Out, wR35_Out, wR11_Out, Cwp);


	//Muxes for Sets R12-R15
        Mux32_4x1 Set_R12_Mux(Set_R12_Out, wR28_Out, wR52_Out, wR36_Out, wR12_Out, Cwp);
        Mux32_4x1 Set_R13_Mux(Set_R13_Out, wR29_Out, wR53_Out, wR37_Out, wR13_Out, Cwp);
        Mux32_4x1 Set_R14_Mux(Set_R14_Out, wR30_Out, wR54_Out, wR38_Out, wR14_Out, Cwp);
        Mux32_4x1 Set_R15_Mux(Set_R15_Out, wR31_Out, wR55_Out, wR39_Out, wR15_Out, Cwp);


	//Muxes for Sets R16-R19
        Mux32_4x1 Set_R16_Mux(Set_R16_Out, wR64_Out, wR56_Out, wR40_Out, wR16_Out, Cwp);
        Mux32_4x1 Set_R17_Mux(Set_R17_Out, wR65_Out, wR57_Out, wR41_Out, wR17_Out, Cwp);
        Mux32_4x1 Set_R18_Mux(Set_R18_Out, wR66_Out, wR58_Out, wR42_Out, wR18_Out, Cwp);
        Mux32_4x1 Set_R19_Mux(Set_R19_Out, wR67_Out, wR59_Out, wR43_Out, wR19_Out, Cwp);


	//Muxes for Sets R20-R23
        Mux32_4x1 Set_R20_Mux(Set_R20_Out, wR68_Out, wR60_Out, wR44_Out, wR20_Out, Cwp);
        Mux32_4x1 Set_R21_Mux(Set_R21_Out, wR69_Out, wR61_Out, wR45_Out, wR21_Out, Cwp);
        Mux32_4x1 Set_R22_Mux(Set_R22_Out, wR70_Out, wR62_Out, wR46_Out, wR22_Out, Cwp);
        Mux32_4x1 Set_R23_Mux(Set_R23_Out, wR71_Out, wR63_Out, wR47_Out, wR23_Out, Cwp);


	//Muxes for Sets R24-R27
        Mux32_4x1 Set_R24_Mux(Set_R24_Out, wR48_Out, wR32_Out, wR8_Out, wR24_Out, Cwp);
        Mux32_4x1 Set_R25_Mux(Set_R25_Out, wR49_Out, wR33_Out, wR9_Out, wR25_Out, Cwp);
        Mux32_4x1 Set_R26_Mux(Set_R26_Out, wR50_Out, wR34_Out, wR10_Out, wR26_Out, Cwp);
        Mux32_4x1 Set_R27_Mux(Set_R27_Out, wR51_Out, wR35_Out, wR11_Out, wR27_Out, Cwp);


	//Muxes for Sets R28-R31
        Mux32_4x1 Set_R28_Mux(Set_R28_Out, wR52_Out, wR36_Out, wR12_Out, wR28_Out, Cwp);
        Mux32_4x1 Set_R29_Mux(Set_R29_Out, wR53_Out, wR37_Out, wR13_Out, wR29_Out, Cwp);
        Mux32_4x1 Set_R30_Mux(Set_R30_Out, wR54_Out, wR38_Out, wR14_Out, wR30_Out, Cwp);
        Mux32_4x1 Set_R31_Mux(Set_R31_Out, wR55_Out, wR39_Out, wR15_Out, wR31_Out, Cwp);


	/*
	 	Multiplexers for Output Ports A and B
	*/
	Mux32_32x1 PortA_Mux(PortA, wR0_Out, wR1_Out, wR2_Out, wR3_Out, wR4_Out, wR5_Out, wR6_Out, wR7_Out,
				Set_R8_Out, Set_R9_Out, Set_R10_Out, Set_R11_Out, Set_R12_Out, Set_R13_Out,
				Set_R14_Out, Set_R15_Out, Set_R16_Out, Set_R17_Out, Set_R18_Out, Set_R19_Out,
				Set_R20_Out, Set_R21_Out, Set_R22_Out, Set_R23_Out, Set_R24_Out, Set_R25_Out,
				Set_R26_Out, Set_R27_Out, Set_R28_Out, Set_R29_Out, Set_R30_Out, Set_R31_Out, Sa);



        Mux32_32x1 PortB_Mux(PortB, wR0_Out, wR1_Out, wR2_Out, wR3_Out, wR4_Out, wR5_Out, wR6_Out, wR7_Out,
                                Set_R8_Out, Set_R9_Out, Set_R10_Out, Set_R11_Out, Set_R12_Out, Set_R13_Out,
                                Set_R14_Out, Set_R15_Out, Set_R16_Out, Set_R17_Out, Set_R18_Out, Set_R19_Out,
                                Set_R20_Out, Set_R21_Out, Set_R22_Out, Set_R23_Out, Set_R24_Out, Set_R25_Out,
                                Set_R26_Out, Set_R27_Out, Set_R28_Out, Set_R29_Out, Set_R30_Out, Set_R31_Out, Sb);



//*******************************


//*******************************
//	Global Registers
//*******************************

	//R0-R3
	Register_32Bits R0(wR0_Out, PortC, Clk, Register_Clear_Decoder_Out[0], Load_Enable_Decoder_Out[0]);
	Register_32Bits R1(wR1_Out, PortC, Clk, Register_Clear_Decoder_Out[1], Load_Enable_Decoder_Out[1]);
	Register_32Bits R2(wR2_Out, PortC, Clk, Register_Clear_Decoder_Out[2], Load_Enable_Decoder_Out[2]);
	Register_32Bits R3(wR3_Out, PortC, Clk, Register_Clear_Decoder_Out[3], Load_Enable_Decoder_Out[3]);


	//R4-R7
	Register_32Bits R4(wR4_Out, PortC, Clk, Register_Clear_Decoder_Out[4], Load_Enable_Decoder_Out[4]);
        Register_32Bits R5(wR5_Out, PortC, Clk, Register_Clear_Decoder_Out[5], Load_Enable_Decoder_Out[5]);
        Register_32Bits R6(wR6_Out, PortC, Clk, Register_Clear_Decoder_Out[6], Load_Enable_Decoder_Out[6]);
        Register_32Bits R7(wR7_Out, PortC, Clk, Register_Clear_Decoder_Out[7], Load_Enable_Decoder_Out[7]);


//******************************

//******************************
//	Windowed Registers
//******************************


//---------------------------------
//---Outs-Window-3-/-Ins-Window-2--
//---------------------------------

	and(En8_W3, Load_Enable_Decoder_Out[8], Current_Window_Decoder_Out[3]);
	and(En24_W2, Load_Enable_Decoder_Out[24], Current_Window_Decoder_Out[2]);
	or(wR8_Ld_In, En8_W3, En24_W2);

        and(Clr8_W3, Register_Clear_Decoder_Out[8], Current_Window_Decoder_Out[3]);
  	and(Clr24_W2, Register_Clear_Decoder_Out[24], Current_Window_Decoder_Out[2]);
	or(wR8_Clr_In, Clr8_W3, Clr24_W2);

	Register_32Bits R8(wR8_Out, PortC, Clk, wR8_Clr_In, wR8_Ld_In);




        and(En9_W3, Load_Enable_Decoder_Out[9], Current_Window_Decoder_Out[3]);
        and(En25_W2, Load_Enable_Decoder_Out[25], Current_Window_Decoder_Out[2]);
        or(wR9_Ld_In, En9_W3, En25_W2);

        and(Clr9_W3, Register_Clear_Decoder_Out[9], Current_Window_Decoder_Out[3]);
        and(Clr25_W2, Register_Clear_Decoder_Out[25], Current_Window_Decoder_Out[2]);
        or(wR9_Clr_In, Clr9_W3, Clr25_W2);

        Register_32Bits R9(wR9_Out, PortC, Clk, wR9_Clr_In, wR9_Ld_In);




        and(En10_W3, Load_Enable_Decoder_Out[10], Current_Window_Decoder_Out[3]);
        and(En26_W2, Load_Enable_Decoder_Out[26], Current_Window_Decoder_Out[2]);
        or(wR10_Ld_In, En10_W3, En26_W2);

        and(Clr10_W3, Register_Clear_Decoder_Out[10], Current_Window_Decoder_Out[3]);
        and(Clr26_W2, Register_Clear_Decoder_Out[26], Current_Window_Decoder_Out[2]);
        or(wR10_Clr_In, Clr10_W3, Clr26_W2);

        Register_32Bits R10(wR10_Out, PortC, Clk, wR10_Clr_In, wR10_Ld_In);




        and(En11_W3, Load_Enable_Decoder_Out[11], Current_Window_Decoder_Out[3]);
        and(En27_W2, Load_Enable_Decoder_Out[27], Current_Window_Decoder_Out[2]);
        or(wR11_Ld_In, En11_W3, En27_W2);

        and(Clr11_W3, Register_Clear_Decoder_Out[11], Current_Window_Decoder_Out[3]);
        and(Clr27_W2, Register_Clear_Decoder_Out[27], Current_Window_Decoder_Out[2]);
        or(wR11_Clr_In, Clr11_W3, Clr27_W2);

        Register_32Bits R11(wR11_Out, PortC, Clk, wR11_Clr_In, wR11_Ld_In);




        and(En12_W3, Load_Enable_Decoder_Out[12], Current_Window_Decoder_Out[3]);
        and(En28_W2, Load_Enable_Decoder_Out[28], Current_Window_Decoder_Out[2]);
        or(wR12_Ld_In, En12_W3, En28_W2);

        and(Clr12_W3, Register_Clear_Decoder_Out[12], Current_Window_Decoder_Out[3]);
        and(Clr28_W2, Register_Clear_Decoder_Out[28], Current_Window_Decoder_Out[2]);
        or(wR12_Clr_In, Clr12_W3, Clr28_W2);

        Register_32Bits R12(wR12_Out, PortC, Clk, wR12_Clr_In, wR12_Ld_In);




        and(En13_W3, Load_Enable_Decoder_Out[13], Current_Window_Decoder_Out[3]);
        and(En29_W2, Load_Enable_Decoder_Out[29], Current_Window_Decoder_Out[2]);
        or(wR13_Ld_In, En13_W3, En29_W2);

        and(Clr13_W3, Register_Clear_Decoder_Out[13], Current_Window_Decoder_Out[3]);
        and(Clr29_W2, Register_Clear_Decoder_Out[29], Current_Window_Decoder_Out[2]);
        or(wR13_Clr_In, Clr13_W3, Clr29_W2);

        Register_32Bits R13(wR13_Out, PortC, Clk, wR13_Clr_In, wR13_Ld_In);




        and(En14_W3, Load_Enable_Decoder_Out[14], Current_Window_Decoder_Out[3]);
        and(En30_W2, Load_Enable_Decoder_Out[30], Current_Window_Decoder_Out[2]);
        or(wR14_Ld_In, En14_W3, En30_W2);

        and(Clr14_W3, Register_Clear_Decoder_Out[14], Current_Window_Decoder_Out[3]);
        and(Clr30_W2, Register_Clear_Decoder_Out[30], Current_Window_Decoder_Out[2]);
        or(wR14_Clr_In, Clr14_W3, Clr30_W2);

        Register_32Bits R14(wR14_Out, PortC, Clk, wR14_Clr_In, wR14_Ld_In);




        and(En15_W3, Load_Enable_Decoder_Out[15], Current_Window_Decoder_Out[3]);
        and(En31_W2, Load_Enable_Decoder_Out[31], Current_Window_Decoder_Out[2]);
        or(wR15_Ld_In, En15_W3, En31_W2);

        and(Clr15_W3, Register_Clear_Decoder_Out[15], Current_Window_Decoder_Out[3]);
        and(Clr31_W2, Register_Clear_Decoder_Out[31], Current_Window_Decoder_Out[2]);
        or(wR15_Clr_In, Clr15_W3, Clr31_W2);

        Register_32Bits R15(wR15_Out, PortC, Clk, wR15_Clr_In, wR15_Ld_In);


//------------------------------
//---Local-Registers-Window 3---
//------------------------------
        and(wR16_Ld_In, Load_Enable_Decoder_Out[16], Current_Window_Decoder_Out[3]);
        and(wR16_Clr_In, Register_Clear_Decoder_Out[16], Current_Window_Decoder_Out[3]);

        Register_32Bits R16(wR16_Out, PortC, Clk, wR16_Clr_In, wR16_Ld_In);



        and(wR17_Ld_In, Load_Enable_Decoder_Out[17], Current_Window_Decoder_Out[3]);
        and(wR17_Clr_In, Register_Clear_Decoder_Out[17], Current_Window_Decoder_Out[3]);

        Register_32Bits R17(wR17_Out, PortC, Clk, wR17_Clr_In, wR17_Ld_In);



        and(wR18_Ld_In, Load_Enable_Decoder_Out[18], Current_Window_Decoder_Out[3]);
        and(wR18_Clr_In, Register_Clear_Decoder_Out[18], Current_Window_Decoder_Out[3]);

        Register_32Bits R18(wR18_Out, PortC, Clk, wR18_Clr_In, wR18_Ld_In);



        and(wR19_Ld_In, Load_Enable_Decoder_Out[19], Current_Window_Decoder_Out[3]);
        and(wR19_Clr_In, Register_Clear_Decoder_Out[19], Current_Window_Decoder_Out[3]);

        Register_32Bits R19(wR19_Out, PortC, Clk, wR19_Clr_In, wR19_Ld_In);



        and(wR20_Ld_In, Load_Enable_Decoder_Out[20], Current_Window_Decoder_Out[3]);
        and(wR20_Clr_In, Register_Clear_Decoder_Out[20], Current_Window_Decoder_Out[3]);

        Register_32Bits R20(wR20_Out, PortC, Clk, wR20_Clr_In, wR20_Ld_In);



        and(wR21_Ld_In, Load_Enable_Decoder_Out[21], Current_Window_Decoder_Out[3]);
        and(wR21_Clr_In, Register_Clear_Decoder_Out[21], Current_Window_Decoder_Out[3]);

        Register_32Bits R21(wR21_Out, PortC, Clk, wR21_Clr_In, wR21_Ld_In);



        and(wR22_Ld_In, Load_Enable_Decoder_Out[22], Current_Window_Decoder_Out[3]);
        and(wR22_Clr_In, Register_Clear_Decoder_Out[22], Current_Window_Decoder_Out[3]);

        Register_32Bits R22(wR22_Out, PortC, Clk, wR22_Clr_In, wR22_Ld_In);



        and(wR23_Ld_In, Load_Enable_Decoder_Out[23], Current_Window_Decoder_Out[3]);
        and(wR23_Clr_In, Register_Clear_Decoder_Out[23], Current_Window_Decoder_Out[3]);

        Register_32Bits R23(wR23_Out, PortC, Clk, wR23_Clr_In, wR23_Ld_In);


//----------------------------------
//---Ins-Window-3-/-Outs-Window-0--
//----------------------------------
        and(En8_W0, Load_Enable_Decoder_Out[8], Current_Window_Decoder_Out[0]);
        and(En24_W3, Load_Enable_Decoder_Out[24], Current_Window_Decoder_Out[3]);
        or(wR24_Ld_In, En8_W0, En24_W3);

        and(Clr8_W0, Register_Clear_Decoder_Out[8], Current_Window_Decoder_Out[0]);
        and(Clr24_W3, Register_Clear_Decoder_Out[24], Current_Window_Decoder_Out[3]);
        or(wR24_Clr_In, Clr8_W0, Clr24_W3);

        Register_32Bits R24(wR24_Out, PortC, Clk, wR24_Clr_In, wR24_Ld_In);




        and(En9_W0, Load_Enable_Decoder_Out[9], Current_Window_Decoder_Out[0]);
        and(En25_W3, Load_Enable_Decoder_Out[25], Current_Window_Decoder_Out[3]);
        or(wR25_Ld_In, En9_W0, En25_W3);

        and(Clr9_W0, Register_Clear_Decoder_Out[9], Current_Window_Decoder_Out[0]);
        and(Clr25_W3, Register_Clear_Decoder_Out[25], Current_Window_Decoder_Out[3]);
        or(wR25_Clr_In, Clr9_W0, Clr25_W3);

        Register_32Bits R25(wR25_Out, PortC, Clk, wR25_Clr_In, wR25_Ld_In);




        and(En10_W0, Load_Enable_Decoder_Out[10], Current_Window_Decoder_Out[0]);
        and(En26_W3, Load_Enable_Decoder_Out[26], Current_Window_Decoder_Out[3]);
        or(wR26_Ld_In, En10_W0, En26_W3);

        and(Clr10_W0, Register_Clear_Decoder_Out[10], Current_Window_Decoder_Out[0]);
        and(Clr26_W3, Register_Clear_Decoder_Out[26], Current_Window_Decoder_Out[3]);
        or(wR26_Clr_In, Clr10_W0, Clr26_W3);

        Register_32Bits R26(wR26_Out, PortC, Clk, wR26_Clr_In, wR26_Ld_In);




        and(En11_W0, Load_Enable_Decoder_Out[11], Current_Window_Decoder_Out[0]);
        and(En27_W3, Load_Enable_Decoder_Out[27], Current_Window_Decoder_Out[3]);
        or(wR27_Ld_In, En11_W0, En27_W3);

        and(Clr11_W0, Register_Clear_Decoder_Out[11], Current_Window_Decoder_Out[0]);
        and(Clr27_W3, Register_Clear_Decoder_Out[27], Current_Window_Decoder_Out[3]);
        or(wR27_Clr_In, Clr11_W0, Clr27_W3);

        Register_32Bits R27(wR27_Out, PortC, Clk, wR27_Clr_In, wR27_Ld_In);




        and(En12_W0, Load_Enable_Decoder_Out[12], Current_Window_Decoder_Out[0]);
        and(En28_W3, Load_Enable_Decoder_Out[28], Current_Window_Decoder_Out[3]);
        or(wR28_Ld_In, En12_W0, En28_W3);

        and(Clr12_W0, Register_Clear_Decoder_Out[12], Current_Window_Decoder_Out[0]);
        and(Clr28_W3, Register_Clear_Decoder_Out[28], Current_Window_Decoder_Out[3]);
        or(wR28_Clr_In, Clr12_W0, Clr28_W3);

        Register_32Bits R28(wR28_Out, PortC, Clk, wR28_Clr_In, wR28_Ld_In);




        and(En13_W0, Load_Enable_Decoder_Out[13], Current_Window_Decoder_Out[0]);
        and(En29_W3, Load_Enable_Decoder_Out[29], Current_Window_Decoder_Out[3]);
        or(wR29_Ld_In, En13_W0, En29_W3);

        and(Clr13_W0, Register_Clear_Decoder_Out[13], Current_Window_Decoder_Out[0]);
        and(Clr29_W3, Register_Clear_Decoder_Out[29], Current_Window_Decoder_Out[3]);
        or(wR29_Clr_In, Clr13_W0, Clr29_W3);

        Register_32Bits R29(wR29_Out, PortC, Clk, wR29_Clr_In, wR29_Ld_In);




        and(En14_W0, Load_Enable_Decoder_Out[14], Current_Window_Decoder_Out[0]);
        and(En30_W3, Load_Enable_Decoder_Out[30], Current_Window_Decoder_Out[3]);
        or(wR30_Ld_In, En14_W0, En30_W3);

        and(Clr14_W0, Register_Clear_Decoder_Out[14], Current_Window_Decoder_Out[0]);
        and(Clr30_W3, Register_Clear_Decoder_Out[30], Current_Window_Decoder_Out[3]);
        or(wR30_Clr_In, Clr14_W0, Clr30_W3);

        Register_32Bits R30(wR30_Out, PortC, Clk, wR30_Clr_In, wR30_Ld_In);




        and(En15_W0, Load_Enable_Decoder_Out[15], Current_Window_Decoder_Out[0]);
        and(En31_W3, Load_Enable_Decoder_Out[31], Current_Window_Decoder_Out[3]);
        or(wR31_Ld_In, En15_W0, En31_W3);

        and(Clr15_W0, Register_Clear_Decoder_Out[15], Current_Window_Decoder_Out[0]);
        and(Clr31_W3, Register_Clear_Decoder_Out[31], Current_Window_Decoder_Out[3]);
        or(wR31_Clr_In, Clr15_W0, Clr31_W3);

        Register_32Bits R31(wR31_Out, PortC, Clk, wR31_Clr_In, wR31_Ld_In);



//--------------------------------
//---Outs-Window-2-/-Ins-Window-1
//--------------------------------
        and(En8_W2, Load_Enable_Decoder_Out[8], Current_Window_Decoder_Out[2]);
        and(En24_W1, Load_Enable_Decoder_Out[24], Current_Window_Decoder_Out[1]);
        or(wR32_Ld_In, En8_W2, En24_W1);

        and(Clr8_W2, Register_Clear_Decoder_Out[8], Current_Window_Decoder_Out[2]);
        and(Clr24_W1, Register_Clear_Decoder_Out[24], Current_Window_Decoder_Out[1]);
        or(wR32_Clr_In, Clr8_W2, Clr24_W1);

        Register_32Bits R32(wR32_Out, PortC, Clk, wR32_Clr_In, wR32_Ld_In);




        and(En9_W2, Load_Enable_Decoder_Out[9], Current_Window_Decoder_Out[2]);
        and(En25_W1, Load_Enable_Decoder_Out[25], Current_Window_Decoder_Out[1]);
        or(wR33_Ld_In, En9_W2, En25_W1);

        and(Clr9_W2, Register_Clear_Decoder_Out[9], Current_Window_Decoder_Out[2]);
        and(Clr25_W1, Register_Clear_Decoder_Out[25], Current_Window_Decoder_Out[1]);
        or(wR33_Clr_In, Clr9_W2, Clr25_W1);

        Register_32Bits R33(wR33_Out, PortC, Clk, wR33_Clr_In, wR33_Ld_In);




        and(En10_W2, Load_Enable_Decoder_Out[10], Current_Window_Decoder_Out[2]);
        and(En26_W1, Load_Enable_Decoder_Out[26], Current_Window_Decoder_Out[1]);
        or(wR34_Ld_In, En10_W2, En26_W1);

        and(Clr10_W2, Register_Clear_Decoder_Out[10], Current_Window_Decoder_Out[2]);
        and(Clr26_W1, Register_Clear_Decoder_Out[26], Current_Window_Decoder_Out[1]);
        or(wR34_Clr_In, Clr10_W2, Clr26_W1);

        Register_32Bits R34(wR34_Out, PortC, Clk, wR34_Clr_In, wR34_Ld_In);




        and(En11_W2, Load_Enable_Decoder_Out[11], Current_Window_Decoder_Out[2]);
        and(En27_W1, Load_Enable_Decoder_Out[27], Current_Window_Decoder_Out[1]);
        or(wR35_Ld_In, En11_W2, En27_W1);

        and(Clr11_W2, Register_Clear_Decoder_Out[11], Current_Window_Decoder_Out[2]);
        and(Clr27_W1, Register_Clear_Decoder_Out[27], Current_Window_Decoder_Out[1]);
        or(wR35_Clr_In, Clr11_W2, Clr27_W1);

        Register_32Bits R35(wR35_Out, PortC, Clk, wR35_Clr_In, wR35_Ld_In);




        and(En12_W2, Load_Enable_Decoder_Out[12], Current_Window_Decoder_Out[2]);
        and(En28_W1, Load_Enable_Decoder_Out[28], Current_Window_Decoder_Out[1]);
        or(wR36_Ld_In, En12_W2, En28_W1);

        and(Clr12_W2, Register_Clear_Decoder_Out[12], Current_Window_Decoder_Out[2]);
        and(Clr28_W1, Register_Clear_Decoder_Out[28], Current_Window_Decoder_Out[1]);
        or(wR36_Clr_In, Clr12_W2, Clr28_W1);

        Register_32Bits R36(wR36_Out, PortC, Clk, wR36_Clr_In, wR36_Ld_In);




        and(En13_W2, Load_Enable_Decoder_Out[13], Current_Window_Decoder_Out[2]);
        and(En29_W1, Load_Enable_Decoder_Out[29], Current_Window_Decoder_Out[1]);
        or(wR37_Ld_In, En13_W2, En29_W1);

        and(Clr13_W2, Register_Clear_Decoder_Out[13], Current_Window_Decoder_Out[2]);
        and(Clr29_W1, Register_Clear_Decoder_Out[29], Current_Window_Decoder_Out[1]);
        or(wR37_Clr_In, Clr13_W2, Clr29_W1);

        Register_32Bits R37(wR37_Out, PortC, Clk, wR37_Clr_In, wR37_Ld_In);




        and(En14_W2, Load_Enable_Decoder_Out[14], Current_Window_Decoder_Out[2]);
        and(En30_W1, Load_Enable_Decoder_Out[30], Current_Window_Decoder_Out[1]);
        or(wR38_Ld_In, En14_W2, En30_W1);

        and(Clr14_W2, Register_Clear_Decoder_Out[14], Current_Window_Decoder_Out[2]);
        and(Clr30_W1, Register_Clear_Decoder_Out[30], Current_Window_Decoder_Out[1]);
        or(wR38_Clr_In, Clr14_W2, Clr30_W1);

        Register_32Bits R38(wR38_Out, PortC, Clk, wR38_Clr_In, wR38_Ld_In);




        and(En15_W2, Load_Enable_Decoder_Out[15], Current_Window_Decoder_Out[2]);
        and(En31_W1, Load_Enable_Decoder_Out[31], Current_Window_Decoder_Out[1]);
        or(wR39_Ld_In, En15_W2, En31_W1);

        and(Clr15_W2, Register_Clear_Decoder_Out[15], Current_Window_Decoder_Out[2]);
        and(Clr31_W1, Register_Clear_Decoder_Out[31], Current_Window_Decoder_Out[1]);
        or(wR39_Clr_In, Clr15_W2, Clr31_W1);

        Register_32Bits R39(wR39_Out, PortC, Clk, wR39_Clr_In, wR39_Ld_In);




//----------------------------------
//---Local-Registers-Window-2------
//----------------------------------

        and(wR40_Ld_In, Load_Enable_Decoder_Out[16], Current_Window_Decoder_Out[2]);
        and(wR40_Clr_In, Register_Clear_Decoder_Out[16], Current_Window_Decoder_Out[2]);

        Register_32Bits R40(wR40_Out, PortC, Clk, wR40_Clr_In, wR40_Ld_In);



        and(wR41_Ld_In, Load_Enable_Decoder_Out[17], Current_Window_Decoder_Out[2]);
        and(wR41_Clr_In, Register_Clear_Decoder_Out[17], Current_Window_Decoder_Out[2]);

        Register_32Bits R41(wR41_Out, PortC, Clk, wR41_Clr_In, wR41_Ld_In);



        and(wR42_Ld_In, Load_Enable_Decoder_Out[18], Current_Window_Decoder_Out[2]);
        and(wR42_Clr_In, Register_Clear_Decoder_Out[18], Current_Window_Decoder_Out[2]);

        Register_32Bits R42(wR42_Out, PortC, Clk, wR42_Clr_In, wR42_Ld_In);



        and(wR43_Ld_In, Load_Enable_Decoder_Out[19], Current_Window_Decoder_Out[2]);
        and(wR43_Clr_In, Register_Clear_Decoder_Out[19], Current_Window_Decoder_Out[2]);

        Register_32Bits R43(wR43_Out, PortC, Clk, wR43_Clr_In, wR43_Ld_In);



        and(wR44_Ld_In, Load_Enable_Decoder_Out[20], Current_Window_Decoder_Out[2]);
        and(wR44_Clr_In, Register_Clear_Decoder_Out[20], Current_Window_Decoder_Out[2]);

        Register_32Bits R44(wR44_Out, PortC, Clk, wR44_Clr_In, wR44_Ld_In);



        and(wR45_Ld_In, Load_Enable_Decoder_Out[21], Current_Window_Decoder_Out[2]);
        and(wR45_Clr_In, Register_Clear_Decoder_Out[21], Current_Window_Decoder_Out[2]);

        Register_32Bits R45(wR45_Out, PortC, Clk, wR45_Clr_In, wR45_Ld_In);



        and(wR46_Ld_In, Load_Enable_Decoder_Out[22], Current_Window_Decoder_Out[2]);
        and(wR46_Clr_In, Register_Clear_Decoder_Out[22], Current_Window_Decoder_Out[2]);

        Register_32Bits R46(wR46_Out, PortC, Clk, wR46_Clr_In, wR46_Ld_In);



        and(wR47_Ld_In, Load_Enable_Decoder_Out[23], Current_Window_Decoder_Out[2]);
        and(wR47_Clr_In, Register_Clear_Decoder_Out[23], Current_Window_Decoder_Out[2]);

        Register_32Bits R47(wR47_Out, PortC, Clk, wR47_Clr_In, wR47_Ld_In);



//-------------------------------
//---Outs-Window-1-/-Ins-Window-0
//-------------------------------

        and(En8_W1, Load_Enable_Decoder_Out[8], Current_Window_Decoder_Out[1]);
        and(En24_W0, Load_Enable_Decoder_Out[24], Current_Window_Decoder_Out[0]);
        or(wR48_Ld_In, En8_W1, En24_W0);

        and(Clr8_W1, Register_Clear_Decoder_Out[8], Current_Window_Decoder_Out[1]);
        and(Clr24_W0, Register_Clear_Decoder_Out[24], Current_Window_Decoder_Out[0]);
        or(wR48_Clr_In, Clr8_W1, Clr24_W0);

        Register_32Bits R48(wR48_Out, PortC, Clk, wR48_Clr_In, wR48_Ld_In);




        and(En9_W1, Load_Enable_Decoder_Out[9], Current_Window_Decoder_Out[1]);
        and(En25_W0, Load_Enable_Decoder_Out[25], Current_Window_Decoder_Out[0]);
        or(wR49_Ld_In, En9_W1, En25_W0);

        and(Clr9_W1, Register_Clear_Decoder_Out[9], Current_Window_Decoder_Out[1]);
        and(Clr25_W0, Register_Clear_Decoder_Out[25], Current_Window_Decoder_Out[0]);
        or(wR49_Clr_In, Clr9_W1, Clr25_W0);

        Register_32Bits R49(wR49_Out, PortC, Clk, wR49_Clr_In, wR49_Ld_In);




        and(En10_W1, Load_Enable_Decoder_Out[10], Current_Window_Decoder_Out[1]);
        and(En26_W0, Load_Enable_Decoder_Out[26], Current_Window_Decoder_Out[0]);
        or(wR50_Ld_In, En10_W1, En26_W0);

        and(Clr10_W1, Register_Clear_Decoder_Out[10], Current_Window_Decoder_Out[1]);
        and(Clr26_W0, Register_Clear_Decoder_Out[26], Current_Window_Decoder_Out[0]);
        or(wR50_Clr_In, Clr10_W1, Clr26_W0);

        Register_32Bits R50(wR50_Out, PortC, Clk, wR50_Clr_In, wR50_Ld_In);




        and(En11_W1, Load_Enable_Decoder_Out[11], Current_Window_Decoder_Out[1]);
        and(En27_W0, Load_Enable_Decoder_Out[27], Current_Window_Decoder_Out[0]);
        or(wR51_Ld_In, En11_W1, En27_W0);

        and(Clr11_W1, Register_Clear_Decoder_Out[11], Current_Window_Decoder_Out[1]);
        and(Clr27_W0, Register_Clear_Decoder_Out[27], Current_Window_Decoder_Out[0]);
        or(wR51_Clr_In, Clr11_W1, Clr27_W0);

        Register_32Bits R51(wR51_Out, PortC, Clk, wR51_Clr_In, wR51_Ld_In);




        and(En12_W1, Load_Enable_Decoder_Out[12], Current_Window_Decoder_Out[1]);
        and(En28_W0, Load_Enable_Decoder_Out[28], Current_Window_Decoder_Out[0]);
        or(wR52_Ld_In, En12_W1, En28_W0);

        and(Clr12_W1, Register_Clear_Decoder_Out[12], Current_Window_Decoder_Out[1]);
        and(Clr28_W0, Register_Clear_Decoder_Out[28], Current_Window_Decoder_Out[0]);
        or(wR52_Clr_In, Clr12_W1, Clr28_W0);

        Register_32Bits R52(wR52_Out, PortC, Clk, wR52_Clr_In, wR52_Ld_In);




        and(En13_W1, Load_Enable_Decoder_Out[13], Current_Window_Decoder_Out[1]);
        and(En29_W0, Load_Enable_Decoder_Out[29], Current_Window_Decoder_Out[0]);
        or(wR53_Ld_In, En13_W1, En29_W0);

        and(Clr13_W1, Register_Clear_Decoder_Out[13], Current_Window_Decoder_Out[1]);
        and(Clr29_W0, Register_Clear_Decoder_Out[29], Current_Window_Decoder_Out[0]);
        or(wR53_Clr_In, Clr13_W1, Clr29_W0);

        Register_32Bits R53(wR53_Out, PortC, Clk, wR53_Clr_In, wR53_Ld_In);



        and(En14_W1, Load_Enable_Decoder_Out[14], Current_Window_Decoder_Out[1]);
        and(En30_W0, Load_Enable_Decoder_Out[30], Current_Window_Decoder_Out[0]);
        or(wR54_Ld_In, En14_W1, En30_W0);

        and(Clr14_W1, Register_Clear_Decoder_Out[14], Current_Window_Decoder_Out[1]);
        and(Clr30_W0, Register_Clear_Decoder_Out[30], Current_Window_Decoder_Out[0]);
        or(wR54_Clr_In, Clr14_W1, Clr30_W0);

        Register_32Bits R54(wR54_Out, PortC, Clk, wR54_Clr_In, wR54_Ld_In);




        and(En15_W1, Load_Enable_Decoder_Out[15], Current_Window_Decoder_Out[1]);
        and(En31_W0, Load_Enable_Decoder_Out[31], Current_Window_Decoder_Out[0]);
        or(wR55_Ld_In, En15_W1, En31_W0);

        and(Clr15_W1, Register_Clear_Decoder_Out[15], Current_Window_Decoder_Out[1]);
        and(Clr31_W0, Register_Clear_Decoder_Out[31], Current_Window_Decoder_Out[0]);
        or(wR55_Clr_In, Clr15_W1, Clr31_W0);

        Register_32Bits R55(wR55_Out, PortC, Clk, wR55_Clr_In, wR55_Ld_In);



//--------------------------------
//---Local-Registers-Window-1-----
//--------------------------------

        and(wR56_Ld_In, Load_Enable_Decoder_Out[16], Current_Window_Decoder_Out[1]);
        and(wR56_Clr_In, Register_Clear_Decoder_Out[16], Current_Window_Decoder_Out[1]);

        Register_32Bits R56(wR56_Out, PortC, Clk, wR56_Clr_In, wR56_Ld_In);



        and(wR57_Ld_In, Load_Enable_Decoder_Out[17], Current_Window_Decoder_Out[1]);
        and(wR57_Clr_In, Register_Clear_Decoder_Out[17], Current_Window_Decoder_Out[1]);

        Register_32Bits R57(wR57_Out, PortC, Clk, wR57_Clr_In, wR57_Ld_In);



        and(wR58_Ld_In, Load_Enable_Decoder_Out[18], Current_Window_Decoder_Out[1]);
        and(wR58_Clr_In, Register_Clear_Decoder_Out[18], Current_Window_Decoder_Out[1]);

        Register_32Bits R58(wR58_Out, PortC, Clk, wR58_Clr_In, wR58_Ld_In);



        and(wR59_Ld_In, Load_Enable_Decoder_Out[19], Current_Window_Decoder_Out[1]);
        and(wR59_Clr_In, Register_Clear_Decoder_Out[19], Current_Window_Decoder_Out[1]);

        Register_32Bits R59(wR59_Out, PortC, Clk, wR59_Clr_In, wR59_Ld_In);



        and(wR60_Ld_In, Load_Enable_Decoder_Out[20], Current_Window_Decoder_Out[1]);
        and(wR60_Clr_In, Register_Clear_Decoder_Out[20], Current_Window_Decoder_Out[1]);

        Register_32Bits R60(wR60_Out, PortC, Clk, wR60_Clr_In, wR60_Ld_In);



        and(wR61_Ld_In, Load_Enable_Decoder_Out[21], Current_Window_Decoder_Out[1]);
        and(wR61_Clr_In, Register_Clear_Decoder_Out[21], Current_Window_Decoder_Out[1]);

        Register_32Bits R61(wR61_Out, PortC, Clk, wR61_Clr_In, wR61_Ld_In);



        and(wR62_Ld_In, Load_Enable_Decoder_Out[22], Current_Window_Decoder_Out[1]);
        and(wR62_Clr_In, Register_Clear_Decoder_Out[22], Current_Window_Decoder_Out[1]);

        Register_32Bits R62(wR62_Out, PortC, Clk, wR62_Clr_In, wR62_Ld_In);



        and(wR63_Ld_In, Load_Enable_Decoder_Out[23], Current_Window_Decoder_Out[1]);
        and(wR63_Clr_In, Register_Clear_Decoder_Out[23], Current_Window_Decoder_Out[1]);

        Register_32Bits R63(wR63_Out, PortC, Clk, wR63_Clr_In, wR63_Ld_In);



//------------------------------
//---Local-Registers-Window-0---
//------------------------------

        and(wR64_Ld_In, Load_Enable_Decoder_Out[16], Current_Window_Decoder_Out[0]);
        and(wR64_Clr_In, Register_Clear_Decoder_Out[16], Current_Window_Decoder_Out[0]);

        Register_32Bits R64(wR64_Out, PortC, Clk, wR64_Clr_In, wR64_Ld_In);



        and(wR65_Ld_In, Load_Enable_Decoder_Out[17], Current_Window_Decoder_Out[0]);
        and(wR65_Clr_In, Register_Clear_Decoder_Out[17], Current_Window_Decoder_Out[0]);

        Register_32Bits R65(wR65_Out, PortC, Clk, wR65_Clr_In, wR65_Ld_In);



        and(wR66_Ld_In, Load_Enable_Decoder_Out[18], Current_Window_Decoder_Out[0]);
        and(wR66_Clr_In, Register_Clear_Decoder_Out[18], Current_Window_Decoder_Out[0]);

        Register_32Bits R66(wR66_Out, PortC, Clk, wR66_Clr_In, wR66_Ld_In);



        and(wR67_Ld_In, Load_Enable_Decoder_Out[19], Current_Window_Decoder_Out[0]);
        and(wR67_Clr_In, Register_Clear_Decoder_Out[19], Current_Window_Decoder_Out[0]);

        Register_32Bits R67(wR67_Out, PortC, Clk, wR67_Clr_In, wR67_Ld_In);



        and(wR68_Ld_In, Load_Enable_Decoder_Out[20], Current_Window_Decoder_Out[0]);
        and(wR68_Clr_In, Register_Clear_Decoder_Out[20], Current_Window_Decoder_Out[0]);

        Register_32Bits R68(wR68_Out, PortC, Clk, wR68_Clr_In, wR68_Ld_In);



        and(wR69_Ld_In, Load_Enable_Decoder_Out[21], Current_Window_Decoder_Out[0]);
        and(wR69_Clr_In, Register_Clear_Decoder_Out[21], Current_Window_Decoder_Out[0]);

        Register_32Bits R69(wR69_Out, PortC, Clk, wR69_Clr_In, wR69_Ld_In);



        and(wR70_Ld_In, Load_Enable_Decoder_Out[22], Current_Window_Decoder_Out[0]);
        and(wR70_Clr_In, Register_Clear_Decoder_Out[22], Current_Window_Decoder_Out[0]);

        Register_32Bits R70(wR70_Out, PortC, Clk, wR70_Clr_In, wR70_Ld_In);



        and(wR71_Ld_In, Load_Enable_Decoder_Out[23], Current_Window_Decoder_Out[0]);
        and(wR71_Clr_In, Register_Clear_Decoder_Out[23], Current_Window_Decoder_Out[0]);

        Register_32Bits R71(wR71_Out, PortC, Clk, wR71_Clr_In, wR71_Ld_In);


//*******************************

endmodule




//---------------------------------------------------
//	The section below contains every sub-module
//	used in the Register Window Circuit
//----------------------------------------------------

//*****************************
//	Register Module
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

