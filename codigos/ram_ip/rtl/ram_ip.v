module ram_ip (
  input      [5:0] addr_i,
  output reg [15:0] rom_o
);

  always @(*) begin
	case(addr_i)
       0 : rom_o = 15'd365;
       1 : rom_o = 15'd364;
       2 : rom_o = 15'd302;
       3 : rom_o = 15'd303;
       4 : rom_o = 15'd304;
       5 : rom_o = 15'd305;
       6 : rom_o = 15'd306;
       7 : rom_o = 15'd307;
       8 : rom_o = 15'd308;
       9 : rom_o = 15'd309;
      10 : rom_o = 15'd310;
      11 : rom_o = 15'd311;
      12 : rom_o = 15'd312;
      13 : rom_o = 15'd313;
      14 : rom_o = 15'd314;
      15 : rom_o = 15'd315;
      16 : rom_o = 15'd316;
      17 : rom_o = 15'd317;
      18 : rom_o = 15'd318;
      19 : rom_o = 15'd319;
      20 : rom_o = 15'd320;
      21 : rom_o = 15'd321;
      22 : rom_o = 15'd322;
      23 : rom_o = 15'd323;
      24 : rom_o = 15'd324;
      25 : rom_o = 15'd325;
      26 : rom_o = 15'd326;
      27 : rom_o = 15'd327;
      28 : rom_o = 15'd328;
      29 : rom_o = 15'd329;
      30 : rom_o = 15'd330;
      31 : rom_o = 15'd331;
      32 : rom_o = 15'd332;
      33 : rom_o = 15'd333;
      34 : rom_o = 15'd334;
      35 : rom_o = 15'd335;
      36 : rom_o = 15'd336;
      37 : rom_o = 15'd337;
      38 : rom_o = 15'd338;
      39 : rom_o = 15'd339;
      40 : rom_o = 15'd340;
      41 : rom_o = 15'd341;
      42 : rom_o = 15'd342;
      43 : rom_o = 15'd343;
      44 : rom_o = 15'd344;
      45 : rom_o = 15'd345;
      46 : rom_o = 15'd346;
      47 : rom_o = 15'd347;
      48 : rom_o = 15'd348;
      49 : rom_o = 15'd349;
      50 : rom_o = 15'd350;
      51 : rom_o = 15'd351;
      52 : rom_o = 15'd352;
      53 : rom_o = 15'd353;
      54 : rom_o = 15'd354;
      55 : rom_o = 15'd355;
      56 : rom_o = 15'd356;
      57 : rom_o = 15'd357;
      58 : rom_o = 15'd358;
      59 : rom_o = 15'd359;
      60 : rom_o = 15'd360;
      61 : rom_o = 15'd361;
      62 : rom_o = 15'd362;
      63 : rom_o = 15'd363;
	  default: rom_o = 15'd0;
	endcase
  end  
    
endmodule
