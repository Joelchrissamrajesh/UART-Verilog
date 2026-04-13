`timescale 1ns/1ps
module baud_rate_generator (
    input  wire clock,
    input  wire reset,
    output reg  enb_tx,
    output reg  enb_rx
);

parameter CLK_FREQ  = 100_000_000; // 100 MHz
parameter BAUD_RATE = 1_000_000;

localparam DIV_TX = CLK_FREQ / BAUD_RATE;
  localparam DIV_RX = CLK_FREQ / (16 * BAUD_RATE);

reg [31:0] cnt_tx;
reg [31:0] cnt_rx;

always @(posedge clock) begin
    if (reset) begin
        cnt_tx <= 0;
        enb_tx <= 0;
    end else if (cnt_tx == DIV_TX-1) begin
        cnt_tx <= 0;
        enb_tx <= 1'b1;
    end else begin
        cnt_tx <= cnt_tx + 1;
        enb_tx <= 1'b0;
    end
end

always @(posedge clock) begin
    if (reset) begin
        cnt_rx <= 0;
        enb_rx <= 0;
    end else if (cnt_rx == DIV_RX-1) begin
        cnt_rx <= 0;
        enb_rx <= 1'b1;
    end else begin
        cnt_rx <= cnt_rx + 1;
        enb_rx <= 1'b0;
    end
end

endmodule
