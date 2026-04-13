`timescale 1ns/1ps
module top (
    input  wire       clk,
    input  wire       rst,
    input  wire       wr_en,
    input  wire [7:0] data_in,
    input  wire       rdy_clr,
    output wire       rdy,
    output wire       busy,
    output wire [7:0] data_out
);

wire tx_en;
wire rx_en;
wire tx_line;

baud_rate_generator brg (
    .clock(clk),
    .reset(rst),
    .enb_tx(tx_en),
    .enb_rx(rx_en)
);

transmitter txu (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .enb(tx_en),
    .data_in(data_in),
    .tx(tx_line),
    .tx_busy(busy)
);

receiver rxu (
    .clk(clk),
    .rst(rst),
    .rx(tx_line),
    .clk_en(rx_en),
    .rdy_clr(rdy_clr),
    .rdy(rdy),
    .data_out(data_out)
);

endmodule
