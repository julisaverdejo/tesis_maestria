// Author: Julisa Verdejo Palacios
// Name: piso_reg.v
//
// Description: Registro con entrada en paralelo y salida en serie con desplazamiento hacia la izquierda.		

module piso_reg #(
  parameter Width = 8
) (
  input             rst_i,
  input             clk_i,
  input [Width-1:0] din_i,
  input       [1:0] op_i,
  output            dout_o
);

  reg [Width-1:0] mux_d, reg_q;

  always @(din_i, op_i, reg_q) begin
    case (op_i)
      2'b00   : mux_d = reg_q;
      2'b01   : mux_d = din_i;
      2'b10   : mux_d = {reg_q[Width-2:0],1'b0};
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

  assign dout_o = reg_q[Width-1];

endmodule