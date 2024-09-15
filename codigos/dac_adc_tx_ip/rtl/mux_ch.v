// Author: Julisa Verdejo Palacios
// Name: mux_ch.v
//
// Description: 

module mux_ch #(
  parameter Width = 8
) (
  input               sel_i,
  input   [Width-1:0] dmsb_i,
  input   [Width-1:0] dlsb_i,
  output  [Width-1:0] data_o
);

  assign data_o = sel_i ? dlsb_i : dmsb_i;
endmodule