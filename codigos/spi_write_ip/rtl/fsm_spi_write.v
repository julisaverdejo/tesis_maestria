// Author: Julisa Verdejo Palacios
// Name: fsm_spiw.v
//
// Description: Maquina de estados utilizada para controlar (escribir) el ADC.

module fsm_spi_write (
  input            rst_i,
  input            clk_i,
  input            strw_i,
  input            slow_clk_i,
  input            flag_i,
  output reg [1:0] opc1_o,
  output reg [1:0] opc2_o,
  output reg       cs_o,
  output reg       dclk_o,
  output reg       hab_o,
  output reg       eow_o
);

  localparam [2:0] s0 = 3'b000, // Reset piso_reg, Reset counter_w, Stop clk_div, Wait strw_i, 
                   s1 = 3'b001, // Dummy state
                   s2 = 3'b010, // Load piso_reg, Enable clk_div
                   s3 = 3'b011, // Hold piso_reg, Hold counter_w, dclk up
                   s4 = 3'b100, // Shift piso_reg, Increase counter_w, dclk down
                   s5 = 3'b101, // Hold piso_reg, hold counter_w, dclk down
                   s6 = 3'b110; // Chip select time requirement


  reg [2:0] present_state, next_state;

  always @(strw_i, slow_clk_i, flag_i, present_state) begin
    next_state = present_state;
    opc1_o = 2'b11; opc2_o = 2'b11; cs_o = 1'b1; dclk_o = 1'b0; hab_o = 1'b0; eow_o = 1'b1;
    case (present_state)
      s0 : begin
             opc1_o = 2'b11; opc2_o = 2'b11; cs_o = 1'b1; dclk_o = 1'b0; hab_o = 1'b0; eow_o = 1'b1;
             if (strw_i)
               next_state = s1;
           end

      s1 : begin
             opc1_o = 2'b00; opc2_o = 2'b01; cs_o = 1'b0; dclk_o = 1'b0; hab_o = 1'b0; eow_o = 1'b0;
             next_state = s2;
           end

      s2 : begin
             opc1_o = 2'b01; opc2_o = 2'b01; cs_o = 1'b0; dclk_o = 1'b0; hab_o = 1'b1; eow_o = 1'b0;
             if (slow_clk_i)
               next_state = s3;
           end

      s3 : begin
             opc1_o = 2'b00; opc2_o = 2'b01; cs_o = 1'b0; dclk_o = 1'b1; hab_o = 1'b1; eow_o = 1'b0;
             if (slow_clk_i)
               next_state = s4;
           end 

      s4 : begin
             opc1_o = 2'b10; opc2_o = 2'b10; cs_o = 1'b0; dclk_o = 1'b0; hab_o = 1'b1; eow_o = 1'b0;
             next_state = s5;
           end

      s5 : begin
             opc1_o = 2'b00; opc2_o = 2'b01; cs_o = 1'b0; dclk_o = 1'b0; hab_o = 1'b1; eow_o = 1'b0;
             if (slow_clk_i) begin
                if (flag_i) begin
                  next_state = s6;
                end else begin
                  next_state = s3;
                end
             end
           end 

      s6 : begin
             opc1_o = 2'b00; opc2_o = 2'b01; cs_o = 1'b1; dclk_o = 1'b0; hab_o = 1'b1; eow_o = 1'b0;
               if(slow_clk_i)
                 next_state = s0;
           end

      default: begin
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