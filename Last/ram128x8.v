module ram128x8(output reg[7:0] DataOut,output reg MOC, input Enable, ReadWrite, input [8:0] Address, input [7:0] DataIn);
reg [7:0] Mem [0:127];
always @ (Enable) begin
		MOC=0;
		if(Enable)begin
		
			if(ReadWrite)begin
				DataOut=Mem[Address>>>2];
				$display("Data leida del Address %d es %b",Address,DataOut);
				end
			else begin
				Mem[Address>>>2]=DataIn;
				$display("Data escrita en el Address %d es %b   %d",Address,DataIn,$time);
				end
		 assign MOC=0;
		 end
	    assign MOC=1;
	  
		end
endmodule