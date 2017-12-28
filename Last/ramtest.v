module ramtest2;
	integer fi,fo,code,i; reg[31:0] data;
	reg Enable, ReadWrite; reg[31:0] word;
	reg[63:0] doubleWord;
	reg[7:0] readbyte1;reg[7:0] readbyte2;reg[7:0] readbyte3;reg[7:0] readbyte4;
	reg[8:0] Address;wire[31:0] DataOut; reg[3:0] mode;
	RamAccess ram1(DataOut,MOC,Enable,ReadWrite,Address,data,mode);
	//Read from a file bytes,halfword,words and doubleword and write it to the RAM.
initial begin
		//Preload RAM with a file
		ReadWrite=1'b0;
		mode=0;
		Address=7'b0000000;
		fi=$fopen("PF1_Vasquez_Nunez_Alejandro_ramdata.txt","r");
		while(!$feof(fi))begin
		code = $fscanf(fi, "%b", data);
		Enable=0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
		#1 Address=Address+1;
		end
		
		
		ReadWrite=1'b1;
		
	
	//Reads from a word
		wait(ReadWrite==1);
		fo=$fopen("memcontent.txt","w");
		//
		mode=2;
		Address=0;
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
		$fdisplay(fo,"Word en %d = %b %d",Address,DataOut,$time);
		//Writes a halfword
		ReadWrite=0;
		#1 mode=1;
		Address=3;
		Enable=0;
		data=16'b0111111100000000;
		#1 Enable=1;
		#1 wait(MOC==1);
		
		//now reads again the word in the first address
		#1 ReadWrite=1'b1;
		mode=2;
		Address=0;
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
		Address=Address>>>2;
		$fdisplay(fo,"Word en %d = %b %d",Address<<<2,DataOut,$time);
		
		//Read from Ram a doubleWord
		Address=7;
		mode=2;
		for(i=0;i<2;i++) begin
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
		 doubleWord = {doubleWord,DataOut};
		Address=Address+4;
		end
		Address=Address>>>2;
		$fdisplay(fo,"DoubleWord en %d = %b %d",(Address<<<2)-8,doubleWord,$time);
		
		//Writes a word
		ReadWrite=0;
		mode=2;
		Address=5;
		Enable=0;
		data=32'b01111111011111000111000100001111;
		#1 Enable=1;
		#1 wait(MOC==1);
		
		//Reads a Doubleword to a file
		#1 ReadWrite=1;
		mode=2;
		Address=0;
		for(i=0;i<2;i++) begin
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
		 doubleWord = {doubleWord,DataOut};
		Address=Address+4;
		end
		Address=Address>>>3;
		$fdisplay(fo,"DoubleWord en %d = %b %d",(Address<<<3),doubleWord,$time);
		//Reads a byte
		mode=0;
		Address=3;
		#1 Enable=1'b0;
		#1 Enable=1'b1;	
		#1 wait(MOC==1);
		$fdisplay(fo,"byte en %d = %b %d",Address,DataOut,$time);
		//Writes a byte
		mode=0;
		ReadWrite=0;		
		Address=5;
		data=8'b00000011;
		#1 Enable=1'b0;
		#1 Enable=1'b1;	
		#1 wait(MOC==1);
		//Reads a halfword
		mode=1;
		ReadWrite=1;
		Address=4;
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
	 $fdisplay(fo,"Halfword en %d = %b %d",Address,DataOut,$time);
	 
	 //Writes a doubleWord
		ReadWrite=0;
		mode=2;
		Address=4;
		Enable=0;
		data=32'b00000000111111111111111100000000;
		#1 Enable=1;
		#1 wait(MOC==1);
		Address=Address+4;
		Enable=0;
		data=32'b11111111000000000000000011111111;
		#1 Enable=1;
		#1 wait(MOC==1);
		//Reads a Doubleword to a file
		#1 ReadWrite=1;
		mode=2;
		Address=0;
		for(i=0;i<2;i++) begin
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
		 doubleWord = {doubleWord,DataOut};
		Address=Address+4;
		end
		Address=Address>>>3;
		$fdisplay(fo,"DoubleWord en %d = %b %d",Address<<<3,doubleWord,$time);
		
		
		end
		
		/////////////////////////
		//Read a byte
		/////////////////////////
		/*
		//Select address to read
		Address=15;
		
		#1 Enable=1'b0;
		#1 Enable=1'b1;	
		#1 wait(MOC==1);
		$fdisplay(fo,"byte en %d = %b %d",Address,DataOut,$time);
		end
		*/
		
		
		
		////////////////////////
		//Reads a Halfword
		////////////////////////
		/*
		//Select address to read
		Address=0;
		
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
		 readbyte1= DataOut;
		Address=Address+1;
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
	 $fdisplay(fo,"Halfword en %d = %b %d",Address-1,{readbyte1,DataOut},$time);
	 end
		*/
		
		
		/////////////////////////////
		//Reads a Word
		////////////////////////////
		/*
		//Select address to read
		Address=0;
		
		for(i=0;i<4;i++) begin
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
		 word = {word,DataOut};
		Address=Address+1;
		end
		$fdisplay(fo,"Word en %d = %b %d",Address-4,word,$time);
		end
		*/
		
		///////////////////////////////
		//Read a DoubleWord
		///////////////////////////////
		/*
		//Select address to read
		Address=0;
		
		for(i=0;i<8;i++) begin
		Enable=1'b0;
		#1 Enable=1'b1;
		#1 wait(MOC==1);
		 doubleWord = {doubleWord,DataOut};
		Address=Address+1;
		end
		$fdisplay(fo,"DoubleWord en %d = %b %d",Address-8,doubleWord,$time);
		end
		*/
		
		
		//This is for automatic testing.
		//#300 $finish
	/*always@(posedge MOC)
	begin
	if(ReadWrite)begin
			Enable=1'b0;
			#1 Enable=1'b1;
			Address=Address+4;
			#1 $fdisplay(fo,"data en %d = %b %d %d",Address-4,DataOut,MOC,$time);
			
	end
	else begin
		if(!$feof(fi)) begin
			Address=Address+4;
			code = $fscanf(fi, "%b", data);
			Enable=1'b0;
			#1 Enable=1'b1;
			end
			end*/

endmodule