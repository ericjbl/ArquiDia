module Shifter_And_SignExtender(output reg [31:0] Out, input [31:0] IR31_0);
always@(IR31_0)
	case(IR31_0[31:30])
		10:
		begin
			if(IR31_0[13] == 1)
				if(IR31_0[24:19] == 6'b111010)
				begin
					if(IR31_0[12] == 0)
					begin
						Out[31:7] = 0;
						Out[6:0] = IR31_0[6:0];
					end

					else
					begin
						Out[31:7] = 25'h1FFFFFF;
						Out[6:0] = IR31_0[6:0];
					end
				end

				else
				begin
					if(IR31_0[12] == 0)
					begin
						Out[31:13] = 0;
						Out[12:0] = IR31_0[12:0];
					end
	
					else
					begin
						if(IR31_0[24:19] == 6'b100101 || IR31_0[24:19] == 6'b100110 || IR31_0[24:19] == 100111)
						begin
							Out[31:13] = 0;
							Out[12:0] = IR31_0[12:0];
						end
					
						else
						begin
							Out[31:13] = 19'h7FFFF;
							Out[12:0] = IR31_0[12:0];
						end
					end
				end
			end

		11:
		begin
			if(IR31_0[13] == 1)
				if(IR31_0[12] == 0)
				begin
					Out[31:13] = 0;
					Out[12:0] = IR31_0[12:0];
				end

			else
			begin
				Out[31:13] = 19'h7FFFF;
				Out[12:0] = IR31_0[12:0];
			end
					
		end	

		00:
		begin
			Out = IR31_0[21:0] << 2;
		end

		01:
		begin
			Out = IR31_0[29:0] << 2;
		end
	endcase

endmodule
