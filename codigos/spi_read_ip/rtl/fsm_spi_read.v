// Author: Julisa Verdejo Palacios
// Name: fsm_spir.v
//
// Description: Maquina de estados utilizada para guardar los datos recibidos del ADC (conversion).

module fsm_spi_read (
  input             rst_i,
  input             clk_i,
  input             strr_i,
  input             slow_clk_i,
  input      [5:0]  cnt_i,
  output reg [1:0]  opc1_o,
  output reg [1:0]  opc2_o,
  output reg        eor_o,
  output reg        hab_o
);

  localparam [3:0] s0 = 4'b0000, // Wait strr_i, Reset counter_r, Reset sipo_reg
                   s1 = 4'b0001, // 
                   s2 = 4'b0010, //
                   s3 = 4'b0011, //
                   s4 = 4'b0100, //
                   s5 = 4'b0101, //
                   s6 = 4'b0110, //
                   s7 = 4'b0111; //

  reg [3:0] next_state, present_state;

  always @(slow_clk_i, cnt_i, strr_i, present_state) begin
    opc1_o = 2'b00; opc2_o = 2'b00; eor_o = 1'b1; hab_o = 1'b0;
    next_state = present_state;
    case (present_state)
      s0 : begin
             opc1_o = 2'b00; opc2_o = 2'b00; eor_o = 1'b1; hab_o = 1'b0;
             if (strr_i)
               next_state = s1;
           end

      s1 : begin
             opc1_o = 2'b01; opc2_o = 2'b01; eor_o = 1'b0; hab_o = 1'b0;
             next_state = s2;
           end

      s2 : begin
             opc1_o = 2'b01; opc2_o = 2'b01; eor_o = 1'b0; hab_o = 1'b0;
             if (slow_clk_i)
               next_state = s3;
           end

      s3 : begin
             opc1_o = 2'b10; opc2_o = 2'b01; eor_o = 1'b0; hab_o = 1'b0;
             next_state = s4;
           end

      s4 : begin
             opc1_o = 2'b01; opc2_o = 2'b01; eor_o = 1'b0; hab_o = 1'b0;
             if (slow_clk_i) begin
               if (cnt_i == 6'd50) begin
                 next_state = s7;
               end else begin
                 if (cnt_i >= 6'd18)
                   next_state = s5;
                 else
                   next_state = s3;
               end
             end
           end

      s5 : begin
             opc1_o = 2'b10; opc2_o = 2'b10; eor_o = 1'b0; hab_o = 1'b0;
             next_state = s6;
           end

      s6 : begin
             opc1_o = 2'b01; opc2_o = 2'b01; eor_o = 1'b0; hab_o = 1'b0;
             if (slow_clk_i) 
               next_state = s3;
           end

      s7 : begin
             opc1_o = 2'b01; opc2_o = 2'b01; eor_o = 1'b0; hab_o = 1'b1;
             next_state = s0;
           end

      default : begin
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