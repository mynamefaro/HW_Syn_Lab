`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2021 09:59:35 PM
// Design Name: 
// Module Name: uart
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module uart(
    input clk,
    input baud,
    input rx,
    input [7:0] data_transmit,
    input dte, // data_transmit_enable
    output tx,
    output [7:0] data_received,
    output received
    );
    
    reg en, last_rec;
    reg [7:0] data;
//    wire baud;
    wire sent;
//    assign data = (dte) ? data_transmit : data_received;
    uart_rx receiver(baud, rx, received, data_received);
    uart_tx transmitter(baud, data, en, sent, tx);
    
    always @(posedge baud) begin
        if (en) begin
            en = 0;
        end else if (~last_rec & received) begin // if received or pass enable
            en <= 1;
            data <= data_received;
        end else if (dte) begin
            en <= 1;
            data <= data_transmit;
        end
        last_rec = received;
    end
    
endmodule