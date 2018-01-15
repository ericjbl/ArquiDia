module NextStateDecoder  (output reg [6:0] NextState, input [6:0] State, input [31:0] IR, input Cond, input MOC);
always @ (IR,State,Cond,MOC)
case (State)
7'b000000 : NextState = 7'b0000001;
7'b000001 : NextState = 7'b0000010;
7'b000010 : NextState = 7'b0000011;
7'b000011 : if (MOC) NextState = 7'b0000100; else NextState = 7'b0000011;
7'b000100 : begin
    // data processing arithmetic without cc nextstate=0001010
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000000 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b001000 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000100 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b001100 && IR[13] == 1'b0) NextState = 7'b0001010;
    // data processing arithmetic with cc nextstate=0001100
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010000 && IR[13] == 1'b0) NextState = 7'b0001100;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b011000 && IR[13] == 1'b0) NextState = 7'b0001100;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010100 && IR[13] == 1'b0) NextState = 7'b0001100;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b011100 && IR[13] == 1'b0) NextState = 7'b0001100;
    // data processing arithmetic without cc SIMM13 nextstate=0001011
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000000 && IR[13] == 1'b1) NextState = 7'b0001011;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b001000 && IR[13] == 1'b1) NextState = 7'b0001011;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000100 && IR[13] == 1'b1) NextState = 7'b0001011;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b001100 && IR[13] == 1'b1) NextState = 7'b0001011;
    // data processing arithmetic with cc SIMM13 nextstate=0001101
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010000 && IR[13] == 1'b1) NextState = 7'b0001101;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b011000 && IR[13] == 1'b1) NextState = 7'b0001101;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010100 && IR[13] == 1'b1) NextState = 7'b0001101;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b011100 && IR[13] == 1'b1) NextState = 7'b0001101;
    // data processing logical without cc nextstate=0001010
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000001 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000101 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000010 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000110 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000011 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000111 && IR[13] == 1'b0) NextState = 7'b0001010;
    // data processing logical with cc nextstate=0001100
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010001 && IR[13] == 1'b0) NextState = 7'b0001100;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010101 && IR[13] == 1'b0) NextState = 7'b0001100;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010010 && IR[13] == 1'b0) NextState = 7'b0001100;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010110 && IR[13] == 1'b0) NextState = 7'b0001100;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010011 && IR[13] == 1'b0) NextState = 7'b0001100;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010111 && IR[13] == 1'b0) NextState = 7'b0001100;
    // data processing logical without cc SIMM13 nextstate=0001011
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000001 && IR[13] == 1'b1) NextState = 7'b0001011;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000101 && IR[13] == 1'b1) NextState = 7'b0001011;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000010 && IR[13] == 1'b1) NextState = 7'b0001011;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000110 && IR[13] == 1'b1) NextState = 7'b0001011;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000011 && IR[13] == 1'b1) NextState = 7'b0001011;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b000111 && IR[13] == 1'b1) NextState = 7'b0001011;
    // data processing logical with cc SIMM13 nextstate=0001101
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010001 && IR[13] == 1'b1) NextState = 7'b0001101;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010101 && IR[13] == 1'b1) NextState = 7'b0001101;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010010 && IR[13] == 1'b1) NextState = 7'b0001101;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010110 && IR[13] == 1'b1) NextState = 7'b0001101;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010011 && IR[13] == 1'b1) NextState = 7'b0001101;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b010111 && IR[13] == 1'b1) NextState = 7'b0001101;
    // data processing shift nextstate=0001010
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b100101 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b100110 && IR[13] == 1'b0) NextState = 7'b0001010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b100111 && IR[13] == 1'b0) NextState = 7'b0001010;
    // data processing sethi without cc nextstate=0001110
    if (IR[31:30]== 2'b10 && IR[24:22] == 6'b100) NextState = 7'b0001110;
    //load   nextstate = 0010100
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b001001 && IR[13] == 1'b0) NextState = 7'b0010100;
    if (IR[31:30]== 2'b11 &&  IR[24:19] == 6'b001010 && IR[13] == 1'b0) NextState = 7'b0010100;
    if (IR[31:30]== 2'b11 &&IR[24:19] == 6'b001000 && IR[13] == 1'b0) NextState = 7'b0010100;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000001 && IR[13] == 1'b0) NextState = 7'b0010100;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000010 && IR[13] == 1'b0) NextState = 7'b0010100;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000011 && IR[13] == 1'b0) NextState = 7'b0010100;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b001101 && IR[13] == 1'b0) NextState = 7'b0010100;
    //load SIMM13 nextstate = 0011110
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b001001 && IR[13] == 1'b1) NextState = 7'b0011110;
    if (IR[31:30]== 2'b11 &&  IR[24:19] == 6'b001010 && IR[13] == 1'b1) NextState = 7'b0011110;
    if (IR[31:30]== 2'b11 &&IR[24:19] == 6'b001000 && IR[13] == 1'b1) NextState = 7'b0011110;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000001 && IR[13] == 1'b1) NextState = 7'b0011110;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000010 && IR[13] == 1'b1) NextState = 7'b0011110;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000011 && IR[13] == 1'b1) NextState = 7'b0011110;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b001101 && IR[13] == 1'b1) NextState = 7'b0011110;
    //store nextstate=0011001
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000110 && IR[13] == 1'b0) NextState = 7'b0011001;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000100 && IR[13] == 1'b0) NextState = 7'b0011001;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000111 && IR[13] == 1'b0) NextState = 7'b0011001;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b001111 && IR[13] == 1'b0) NextState = 7'b0011001;
    //store SIMM13 nextstate=0100011
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000110 && IR[13] == 1'b1) NextState = 7'b0100011;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000100 && IR[13] == 1'b1) NextState = 7'b0100011;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b000111 && IR[13] == 1'b1) NextState = 7'b0100011;
    if (IR[31:30]== 2'b11 && IR[24:19] == 6'b001111 && IR[13] == 1'b1) NextState = 7'b0100011;
    //call nextstate=0101000
    if (IR[31:30]== 2'b01) NextState = 7'b0101000;
    //jmpl nextstate=0101010
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b111000) NextState = 7'b0101010;
    //rett nextstate=0101101
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b111001 && IR[13] == 1'b0) NextState = 7'b0101101;
    //rett SIMM13 nextstate=0101110
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b111001 && IR[13] == 1'b1) NextState = 7'b0101110;
    //branch true nextstate=0110010
    if (IR[31:30]== 2'b00 &&  IR[28:25] == 4'b1001 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b0001 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b1010 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b0010 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b1011 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b0011 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b1100 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b0100 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b1101 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b0101 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b1110 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b0110 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b1111 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    if (IR[31:30]== 2'b00 && IR[28:25] == 4'b0111 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    //cond branch false a=0 nextstate=0110011
    if (IR[31:30]== 2'b00 && IR[29] == 0 && IR[28:25] == 4'b1000 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    //cond branch false a=1 nextstate=0110100
    if (IR[31:30]== 2'b00 && IR[29] == 1 && IR[28:25] == 4'b1000 && IR[24:22] == 3'b010) NextState = 7'b0110010;
    //uncond branch a=0 nextstate=0110110
    if (IR[31:30]== 2'b00 && IR[29] == 1 && IR[28:25] == 4'b1000 && IR[24:22] == 3'b010) NextState = 7'b0110110;
    if (IR[31:30]== 2'b00 && IR[29] == 1 && IR[28:25] == 4'b0000 && IR[24:22] == 3'b010) NextState = 7'b0110110;
    //RSR 
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b101001) NextState = 7'b0111100;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b101010) NextState = 7'b0111101;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b101011) NextState = 7'b0111110;
    //WSR
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b110001 && IR[13] == 0) NextState = 7'b0111111;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b110010 && IR[13] == 0) NextState = 7'b1000001;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b110011 && IR[13] == 0) NextState = 7'b1000011;
    //WSR SIMM13
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b110001 && IR[13] == 1) NextState = 7'b1000000;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b110010 && IR[13] == 1) NextState = 7'b1000010;
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b110011 && IR[13] == 1) NextState = 7'b1000100;
    //save CWP nextstate = 1000110
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b111100) NextState = 7'b100011;
    //restore CWP nextstate = 1001001
    if (IR[31:30]== 2'b10 && IR[24:19] == 6'b111101) NextState = 7'b1001001;
    //TTR nextstate=1010000
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1000 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0000 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1001 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0001 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1010 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0010 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1011 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0011 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1100 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0100 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1101 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0101 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1110 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0110 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1111 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0111 && IR[24:19] == 6'b111010 && IR[13] == 0) NextState = 7'b1010000;
    //TTR SIMM13 nextstate=1010001
     if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1000 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0000 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1001 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0001 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1010 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0010 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1011 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0011 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1100 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0100 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1101 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0101 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1110 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0110 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b1111 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
    if (IR[31:30]== 2'b10 && IR[28:25] == 4'b0111 && IR[24:19] == 6'b111010 && IR[13] == 1) NextState = 7'b1010001;
end
7'b0001010: NextState = 7'b0000001;
7'b0001011: NextState = 7'b0000001;
7'b0001100: NextState = 7'b0000001;
7'b0001101: NextState = 7'b0000001;
7'b0001110: NextState = 7'b0000001;
7'b0010100: NextState = 7'b0010101;
7'b0011110: NextState = 7'b0010101;
7'b0010101: NextState = 7'b0010110; 
7'b0010110: if(MOC) NextState = 7'b0010111; else NextState = 7'b0010110;
7'b0010111: NextState = 7'b0000001;
7'b0011001: NextState = 7'b0011010;
7'b0100011: NextState = 7'b0011010;
7'b0011010: NextState = 7'b0011011;
7'b0011011: if(MOC) NextState = 7'b0011100; else NextState = 7'b0011011;
7'b0101000: NextState = 7'b0101001;
7'b0101001: NextState = 7'b0000001;
7'b0101010: if(IR[13] == 0) NextState = 7'b0101011; else NextState = 7'b0101100;
7'b0101011: NextState = 7'b0000001;
7'b0101100: NextState = 7'b0000001;
7'b0101101: NextState = 7'b0101111;
7'b0101110: NextState = 7'b0101111;
7'b0110010: NextState = 7'b0000001;
7'b0110011: NextState = 7'b0000001;
7'b0110100: NextState = 7'b0000001;
7'b0110101: NextState = 7'b0000001;
7'b0110110: NextState = 7'b0000001;
7'b0111100: NextState = 7'b0000001;
7'b0111101: NextState = 7'b0000001;
7'b0111110: NextState = 7'b0000001;
7'b0111111: NextState = 7'b0000001;
7'b1000000: NextState = 7'b0000001;
7'b1000001: NextState = 7'b0000001;
7'b1000010: NextState = 7'b0000001;
7'b1000011: NextState = 7'b0000001;
7'b1000100: NextState = 7'b0000001;
7'b1000110: if(IR[13] == 0) NextState = 7'b1000111; else NextState = 7'b1001000;
7'b1000111: NextState = 7'b0000001;
7'b1001000: NextState = 7'b0000001;
7'b1001001: if(IR[13] == 0) NextState = 7'b1001010; else NextState = 7'b1001011;
7'b1001010: NextState = 7'b0000001;
7'b1001011: NextState = 7'b0000001;
7'b1010000: NextState = 7'b1010010;
7'b1010001: NextState = 7'b1010010;
7'b1010010: NextState = 7'b1010011;
7'b1010011: NextState = 7'b1010100;
7'b1010100: NextState = 7'b1010101;
7'b1010101: NextState = 7'b0000001;
default: NextState = 7'b0000000;
endcase
endmodule


module StateReg(output reg [6:0] State, input [6:0] NextState, input Clk, input Clr);
always @ (posedge Clk, negedge Clr)
if(!Clr) State <= 7'b0000000;
else State <= NextState;
endmodule

module ControlSignalEncoder(output reg reg_win_en, rf_load_en, rf_clear_en, clear_select4, clear_select3, clear_select2, clear_select1, clear_select0, ir_ld, mar_ld, mdr_ld, wim_ld, tbr_ld, ttr_ld, pc_ld, npc_ld, psr_ld, r_w, mov, type1, type0, fr_ld, ma1, ma0, mb1, mb0, mc, mf, mm, mnp1, mnp0, mop, mp1, mp0, msa, msc1, msc0, output reg [5:0] opxx, input [6:0] State);
always @ (State)
case (State)
7'b0000000: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0000001: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 1; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 1; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 1; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b100001;
end
7'b0000010: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 0; psr_ld = 0;  r_w = 1; mov = 1; type1 = 1; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 1; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0000011: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 1; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 1; mov = 1; type1 = 1; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0000100: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0001010: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0001011: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0001100: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 1; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0001101: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 1; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1 = 0; mnp0 = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0001110: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 1; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0 = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0010100: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 1; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 1; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0010101: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 1; mov = 1; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0010110: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 1; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 1; mov = 1; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0010111: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 1; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b100001;
end
7'b0011001: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 1; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 1; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 1; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0011010: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 1; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 1; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 1; msc1 = 0; msc0 = 0; opxx = 6'b100000;
end
7'b0011011: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 1; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0011100: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 1; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0011110: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 1; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 1; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0100011: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 1; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 1; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 1; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0101000: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 1; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 1; opxx = 6'b100001;
end
7'b0101001: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 1; mnp0  = 0; mop = 0; mp1 = 1; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0101010: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 1; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b100001;
end
7'b0101011: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 1; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0101100: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 1; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0101101: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 1; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0101110: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 1; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0101111: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 1;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 1; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b100100;
end
7'b0110010: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 1; mnp0  = 0; mop = 0; mp1 = 1; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0110011: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 1; mnp0  = 1; mop = 0; mp1 = 1; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0110100: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 1; mop = 0; mp1 = 1; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0110101: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 1; mnp0  = 0; mop = 0; mp1 = 1; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0110110: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 1; mop = 0; mp1 = 1; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0111100: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 1; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0111101: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 1; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0111110: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 1; ma0 = 1; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b0111111: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 1;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 1; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 1; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1000000: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 1;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 1; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 1; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1000001: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 1; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1000010: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 1; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1000011: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 1; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1000100: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 1; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1000110: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 1;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 1; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b100010;
end
7'b1000111: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1001000: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1001001: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 1;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 1; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b100011;
end
7'b1001010: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1001011: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1010000: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 1; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1010001: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 1; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 1; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
7'b1010010: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 1;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 1; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b100101;
end
7'b1010011: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 1; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 1; msc0 = 0; opxx = 6'b100001;
end
7'b1010100: begin reg_win_en = 1; rf_load_en = 1; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 0; npc_ld = 0; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 1; mb0 = 0; mc = 1; mf = 0; mm = 0; mnp1  = 0; mnp0  = 0; mop = 1; mp1 = 0; mp0 = 0; msa = 0; msc1 = 1; msc0 = 1; opxx = 6'b100001;
end
7'b1010101: begin reg_win_en = 0; rf_load_en = 0; rf_clear_en = 0; clear_select4 = 0; clear_select3 = 0; clear_select2 = 0; clear_select1 = 0; clear_select0 = 0; ir_ld = 0; mar_ld = 0; mdr_ld = 0; wim_ld = 0; tbr_ld = 0; ttr_ld = 0; pc_ld = 1; npc_ld = 1; psr_ld = 0;  r_w = 0; mov = 0; type1 = 0; type0 = 0; fr_ld = 0; ma1 = 0; ma0 = 0; mb1 = 0; mb0 = 0; mc = 0; mf = 0; mm = 0; mnp1  = 1; mnp0  = 0; mop = 0; mp1 = 0; mp0 = 1; msa = 0; msc1 = 0; msc0 = 0; opxx = 6'b000000;
end
endcase
endmodule

module ControlUnit (output [6:0] State, output reg_win_en, rf_load_en, rf_clear_en, clear_select4, clear_select3, clear_select2, clear_select1, clear_select0, ir_ld, mar_ld, mdr_ld, wim_ld, tbr_ld, ttr_ld, pc_ld, npc_ld, psr_ld, r_w, mov, type1, type0, fr_ld, ma1, ma0, mb1, mb0, mc, mf, mm, mnp1, mnp0, mop, mp1, mp0, msa, msc1, msc0, output [5:0] opxx, input [31:0] IR, input Cond, Clk, MOC, Clr );
wire [6:0] NextState;
NextStateDecoder NSD(NextState,State,IR,Cond,MOC);
ControlSignalEncoder CSE(reg_win_en, rf_load_en, rf_clear_en, clear_select4, clear_select3, clear_select2, clear_select1, clear_select0, ir_ld, mar_ld, mdr_ld, wim_ld, tbr_ld, ttr_ld, pc_ld, npc_ld, psr_ld, r_w, mov, type1, type0, fr_ld, ma1, ma0, mb1, mb0, mc, mf, mm, mnp1, mnp0, mop, mp1, mp0, msa, msc1, msc0, opxx, State);
StateReg SR(State,NextState,Clk,Clr);
endmodule

module main;
reg [31:0] IR;
reg Cond;
reg Clk;
reg MOC;
reg Clr;
wire [6:0] State;
wire reg_win_en, rf_load_en, rf_clear_en, clear_select4, clear_select3, clear_select2, clear_select1, clear_select0, ir_ld, mar_ld, mdr_ld, wim_ld, tbr_ld, ttr_ld, pc_ld, npc_ld, psr_ld, r_w, mov, type1, type0,fr_ld, ma1, ma0, mb1, mb0, mc, mf, mm, mnp1, mnp0, mop, mp1, mp0, msa, msc1, msc0;
wire [5:0] opxx;
ControlUnit CU(State,reg_win_en, rf_load_en, rf_clear_en, clear_select4, clear_select3, clear_select2, clear_select1, clear_select0, ir_ld, mar_ld, mdr_ld, wim_ld, tbr_ld, ttr_ld, pc_ld, npc_ld, psr_ld, r_w, mov, type1, type0, fr_ld, ma1, ma0, mb1, mb0, mc, mf, mm, mnp1, mnp0, mop, mp1, mp0, msa, msc1, msc0, opxx, IR, Cond, Clk, MOC, Clr);
initial #10000 $finish;
initial begin
Clk = 1'b0;
MOC=1'b0; #3 MOC = 1;
repeat (100) #5 Clk = ~Clk;#8 MOC = ~MOC;end
initial fork
   #3 IR = 32'b10000010001000010100000000000010; // data processing without cc and SIMM13
   #6 IR = 32'b10000010001000010110000000000010; // data processing SIMM13 without cc 
   #9 IR = 32'b10000010101000010100000000000010;// data processing cc without SIMM13
   #12 IR = 32'b10000010101000010110000000000010;// data processing cc SIMM13
   #15 IR = 32'b1000001100000010110000000000010;// SETHI
   #18 IR = 32'b1100001001010010110000000000010;// load
   #21 IR = 32'b1100001001010010111000000000010;// load SIMM13
   #24 IR = 32'b1100001000110001010000000000010;// store
   #27 IR = 32'b1100001000110001011000000000010;// store SIMM13
   #30 IR = 32'b0100001000110001011000000000010;// call
   #33 IR = 32'b1000001111000001010000000000010;// jmpl 
   #36 IR = 32'b1000001111000001011000000000010;// jmpl SIMM13
   #39 IR = 32'b1000001111001001010000000000010;// rett 
   #42 IR = 32'b1000001111000001011000000000010;// rett SIMM13
   #45 IR = 32'b0000000010000001010000000000010;// cond true
   #48 IR = 32'b0001001010000001010000000000010;// cond false a=0
   #51 IR = 32'b0011001010000001010000000000010;// cond false a=1
   #54 IR = 32'b0010000010000001010000000000010;// uncond false a=1
   #57 IR = 32'b1010000101001001010000000000010;// rsr psr
   #60 IR = 32'b1010000101010001010000000000010;// rsr wim
   #63 IR = 32'b1010000101011010100000000000010;// rsr tbr
   #66 IR = 32'b1010000110001101000000000000010;// wsr psr
   #69 IR = 32'b1010000110001101001000000000010;// wsr psr SIMM13
   #72 IR = 32'b1010000110010101000000000000010;// wsr wim
   #75 IR = 32'b1010000110010101001000000000010;// wsr wim SIMM13
   #78 IR = 32'b1010000110011101000000000000010;// wsr tbr
   #81 IR = 32'b1010000110011101001000000000010;// wsr tbr SIMM13
   #84 IR = 32'b1010000111100101000000000000010;// save
   #87 IR = 32'b1010000111100101001000000000010;// save SIMM13
   #90 IR = 32'b1010000111101101000000000000010;// restore
   #93 IR = 32'b1010000111101101001000000000010;// restore SIMM13
   #96 IR = 32'b1010000111010101000000000000010;// ttr
   #99 IR = 32'b1010000111010101001000000000010;// ttr SIMM13
   #3 Cond = 0;
    Clr =0;
   #3 Clr = 1;
join 
initial begin
    $display(" State reg_win_en rf_load_en rf_clear_en clear_select4 clear_select3 clear_select2 clear_select1 clear_select0 ir_ld mar_ld mdr_ld wim_ld tbr_ld ttr_ld pc_ld npc_ld psr_ld r_w mov type1 type0 fr_ld ma1 ma0 mb1 mb0 mc mf mm mnp1 mnp0 mop mp1 mp0 msa msc1 msc0 opxx  MOC         Time ");
    $monitor(" %d %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %d ", State, reg_win_en, rf_load_en, rf_clear_en, clear_select4, clear_select3, clear_select2, clear_select1, clear_select0, ir_ld, mar_ld, mdr_ld, wim_ld, tbr_ld, ttr_ld, pc_ld, npc_ld, psr_ld, r_w, mov, type1, type0, fr_ld, ma1, ma0, mb1, mb0, mc, mf, mm, mnp1, mnp0, mop, mp1, mp0, msa, msc1, msc0, opxx, IR, MOC, $time);
end
endmodule