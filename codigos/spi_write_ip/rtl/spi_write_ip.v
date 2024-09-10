// Author: Julisa Verdejo Palacios
// Name: spi_write.v
//
// Description: Instanciacion de todos los modulos utilizados para la escritura.

module spi_write_ip (
  input        clk_i,
  input        rst_i,
  input        strw_i,
  input  [7:0] cmd_i,
  input  [7:0] kmax_i,
  output       mosi_o,
  output       dclk_o,
  output       cs_o,
  output       eow_o,
  output       slow_clk_o
);

  wire [1:0] opc1, opc2;
  wire slow_clk, flag, hab;
  
  //localparam  [7:0] cmd_i = 8'b10010111;    // Canal 0
  //localparam  [7:0] kmax_i = 8'd39;         // Periodo dclk = 1600ns
  
  piso_reg   #(.Width(8))  mod_piso    (.rst_i(rst_i), .clk_i(clk_i), .din_i(cmd_i), .op_i(opc1), .dout_o(mosi_o));
  counter_w  #(.Width(5))  mod_cnt_w   (.rst_i(rst_i), .clk_i(clk_i), .opc_i(opc2), .flag_o(flag));
  clk_div    #(.Width(8))  mod_clkdiv  (.rst_i(rst_i), .clk_i(clk_i), .h_i(hab), .kmax_i(kmax_i), .slow_clk_o(slow_clk));
  
  fsm_spi_write  mod_fsm_write (
    .rst_i(rst_i),
    .clk_i(clk_i),
    .strw_i(strw_i),
    .slow_clk_i(slow_clk),
    .flag_i(flag),
    .opc1_o(opc1),
    .opc2_o(opc2),
    .cs_o(cs_o),
    .dclk_o(dclk_o),
    .hab_o(hab),
    .eow_o(eow_o)
  );

  assign slow_clk_o = slow_clk;

endmodule