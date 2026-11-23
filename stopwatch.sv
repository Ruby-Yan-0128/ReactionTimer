`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2026 01:24:20 PM
// Design Name: 
// Module Name: stopwatch
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


module stopwatch(
    input logic clk,         // System clock (100MHz)
    input logic rst,         // Active high reset
    input logic start_watch, // When high, the watch counts
    output logic [$clog2(10000)-1:0] elapsed_time // Time in ms (needs to hold up to 9999)

    );
    logic new_clk;
    clock_divider clk_divider(.clk_in(clk), .rst(rst), .clk_out(new_clk));
    always @(posedge new_clk, posedge rst) begin
        if (rst) 
            elapsed_time <= 0; 
        else if (start_watch && elapsed_time < 9999) begin 
            elapsed_time <= elapsed_time + 1;
        end
    end       
endmodule
