`timescale 1ns/1ps
module receiver (
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    input  wire       clk_en,   // 16x baud enable
    input  wire       rdy_clr,
    output reg        rdy,
    output reg [7:0]  data_out
);

parameter IDLE  = 2'b00;
parameter START = 2'b01;
parameter DATA  = 2'b10;
parameter STOP  = 2'b11;

reg [1:0] state;
reg [3:0] sample;
reg [2:0] bit_idx;
reg [7:0] temp;

always @(posedge clk) begin
    if (rst) begin
        state    <= IDLE;
        sample   <= 0;
        bit_idx  <= 0;
        temp     <= 0;
        data_out <= 0;
        rdy      <= 0;
    end else begin

        if (rdy_clr)
            rdy <= 0;

        if (clk_en) begin
            case (state)

            IDLE: begin
                sample  <= 0;
                bit_idx<= 0;
                if (rx == 0)
                    state <= START;
            end

            START: begin
                sample <= sample + 1;
                if (sample == 7) begin   // middle of start bit
                    sample <= 0;
                    state  <= DATA;
                end
            end

            DATA: begin
                sample <= sample + 1;
                if (sample == 15) begin
                    temp[bit_idx] <= rx;
                    bit_idx <= bit_idx + 1;
                    sample <= 0;
                    if (bit_idx == 3'd7)
                        state <= STOP;
                end
            end

            STOP: begin
                sample <= sample + 1;
                if (sample == 15) begin
                    data_out <= temp;
                    rdy <= 1'b1;
                    state <= IDLE;
                    sample <= 0;
                end
            end

            endcase
        end
    end
end

endmodule
