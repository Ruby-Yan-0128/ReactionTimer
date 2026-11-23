`timescale 1ns / 1ns

module clock_divider #(parameter DIVISOR=100000) 
(input logic clk_in,    // input clock (100 MHz)
input logic rst,    // Active high reset
output logic clk_out    // output clock (default 1kHz)

    );
    
    localparam HALF = DIVISOR / 2; 
    logic [$clog2(HALF)-1:0] counter;
    always_ff @(posedge clk_in) begin
        if (rst) begin 
            counter <= 0; 
            clk_out = 0;
        end else if (counter == HALF - 1) begin     // 1 cycle of clk_out = DIVISOR cycles of clk_in
            counter <= 0; 
            clk_out <= ~clk_out;    // flip clk_out for half cycle 
        end else begin
            counter <= counter + 1;     // number of cycles of clk_in
        end
   end
     
endmodule
