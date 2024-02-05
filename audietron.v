module audietron (


   input  clk, // clock is set to 50 mhz
	input wire RESET, // KEY0 push button - reset
	input wire START, // KEY1 push button - start
	input [9:0] SW, // switches 
	output reg [0:9] LED_R, // red LEDs 
	output reg [7:0] dLED // 7-segment display
	
	
	);

	parameter size = 3;
   parameter state0 = 2'b00/*nostart*/, state1 = 2'b01/*wait*/, state2 = 2'b10/*run*/, state3 = 2'b11/*fin*/;
	
	reg [1:0] state/*nostart*/, next_state/*nostart*/;
	reg slwclk = 0; //trigger - 1s
	reg [3:0] REPEAT_COUNT; 
	reg [31:0] counter = 0; //counter - 1s
	reg [5:0] stage;
   reg [3:0] starter; //starter variable
	
	
	
	initial begin
	
		LED_R = 10'b0000000000;
		REPEAT_COUNT = 4'b1001;
		stage = 6'b00_0001;
		starter=0; //starter variable - 0
		
	end
	
	
	reg[31:0] count;
	reg [31:0] count2;
	
	localparam two_sec = 32'd100000000;
	localparam small_sec = 32'd5000000;


	
	always@(posedge clk) begin

	counter <= counter + 1; // increments the counter
	
		if (counter >= (small_sec-1)) begin
			counter <= 0;
			slwclk <= ~slwclk; // slwclk value changed to trigger always block at 0.1 sec
			
		end
		
		if (~START) begin // start light pattern
			starter <= 1;
			
		end
	
		
	   if(REPEAT_COUNT >= 0) begin
		case(REPEAT_COUNT)			
		
			4'd0: dLED=8'b01000000;
			4'd1: dLED=8'b01111001;
			4'd2: dLED=8'b00100100;
			4'd3: dLED=8'b00110000;
			4'd4: dLED=8'b00011001;
			4'd5: dLED=8'b00010010;
			4'd6: dLED=8'b00000010;
			4'd7: dLED=8'b01111000;
			4'd8: dLED=8'b00000000;
			4'd9: dLED=8'b00010000;
			default: dLED=8'b01000000;
			
		endcase
		
	end	
	
	end
	
	// block runs every 0.1 seconds 
	
	always @(posedge clk or negedge RESET) begin
		if(~RESET) begin
			stage <= 6'd1;
			
		end else begin
 
				if(stage == 6'd45) begin // decrement counter when animation is done
					REPEAT_COUNT <= REPEAT_COUNT - 4'b0001;		
					
				end

				if(starter >= 1) begin
					if (count < two_sec) begin
						count <= count + 1;
						
					end else begin
						if (count2 < small_sec) begin
							count2 <= count2 + 1;
							
						end else begin
							count2 <= 0;
					
					
					//
					if(REPEAT_COUNT != 0) begin
						//different stages settings
						case(stage)
							1,7,37: begin
					
								//if(two_sec_counter >= two_sec && stage == 1)
								//begin - 20*0.1 = 2 sec
								
								if(SW[0]==0 && SW[9]==0) begin
									LED_R[0:9] <= 10'b0000110000;
								end
								
								else if(SW[0]==1 && SW[9]==0) begin
									LED_R[0:9] <= 10'b0000010000;
								end
								
								else if(SW[0]==0 && SW[9]==1) begin
									LED_R[0:9] <= 10'b0000100000;
								end	
								
								else if(SW[0]==1 && SW[9]==0) begin
									LED_R[0:9] <= 10'b0000000000;
								end	
						   end
							
							
							//
							2,8,38: begin
								if(SW[0]==0 && SW[9]==0) begin
									LED_R[0:9] <= 10'b0001111000;
								end
								
								else if(SW[0]==1 && SW[9]==0) begin
									LED_R[0:9] <= 10'b0000011000;
								end
								
								else if(SW[0]==0 && SW[9]==1) begin
									LED_R[0:9] <= 10'b0001100000;
								end	
								
								else if(SW[0]==1 && SW[9]==0) begin
									LED_R[0:9] <= 10'b0000000000;
								end				
							end
						
						
						
							//
							3,9: begin
									if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0011111100;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000011100;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b0011100000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end						
								end
								
								
								
							//	
							4,10: begin
			
									if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0111111110;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000011110;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b0111100000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end							
								end
							
						
					
				
							//
							5,11,36: begin
									if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1111111111;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000011111;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1111100000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							
							//
							6,43,44: begin
									LED_R[0:9] <= 10'b0000000000;
							end
							
							
							
							//
							12,22,32,42: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1000000001;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000001;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1000000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							//
							13,31: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1100000001;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000001;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1100000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							
							//
							14,30: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1110000001;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000001;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1110000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							
							//
							15,29: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1011000001;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000001;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1011000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							//
							16,28: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1001100001;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000001;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1001100000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							//
							17,27: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1000110001;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000010001;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1000100000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							//
							18,26: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1000011001;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000011001;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1000000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							
							
							//
							19,25: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1000001101;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000001101;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1000000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							
							
							//
							20,24: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1000000111;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000111;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1000000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							
							
							//
							21,23: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1000000011;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000011;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1000000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							
							//
							33,41: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1100000011;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000011;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1100000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							
							//
							34: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1110000111;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000111;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1110000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							//
							35: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b1111001111;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000001111;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b1111000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							
							
							//
							39: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0011001100;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000001100;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b0011000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end
							
							
							//
							40: begin
								if(SW[0]==0 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0110000110;
									end
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000110;
									end
									
									else if(SW[0]==0 && SW[9]==1) begin
										LED_R[0:9] <= 10'b0110000000;
									end	
									
									else if(SW[0]==1 && SW[9]==0) begin
										LED_R[0:9] <= 10'b0000000000;
									end	
							end	
							
						endcase			
	
						// go back to start of stage
						
						if (stage >= 45) begin		
							stage <= 6'd0;
							
						end else begin 
							stage <= stage + 6'd1;
							
						end 				
						
					end
					
				end
			//
			end
			
			end
			
		end
		
	end
	
endmodule