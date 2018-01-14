module TestCondition;

//Inputs
reg[6:0] IR31_25;
reg C,N,V,Z;

//Outputs
wire BCOND, TCOND;

Condition_Tester myConditionTester(BCOND, TCOND, IR31_25, C, N, V, Z);

initial fork
	C = 1'b1;
	N = 1'b1;
	V = 1'b0;
	Z = 1'b1;
	IR31_25[6:0] = 7'b0000000;
join

initial begin
	repeat(15) begin
		#2 IR31_25 = IR31_25 + 1'b1;
	end
end

initial begin
        $display("IR31_25		BCOND	TCOND	C N V Z		Time");
        $monitor("%b		%b	%b	%b %b %b %b	%d", IR31_25, BCOND, TCOND, C, N, V, Z, $time);
end

endmodule


/*
*
*/
module Condition_Tester(output reg BCOND, TCOND, input [6:0] IR31_25, input C, N, V, Z);

//***************************************
//	Branch and Trap Condition Codes
//***************************************
parameter [3:0]	ba_ta = 4'b1000,
		bn_tn = 4'b0000,
		bne_tne = 4'b1001,
		be_te = 4'b0001,

		bg_tg = 4'b1010,
		ble_tle = 4'b0010,
		bge_tge = 4'b1011,
		bl_tl = 4'b0011,

		bgu_tgu = 4'b1100,
		bleu_tleu = 4'b0100,
		bcc_tcc = 4'b1101,
		bcs_tcs = 4'b0101,

		bpos_tpos = 4'b1110,
		bneg_tneg = 4'b0110,
		bvc_tvc = 4'b1111,
		bvs_tvs = 4'b0111;
		
always@(IR31_25, C, N, V, Z)
begin
	case(IR31_25[3:0])
		ba_ta:
		begin
			if(IR31_25[6:5] == 0)
			begin
				BCOND = 1'b1;
				TCOND = 1'b0;
			end

			else
			begin
				BCOND = 1'b0;
				TCOND = 1'b1;
			end
		end

		bn_tn:
		begin
			if(IR31_25[6:5] == 0)
			begin
				BCOND = 1'b0;
				TCOND = 1'b0;
			end

			else
			begin
				BCOND = 1'b0;
				TCOND = 1'b0;
			end
		end

		bne_tne:
		begin
			if(IR31_25[6:5] == 0)
				if(!Z)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(!Z)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		be_te:
		begin
			if(IR31_25[6:5] == 0)
				if(Z)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(Z)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bg_tg:
		begin
			if(IR31_25[6:5] == 0)
				if(!(Z || (N ^ V)))
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(!(Z || (N ^ V)))
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		ble_tle:
		begin
			if(IR31_25[6:5] == 0)
				if(Z || (N ^ V))
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(Z || (N ^ V))
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bge_tge:
		begin
			if(IR31_25[6:5] == 0)
				if(!(N ^ V))
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(!(N ^ V))
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bl_tl:
		begin
			if(IR31_25[6:5] == 0)
				if(N ^ V)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(N ^ V)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bgu_tgu:
		begin
			if(IR31_25[6:5] == 0)
				if(!(C || Z))
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(!(C || Z))
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bleu_tleu:
		begin
			if(IR31_25[6:5] == 0)
				if(C || Z)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(C || Z)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bcc_tcc:
		begin
			if(IR31_25[6:5] == 0)
				if(!C)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(!C)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bcs_tcs:
		begin
			if(IR31_25[6:5] == 0)
				if(C)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(C)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bpos_tpos:
		begin
			if(IR31_25[6:5] == 0)
				if(!N)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(!N)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bneg_tneg:
		begin
			if(IR31_25[6:5] == 0)
				if(N)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(N)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bvc_tvc:
		begin
			if(IR31_25[6:5] == 0)
				if(!V)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(!V)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end

		bvs_tvs:
		begin
			if(IR31_25[6:5] == 0)
				if(V)
				begin
					BCOND = 1'b1;
					TCOND = 1'b0;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
			else
				if(V)
				begin
					BCOND = 1'b0;
					TCOND = 1'b1;
				end

				else
				begin
					BCOND = 1'b0;
					TCOND = 1'b0;
				end
		end
	endcase
end
endmodule
