///////////////////////////////////////////////////////////////////////////////////
// [Filename]       uart_tx.sv
// [Project]        top
// [Author]         Julisa Verdejo
// [Language]       Verilog 2005 [IEEE Std. 1364-2005]
// [Created]        2024.06.22
// [Description]    Basys 3 UART IP testing code.
// [Notes]          This code uses an oversamplig of 16.
// [Status]         Stable
///////////////////////////////////////////////////////////////////////////////////

module top #(
    parameter WordLength   = 8,
    parameter StopBitTicks = 16
) (
    input          clk_i,
    input          rst_i,
    input          sw_i,
    input          rx_i,
    output [7:0]  dout_o,
    output         tx_o,
    output         eos_o
);

  wire [10:0] dvsr = 11'd54;           // 115200 baudrate
  localparam fpga_freq = 100_000_000;  // 100 MHz
  localparam db_baud = 1_000;          // 10 ms debounce time
  
  wire tick;
  wire tx_done;
  wire start_tx;
  wire ena_cnt_ram;
  wire [5:0] cnt_ram;
  wire [7:0] tx_data;
  wire [15:0] ram_out;
  wire sel;

  uart_ip #(
    .WordLength  (WordLength),
    .StopBitTicks(StopBitTicks)
  ) uart_ip_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .dvsr_i(dvsr),
    .din_i(tx_data),
    .rx_i(rx_i),
    .start_tx_i(start_tx),
    .dout_o(dout_o),
    .tx_o(tx_o),
    .rx_done_tick_o(),
    .tx_done_tick_o(tx_done)
  );
  
  debouncer_ip #(
    .ClkRate(fpga_freq),
    .Baud(db_baud)
  ) debouncer_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .sw_i(sw_i),
    .db_level_o(),
    .db_tick_o(tick)
  );
 
  counter_ip #(
    .Width(6)
  ) counter_ip_ram (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.ena_i(ena_cnt_ram),
	.q_o(cnt_ram)
  );
  
  ram_ip ram_ip_inst (
    .addr_i(cnt_ram),
    .rom_o(ram_out)
  );

  fsm_pixel fsm_pixel_inst (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .tick_i(tick),
    .tx_done(tx_done),
    .count_i(cnt_ram),
    .stx_o(start_tx),
    .en_cram_o(ena_cnt_ram),
    .sel_o(sel),
    .eos_o(eos_o)
  );  
  
  mux_ip #(
  .Width(8)
) mux_ip_inst (
    .in1_i(ram_out[15:8]),
    .in2_i(ram_out[7:0]),
    .sel_i(sel),
    .mux_o(tx_data)
);
  
endmodule
