///////////////////////////////////////////////////////////////////////////////////
// [Filename]       uart_tx.sv
// [Project]        uart_ip
// [Author]         Julisa Verdejo
// [Language]       Verilog 2005 [IEEE Std. 1364-2005]
// [Created]        2024.06.22
// [Description]    UART Transmitter Module.
// [Notes]          This code uses an oversamplig of 16.
//                  Asynchronous active high reset signal
//                  The number of stop bits can be set to 1, 1.5, or 2.
//                  This code does not consider the parity bit.
// [Status]         Stable
///////////////////////////////////////////////////////////////////////////////////

module uart_tx #(
    parameter WordLength   = 8,
    parameter StopBitTicks = 16
) (
    input            clk_i,
    input            rst_i,
    input            start_tx_i,
    input            sample_tick_i,
    input      [7:0] din_i,
    output           tx_o,
    output reg       tx_done_tick_o
);

  localparam [1:0]
    IDLE  = 2'b00,
    START = 2'b01,
    DATA  = 2'b10,
    STOP  = 2'b11;
  
  reg [1:0] state_reg, state_next;
  reg [3:0] sample_tick_counter_q, sample_tick_counter_d;
  reg [2:0] data_bit_counter_q,    data_bit_counter_d;
  reg [7:0] data_shift_buffer_q,   data_shift_buffer_d;
  reg tx_q, tx_d;

  always @(posedge clk_i, posedge rst_i) begin
    if (rst_i) begin
      state_reg             <= IDLE;
      sample_tick_counter_q <= 0;
      data_bit_counter_q    <= 0;
      data_shift_buffer_q   <= 0;
      tx_q                  <= 1'b1;
    end else begin
      state_reg             <= state_next;
      sample_tick_counter_q <= sample_tick_counter_d;
      data_bit_counter_q    <= data_bit_counter_d;
      data_shift_buffer_q   <= data_shift_buffer_d;
      tx_q                  <= tx_d;
    end
  end

  always @(*) begin
    state_next            = state_reg;
    tx_done_tick_o        = 1'b0;
    sample_tick_counter_d = sample_tick_counter_q;
    data_bit_counter_d    = data_bit_counter_q;
    data_shift_buffer_d   = data_shift_buffer_q;
    tx_d                  = tx_q;
    case (state_reg)
      IDLE: begin
        tx_d = 1'b1;
        if (start_tx_i) begin
          state_next            = START;
          sample_tick_counter_d = 0;
          data_shift_buffer_d   = din_i;
        end
      end
      START: begin
        tx_d = 1'b0;
        if (sample_tick_i) begin
          if (sample_tick_counter_q == 15) begin
            state_next            = DATA;
            sample_tick_counter_d = 0;
            data_bit_counter_d    = 0;
          end else begin
            sample_tick_counter_d = sample_tick_counter_q + 1;
          end
        end
      end
      DATA: begin
        tx_d = data_shift_buffer_q[0];
        if (sample_tick_i) begin
          if (sample_tick_counter_q == 15) begin
            sample_tick_counter_d = 0;
            data_shift_buffer_d   = data_shift_buffer_q >> 1;
            if (data_bit_counter_q == (WordLength - 1)) begin
              state_next = STOP;
            end else begin
              data_bit_counter_d = data_bit_counter_q + 1;
            end
          end else begin
            sample_tick_counter_d = sample_tick_counter_q + 1;
          end
        end
      end
      STOP: begin
        tx_d = 1'b1;
        if (sample_tick_i) begin
          if (sample_tick_counter_q == (StopBitTicks - 1)) begin
            state_next     = IDLE;
            tx_done_tick_o = 1'b1;
          end else begin
            sample_tick_counter_d = sample_tick_counter_q + 1;
          end
        end
      end
    endcase
  end

  assign tx_o = tx_q;

endmodule
