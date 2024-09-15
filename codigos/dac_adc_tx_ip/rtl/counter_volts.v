// Author: Julisa Verdejo Palacios
// Name: counter_volts.v
//
// Description: 

module counter_volts #(
  parameter Width = 5
) (
  input              rst_i,
  input              clk_i,
  input        [1:0] opc1_i,
  output [Width-1:0] count_o
);

  reg [Width-1:0] mux_d, reg_q;

  always @(opc1_i, reg_q) begin
    case (opc1_i)
      2'b00   : mux_d = 5'd0;
      2'b01   : mux_d = reg_q;
      2'b10   : mux_d = reg_q + 5'd1;
      //2'b10   : mux_d = reg_q + 12'd819;	  
      2'b11   : mux_d = 0;
      default : mux_d = 0;
    endcase
  end
  
  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i)
      reg_q <= 5'd0;
    else
      reg_q <= mux_d;
  end

  assign count_o = reg_q;
  
endmodule