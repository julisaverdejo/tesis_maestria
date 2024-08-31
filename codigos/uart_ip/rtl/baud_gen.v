///////////////////////////////////////////////////////////////////////////////////
// [Filename]       baud_gen.sv
// [Project]        uart_ip
// [Author]         Julisa Verdejo
// [Language]       Verilog 2005 [IEEE Std. 1364-2005]
// [Created]        2024.06.22
// [Description]    Module for generating baud rate for UART communication.
//                  Asynchronous active high reset signal
//                  Equation:
//                            dvsr_i = f_fpga/(baud_rate*16)
// [Notes]          This module supports configurable baud rates, see C++ code.
// [Status]         Stable
///////////////////////////////////////////////////////////////////////////////////

module baud_gen (
    input         clk_i,
    input         rst_i,
    input  [10:0] dvsr_i,
    output        tick_o
);

  reg  [10:0] counter_q;
  wire [10:0] counter_d;
  wire counter_done;

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      counter_q <= 11'd0;
    end else begin
      counter_q <= counter_d;
    end
  end

  assign counter_done = (counter_q == dvsr_i - 11'd1) ? 1'b1 : 1'b0;
  assign counter_d = (counter_done) ? 11'd0 : counter_q + 11'd1;

  assign tick_o = counter_done;

endmodule
