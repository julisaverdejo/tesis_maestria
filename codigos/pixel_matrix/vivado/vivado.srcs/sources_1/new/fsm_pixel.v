module fsm_pixel(
    input            clk_i,
    input            rst_i,
    input            tick_i,
	input            eospi_i,
    input            tx_done,
    input   [1:0]    count_i,
	output reg       st_spi_o,
    output reg       stx_o,
	output reg       we_o,
    output reg       en_cram_o,
    output reg       sel_o,
    output reg       eos_o
    );
    
    localparam [3:0] s0 = 4'b0000,
                     s1 = 4'b0001,
                     s2 = 4'b0010,
                     s3 = 4'b0011,
                     s4 = 4'b0100,
					 s5 = 4'b0101,
					 s6 = 4'b0110,
					 s7 = 4'b0111,
					 s8 = 4'b1000,
					 s9 = 4'b1001,
					 s10 = 4'b1010,
					 s11 = 4'b1011,
					 s12 = 4'b1100;
    
    reg [3:0] next_state, present_state;
    
    always @(*) begin
      st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b1; 
      next_state = present_state;
      case (present_state)
        s0: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b1;
              if (tick_i)
                next_state = s1;
            end
        s1: begin
              st_spi_o = 1'b1; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
              next_state = s2;              
            end
         s2: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
              if (eospi_i)
                next_state = s3;              
            end
        s3: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b1; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
              next_state = s4;              
            end	
        s4: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b1; sel_o = 1'b0; eos_o = 1'b0;
              next_state = s5;              
            end				
        s5: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
			  if (count_i == 0)
                next_state = s6;
              else
                next_state = s0; 			  
            end			
         s6: begin
              st_spi_o = 1'b0; stx_o = 1'b1; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
              next_state = s7;          
            end                      
        s7: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
              if (tx_done)
                next_state = s8;              
            end
        s8: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
              next_state = s9;              
            end	
        s9: begin
              st_spi_o = 1'b0; stx_o = 1'b1; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
              next_state = s10;              
            end	
        s10: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
			  if (tx_done)
                next_state = s11;              
            end	
        s11: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b1; sel_o = 1'b0; eos_o = 1'b0;
              next_state = s12;              
            end	
        s12: begin
              st_spi_o = 1'b0; stx_o = 1'b0; we_o = 1'b0; en_cram_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
              if (count_i == 0)
			    next_state = s0;
              else
                next_state = s6;			  
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
