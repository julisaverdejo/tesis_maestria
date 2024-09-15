// Author: Julisa Verdejo Palacios
// Name: spi_write.v
//
// Description: Instanciacion de todos los modulos utilizados para la escritura.

module spi_write_dac (
  input         rst_i,
  input         clk_i,
  input         strw_i,
  input   [7:0] kmax_i,
  input  [15:0] din_i,
  output        mosi_o,
  output        sck_o,
  output        cs_o,
  output        eow_o
);

  wire  [1:0] opc1, opc2;
  wire slow_clk, flag, hab;
  
  
  piso_reg_dac   #(.Width(16)) mod_piso    (.rst_i(rst_i), .clk_i(clk_i), .din_i(din_i), .op_i(opc1), .dout_o(mosi_o));
  counter_w_dac  #(.Width(5))  mod_cnt_w   (.rst_i(rst_i), .clk_i(clk_i), .opc_i(opc2), .flag_o(flag));
  clk_div_dac    #(.Width(8))  mod_clkdiv  (.rst_i(rst_i), .clk_i(clk_i), .h_i(hab), .kmax_i(kmax_i), .slow_clk_o(slow_clk));
  
  fsm_spiw_dac  mod_fsm_w (
    .rst_i(rst_i),
    .clk_i(clk_i),
    .strw_i(strw_i),
    .slow_clk_i(slow_clk),
    .flag_i(flag),
    .opc1_o(opc1),
    .opc2_o(opc2),
    .cs_o(cs_o),
    .sck_o(sck_o),
    .hab_o(hab),
    .eow_o(eow_o)
  );

endmodule