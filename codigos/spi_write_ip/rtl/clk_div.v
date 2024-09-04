// Author: Julisa Verdejo Palacios
// Name: clk_div.v
//
// Description: Contador descendente que genera un timer de 400us

module clk_div #(
  parameter Width = 8
) ( 
  input             rst_i,
  input             clk_i,
  input             h_i,
  input [Width-1:0] kmax_i,
  output            slow_clk_o
);

  wire [Width-1:0] mux1;
  wire [Width-1:0] mux2_d;
  wire comp;
  reg [Width-1:0] reg_q;

  assign mux1 = (h_i) ? reg_q - 1 : reg_q;
  assign mux2_d = (comp) ? kmax_i : mux1;
  assign comp = ( reg_q == {Width{1'b0}} ) ? 1'b1 : 1'b0;

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i)
      reg_q <= 0;
    else
      reg_q <= mux2_d;
  end

  assign slow_clk_o = comp;

endmodule