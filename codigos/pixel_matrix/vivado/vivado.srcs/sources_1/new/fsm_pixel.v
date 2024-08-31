module fsm_pixel(
    input            clk_i,
    input            rst_i,
    input            tick_i,
    input            tx_done,
    input      [5:0] count_i,
    output reg       stx_o,
    output reg       en_cram_o,
	output reg       sel_o,
    output reg       eos_o
    );
    
    localparam [2:0] s0 = 3'b000,
                     s1 = 3'b001,
                     s2 = 3'b010,
                     s3 = 3'b011,
                     s4 = 3'b100,
					 s5 = 3'b101,
					 s6 = 3'b110,
					 s7 = 3'b111;
    
    reg [2:0] next_state, present_state;
    
    always @(*) begin
      stx_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b1; 
      next_state = present_state;
      case (present_state)
        s0: begin
              stx_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b1;
              if (tick_i)
                next_state = s1;
            end
        s1: begin
              stx_o = 1'b1; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
              next_state = s2;              
            end
         s2: begin
              stx_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
              if (tx_done)
                next_state = s3;              
            end
        s3: begin
              stx_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
              next_state = s4;              
            end	
        s4: begin
              stx_o = 1'b1; en_cram_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
              next_state = s5;              
            end				
        s5: begin
              stx_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
			  if (tx_done)
                next_state = s6;              
            end			
         s6: begin
              stx_o = 1'b0; en_cram_o = 1'b1; sel_o = 1'b0; eos_o = 1'b0;
              next_state = s7;          
            end                      
        s7: begin
              stx_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
              if (count_i == 0)
                next_state = s0;
              else
                next_state = s1;              
            end 
        default:  begin
                    next_state = s0;
                  end                      
      endcase
    end 
    
  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i)
      present_state <= s0;
    else
      present_state <= next_state;
  end
      
endmodule
