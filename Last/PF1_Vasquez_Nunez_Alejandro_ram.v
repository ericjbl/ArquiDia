module RamAccess(output reg[31:0] DataOut0,output reg MOC, input Enable0, ReadWrite, input [8:0] Address, input [31:0] DataIn0, input [3:0] mode);
	integer fi,fo,code,i; reg[31:0] data;
	reg Enable; reg Enable2;
	reg Enable3; reg Enable4;
	reg[7:0] DataIn; reg[7:0] DataIn2;
	reg[7:0] DataIn3;reg[7:0] DataIn4;
	reg[8:0] temp; reg [8:0] Address1;
	reg [8:0] Address2;reg [8:0] Address3;
	reg [8:0] Address4;
	wire[7:0] DataOut;wire[7:0] DataOut2;
	wire[7:0] DataOut3;wire[7:0] DataOut4;
	wire MOC1;wire MOC2;wire MOC3;wire MOC4;
		//create 4 modules of ram
		ram128x8 ram (DataOut,MOC1,Enable,ReadWrite,Address1,DataIn);
		ram128x8 ram2 (DataOut2,MOC2,Enable2,ReadWrite,Address2,DataIn2);
		ram128x8 ram3 (DataOut3,MOC3,Enable3,ReadWrite,Address3,DataIn3);
		ram128x8 ram4 (DataOut4,MOC4,Enable4,ReadWrite,Address4,DataIn4);
	
	always @ (posedge Enable0) begin
	if(!ReadWrite)begin
	MOC=0;
	if(mode == 0)begin
	Address1=Address;Address2=Address;Address3=Address;Address4=Address;
	if((Address%4 == 3) || Address == 7'b0000011)begin
	for(i=0;i<8;i++)begin
		DataIn4[i]=DataIn0[i];
		end
		Enable4=1'b0;
	#1 Enable4=1'b1;
	 MOC=MOC4;
	end	
	else if((Address%4 == 2) || Address == 7'b0000010)begin
			for(i=0;i<8;i++)begin
			   DataIn3[i]=DataIn0[i];
			end
			Enable3=1'b0;
			#1 Enable3=1'b1;
			 MOC=MOC3;
		end
	else if((Address%4 == 1) || Address == 7'b0000001)begin
			for(i=0;i<8;i++)
			   DataIn2[i]=DataIn0[i];
			Enable2=1'b0;
			#1 Enable2=1'b1;
			MOC=MOC2;
		end
	else begin 			
				Enable=1'b0;
				DataIn=DataIn0;
				#1 Enable=1'b1;
				MOC=MOC1;
			end
	end		
	else if(mode==1)begin
	temp=Address;
	temp=temp>>>1;
	temp=temp<<<1;
	Address1=temp;Address2=temp+1;Address3=temp;Address4=temp+1;
	if(Address[1]==1)begin
			for(i=0;i<16;i++)begin
				if(i>=8) DataIn3[i-8]=DataIn0[i];
				else DataIn4[i]=DataIn0[i];
			end
			Enable3=1'b0;
			Enable4=1'b0;
			Enable4=1'b1;
			Enable3=1'b1;
			#10;
			MOC=MOC4&&MOC3;
	end
	else begin
		for(i=0;i<16;i++)begin
				if(i>=8) DataIn[i-8]=DataIn0[i];
				else DataIn2[i]=DataIn0[i];
			end
			Enable=1'b0;
			Enable2=1'b0;
			Enable2=1'b1;
			Enable=1'b1;
			#10;
			MOC=MOC2&&MOC1;
	end
	
	end
	else if(mode==2) begin
	temp=Address;
	temp=temp>>>2;
	temp=temp<<<2;
	Address1=temp;Address2=temp+1;Address3=temp+2;Address4=temp+3;
			for(i=0;i<32;i++)begin
				if(i>=24) DataIn[i-24]=DataIn0[i];
				else if(i>=16) DataIn2[i-16]=DataIn0[i];
				else if(i>=8) DataIn3[i-8]=DataIn0[i];
				else DataIn4[i]=DataIn0[i];
					end
					Enable=1'b0; Enable2=1'b0; Enable3=1'b0; Enable4=1'b0;
					Enable=1'b1; Enable2=1'b1; Enable3=1'b1; Enable4=1'b1;
					MOC=MOC4&&MOC3&&MOC2&&MOC1;
	end
	end
	else begin
			
			MOC=0;
			if(mode == 0)begin
			Address1=Address;Address2=Address;Address3=Address;Address4=Address;
			if((Address%4 == 3) || Address == 7'b0000011)begin
				Enable4=1'b0;
				#1 Enable4=1'b1;
				#1 wait(MOC4==1);
				DataOut0=DataOut4;
				MOC=MOC4;
			end
			else if((Address%4 == 2) || Address == 7'b0000010)begin
					Enable3=1'b0;
					#1 Enable3=1'b1;
					#1 wait(MOC3==1);
					DataOut0=DataOut3;
					MOC=MOC3;
			end
			else if((Address%4 == 1) || Address == 7'b0000001)begin
					Enable2=1'b0;
					#1 Enable2=1'b1;
					#1 wait(MOC2==1);
					DataOut0=DataOut2;
					MOC=MOC2;
			end
			else begin
				Enable=0;
			#1  Enable=1;
			#1 wait(MOC1==1);
			DataOut0=DataOut;
			MOC=MOC1;
			end
		end
		else if(mode==1) begin
			temp=Address;
	temp=temp>>>1;
	temp=temp<<<1;
	Address1=temp;Address2=temp+1;Address3=temp;Address4=temp+1;
	if(Address[1]==1)begin
			Enable3=1'b0;
			Enable4=1'b0;
			Enable4=1'b1;
			Enable3=1'b1;
			#1
			DataOut0={DataOut3,DataOut4};
			#10;
			MOC=MOC4&&MOC3;
	end
	else begin
			Enable=1'b0;
			Enable2=1'b0;
			Enable2=1'b1;
			Enable=1'b1;
			#1
			DataOut0={DataOut,DataOut2};
			#10;
			MOC=MOC2&&MOC1;
	end
		end
	else if(mode==2) begin
	temp=Address;
	temp=temp>>>2;
	temp=temp<<<2;
	Address1=temp;Address2=temp+1;Address3=temp+2;Address4=temp+3;
					Enable=1'b0; Enable2=1'b0; Enable3=1'b0; Enable4=1'b0;
					Enable=1'b1; Enable2=1'b1; Enable3=1'b1; Enable4=1'b1;
					#1
					DataOut0={DataOut,DataOut2,DataOut3,DataOut4};
					MOC=MOC4&&MOC3&&MOC2&&MOC1;
	end
		end
		
	end
endmodule	