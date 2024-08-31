module counter_ip #(
  parameter Width = 8
) (
  input              clk_i,
  input              rst_i,
  input              ena_i,
  output [Width-1:0] q_o
);

  reg  [Width-1:0] reg_q;
  wire [Width-1:0] sum_d;

  assign sum_d = reg_q + 1;

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      reg_q <= 0;
    end else if (ena_i) begin
      reg_q <= sum_d;
	end
  end

  assign q_o = reg_q;

endmodule