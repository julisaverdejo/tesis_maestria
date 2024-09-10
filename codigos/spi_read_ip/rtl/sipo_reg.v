// Author: Julisa Verdejo Palacios
// Name: sipo_reg.v
//
// Description: Registro con entrada en serie y salida en paralelo con desplazamiento a la izquierda.

module sipo_reg #(
  parameter Width = 16
) (
  input               rst_i,
  input               clk_i,
  input               din_i,
  input         [1:0] op_i,
  output  [Width-1:0] dout_o
);

  reg [Width-1:0] reg_q, mux_d;

  always @(din_i, op_i, reg_q) begin
    case (op_i)
      2'b00   : mux_d = 0;
      2'b01   : mux_d = reg_q;
      2'b10   : mux_d = {reg_q[Width-2:0],din_i};
      2'b11   : mux_d = 0;
      default : mux_d = 0;
    endcase
  end

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i)
      reg_q <= 0;
    else
      reg_q <= mux_d;
  end

  assign dout_o = reg_q;

endmodule
