module ram_ip #(
  parameter Width = 16
) (
    input              clk_i,
	input              we_i,
	input  [5:0]       addr_i,
	input  [Width-1:0] dinram_i,
	output [Width-1:0] doutram_o
);

  reg [Width-1:0] ram [63:0];

  always @(posedge clk_i) begin
    if (we_i)
	  ram[addr_i] <= dinram_i;
	end

  assign doutram_o = ram[addr_i];

endmodule