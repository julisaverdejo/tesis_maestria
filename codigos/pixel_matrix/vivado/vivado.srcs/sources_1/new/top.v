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
    input          miso_i,
    output         mosi_o,
    output         dclk_o,
    output         cs_o,
    //output [7:0]   dout_o,
    output         tx_o,
	output  [2:0]  row_o,
	output  [2:0]  col_o,	
    output         eos_o
);

  wire [10:0] dvsr = 11'd54;           // 115200 baudrate
  localparam fpga_freq = 100_000_000;  // 100 MHz
  localparam db_baud = 1_000;          // 10 ms debounce time
  
  localparam  [7:0] cmd_i = 8'b10010111;    // Canal 0
  localparam  [7:0] kmax_i = 8'd39;         // Periodo de 800ns | kmax = (t*F_FPGA - 1)/2 
  localparam [25:0] delay_mux_i = 26'd99999; //1ms
  
  wire tick;
  wire tx_done;
  wire start_tx;
  wire ena_cnt_row, ena_cnt_col, ena_cnt_ram, ena_cnt;
  wire [2:0] cnt_row, cnt_col;
  wire cnt;
  wire [5:0] cnt_ram;
  wire [7:0] tx_data;
  wire [15:0] ram_out;
  wire sel;
  wire st_spi;
  wire [15:0] doutspi;
  wire [11:0] dspi;
  wire eospi;
  wire we;
  
  assign doutspi = {4'b0000,dspi};
  assign row_o = cnt_row;
  assign col_o = cnt_col;

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
    .dout_o(),
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

  count_time_mux #(
    .Width(26)
  ) mod_delay_mux (
    .rst_i(rst_i),
    .clk_i(clk_i),
    .h_i(ena_cnt),
    .kmax_i(delay_mux_i),
    .slow_clk_o(cnt)
  );

  counter_ip #(
    .Width(3)
  ) counter_ip_row (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.ena_i(ena_cnt_row),
	.q_o(cnt_row)
  );
  
  counter_ip #(
    .Width(3)
  ) counter_ip_col (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.ena_i(ena_cnt_col),
	.q_o(cnt_col)
  );  
  
  ram_ip #(
    .Width(16)
  ) ram_ip_inst (
    .clk_i(clk_i),
    .we_i(we),
    .addr_i(cnt_ram),
    .dinram_i(doutspi),
    .doutram_o(ram_out)
  );

  fsm_pixel fsm_pixel_inst (
    .rst_i(rst_i),
    .clk_i(clk_i),
    .tick_i(tick),
    .eospi_i(eospi),
    .tx_done_i(tx_done),
    .cnt_row_i(cnt_row),
    .cnt_col_i(cnt_col),
    .cnt_ram_i(cnt_ram),
	.cnt_i(cnt),
    .st_spi_o(st_spi),
    .stx_o(start_tx),
    .ena_cnt_row_o(ena_cnt_row),
    .ena_cnt_col_o(ena_cnt_col),
    .ena_cnt_ram_o(ena_cnt_ram),
	.ena_cnt_o(ena_cnt),
    .we_o(we),
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
  
  spi_write_read spi_w_r_inst (
  .rst_i(rst_i),
  .clk_i(clk_i),
  .strc_i(st_spi),
  .cmd_i(cmd_i),
  .kmax_i(kmax_i),
  .miso_i(miso_i),
  .mosi_o(mosi_o),
  .dout_o(dspi),
  .dclk_o(dclk_o),
  .cs_o(cs_o),
  .eoc_o(eospi)
);

endmodule
