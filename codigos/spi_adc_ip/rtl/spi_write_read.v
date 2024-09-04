// Author: Julisa Verdejo Palacios
// Name: spi_wr.v
//
// Description: Instanciacion de los modulos escritura y lectura del spi.

module spi_write_read (
  input         rst_i,
  input         clk_i,
  input         strc_i,
  input   [7:0] cmd_i,
  input   [7:0] kmax_i,
  input         miso_i,
  output        mosi_o,
  output [11:0] dout_o,
  output        dclk_o,
  output        cs_o,
  output        eoc_o
);

  wire slow_clk, eow, eor;

  spi_write_ip mod_spiw (
    .rst_i(rst_i),
    .clk_i(clk_i),
    .strw_i(strc_i),
    .cmd_i(cmd_i),
    .kmax_i(kmax_i),
    .mosi_o(mosi_o),
    .dclk_o(dclk_o),
    .cs_o(cs_o),
    .eow_o(eow),
    .slow_clk_o(slow_clk)
  );
  
  spi_read_ip mod_spir (
    .rst_i(rst_i), 
    .clk_i(clk_i),
    .strr_i(strc_i), 
    .miso_i(miso_i), 
    .slow_clk_i(slow_clk), 
    .dout_o(dout_o), 
    .eor_o(eor)
  );
  
  assign eoc_o = eow & eor;

endmodule