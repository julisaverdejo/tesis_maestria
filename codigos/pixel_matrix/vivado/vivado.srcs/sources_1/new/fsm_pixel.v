// Author: Julisa Verdejo Palacios
// Name: .v
//
// Description:

module fsm_pixel(
  input             rst_i,
  input             clk_i,
  input             tick_i,
  input             eospi_i,
  input             tx_done_i,
  input  [2:0]      cnt_row_i,
  input  [2:0]      cnt_col_i,
  input  [5:0]      cnt_ram_i,
  input  [7:0]      cnt_i,
  output reg        st_spi_o,
  output reg        stx_o,
  output reg        ena_cnt_row_o,
  output reg        ena_cnt_col_o,
  output reg        ena_cnt_ram_o,
  output reg        ena_cnt_o,
  output reg        we_o,
  output reg        sel_o,
  output reg        eos_o
);

  localparam [4:0]  s0 = 5'b00000,
                    s1 = 5'b00001,
                    s2 = 5'b00010,
				    s3 = 5'b00011,
				    s4 = 5'b00100,
				    s5 = 5'b00101,
				    s6 = 5'b00110,
				    s7 = 5'b00111,
				    s8 = 5'b01000,
				    s9 = 5'b01001,
				   s10 = 5'b01010,
				   s11 = 5'b01011,
				   s12 = 5'b01100,
				   s13 = 5'b01101,
				   s14 = 5'b01110,
				   s15 = 5'b01111,
				   s16 = 5'b10000,
				   s17 = 5'b10001;

  reg [4:0] next_state, present_state;

  always @(*) begin
	st_spi_o = 1'b0 ; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b1;
    next_state = present_state;
    case(present_state)
       s0: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b1;
             if (tick_i)
               next_state = s1;
           end

       s1: begin
			st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b1; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
            if (cnt_i)
			  next_state = s2;
           end

       s2: begin
			st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
			next_state = s3;
           end

       s3: begin
			st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
			next_state = s4;
           end

       s4: begin
			 st_spi_o = 1'b1; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s5;
           end 

       s5: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (eospi_i)
               next_state = s6;
           end

       s6: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b1; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s7;
           end

       s7: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b1; ena_cnt_ram_o = 1'b1; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
			 next_state = s8;
           end

       s8: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (cnt_col_i == 0)
			   next_state = s9;
			 else
			   next_state = s1;
           end

       s9: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b1; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s10;
           end

       s10: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (cnt_row_i == 0)
               next_state = s11;
             else
               next_state = s1;
           end

       s11: begin
			 st_spi_o = 1'b0; stx_o = 1'b1; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s12;
           end		  
 
       s12: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (tx_done_i)
               next_state = s13;
           end 
 
       s13: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
             next_state = s14;
           end  

       s14: begin
			 st_spi_o = 1'b0; stx_o = 1'b1; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
             next_state = s15;
           end 
           
       s15: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b1; eos_o = 1'b0;
             if (tx_done_i)
               next_state = s16;
           end

       s16: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b1; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             next_state = s17;
           end

       s17: begin
			 st_spi_o = 1'b0; stx_o = 1'b0; ena_cnt_row_o = 1'b0; ena_cnt_col_o = 1'b0; ena_cnt_ram_o = 1'b0; ena_cnt_o = 1'b0; we_o = 1'b0; sel_o = 1'b0; eos_o = 1'b0;
             if (cnt_ram_i == 0)
               next_state = s0;
             else
               next_state = s11;
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