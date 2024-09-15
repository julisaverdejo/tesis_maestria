// Author: Julisa Verdejo Palacios
// Name: counter_w.v
//
// Description: Contador descendente utilizado para contar los 25 ciclos de dclk.

module counter_address #(
  parameter Width = 5
) (
  input              rst_i,
  input              clk_i,
  input  [1:0]       opc2_i,
  output [Width-1:0] count_o,
  output             flag_o
);

  reg [Width-1:0] mux_d, reg_q;

  always @(opc2_i, reg_q) begin
    case (opc2_i)
      2'b00   : mux_d = 5'd0;
      2'b01   : mux_d = reg_q;
      2'b10   : mux_d = reg_q + 5'd1;
      2'b11   : mux_d = 5'd0;
      default : mux_d = 5'd0;
    endcase
  end
  
  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i)
      reg_q <= 5'd0;
    else
      reg_q <= mux_d;
  end
  
  assign count_o = reg_q;
  
  assign flag_o = (reg_q == 5'd31) ? 1'b1 : 1'b0;
  //assign flag_o = (reg_q == 7'd6) ? 1'b1 : 1'b0;
  
endmodule