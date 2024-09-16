// Author: Julisa Verdejo Palacios
// Name: counter_w.v
//
// Description: Contador descendente utilizado para contar los 25 ciclos de dclk.

module counter_pwm #(
  parameter Width = 17
) (
  input         rst_i,
  input         clk_i,
  input  [2:0]  opc_i,
  output        led_o
);

  reg [Width-1:0] mux_d;
  reg [Width-1:0] reg_q = 0;

  always @(opc_i, reg_q) begin
    case (opc_i)
      3'b000   : mux_d = 17'd0;         
      3'b001   : mux_d = (reg_q < 25000) ? 1:0;
      3'b010   : mux_d = (reg_q < 50000) ? 1:0;
      3'b011   : mux_d = (reg_q < 75000) ? 1:0;
	  3'b100   : mux_d = 17'd1;
      default : mux_d = 17'd0;
    endcase
  end
  
  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i)
      reg_q <= 17'd0;
    else
		if (reg_q < 100000) begin
		  reg_q <= reg_q + 1;
		end else begin
		  reg_q <= 17'd0;
		end
  end
  
  assign led_o = mux_d;
  
endmodule