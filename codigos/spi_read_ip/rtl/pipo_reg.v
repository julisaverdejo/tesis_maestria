// Author: Julisa Verdejo Palacios
// Name: pipo_reg.v
//
// Description: Registro con entrada y salida en paralelo con habilitacion.

module pipo_reg #(
  parameter Width = 12
) ( 
  input                   rst_i,
  input                   clk_i,
  input                   hab_i,
  input      [Width-1:0]  din_i,
  output reg [Width-1:0]  dout_o
);

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i)
      dout_o <= 0; 
    else if (hab_i)
      dout_o <= din_i;
  end   
  
endmodule