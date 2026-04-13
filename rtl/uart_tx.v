`timescale 1ns/1ps
module transmitter (
    input  wire       clk,
    input  wire       rst,
    input  wire       wr_en,
    input  wire       enb,
    input  wire [7:0] data_in,
    output reg        tx,
    output wire       tx_busy
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;
  
reg [1:0] state;
reg [2:0] bit_idx;
reg [7:0] data;

assign tx_busy = (state != IDLE);

always @(posedge clk) begin
    if (rst) begin
        state   <= IDLE;
        tx      <= 1'b1; // idle high
        bit_idx <= 0;
        data    <= 0;
    end else begin
        case (state)

        IDLE: begin
            tx <= 1'b1;
            if (wr_en) begin
                data  <= data_in;
                bit_idx <= 0;
                state <= START;
            end
        end

        START: begin
            if (enb) begin
                tx <= 1'b0; // start bit
                state <= DATA;
            end
        end

        DATA: begin
            if (enb) begin
                tx <= data[bit_idx];
                if (bit_idx == 3'd7)
                    state <= STOP;
                else
                    bit_idx <= bit_idx + 1;
            end
        end

        STOP: begin
            if (enb) begin
                tx <= 1'b1; // stop bit
                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule
