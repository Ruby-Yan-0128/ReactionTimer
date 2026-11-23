`timescale 1ns / 1ns

module basys_ssd(
    input logic clk, // 100MHz system clock
    input logic rst, // Active High reset
    input logic [6:0] ssd_in [3:0], // The four digits to display
    output logic [3:0] an, // Which display to drive (active low)
    output logic [6:0] seg // The number to display
    
    );

    logic new_clk;  // 1kHz clock = 250 Hz per digit
    clock_divider #(.DIVISOR(100000)) clk_divider(.clk_in(clk), .rst(rst), .clk_out(new_clk));
    
    logic [1:0] counter;    // count current cycle
    always_ff @(posedge new_clk, posedge rst) begin
        if (rst) begin
            counter <= 0;
            an      <= 4'b1111;   // all digits off
            seg     <= 7'b1111111; // all segments off
        end else begin  
        case (counter)
        0: begin
            seg <= ssd_in[0];
            an <= 4'b1110;      
        end
        1: begin
            seg <= ssd_in[1];
            an <= 4'b1101;
        end
        2: begin
            seg <= ssd_in[2];
            an <= 4'b1011;
        end 
        3: begin
            seg <= ssd_in[3];
            an <= 4'b0111;
        end
        default: begin 
            seg <= 7'b1111111;
            an <= 4'b1111;
        end
        endcase
        counter <= counter + 1;     // one digit displayed at a time
        end 
   end
            
    
    
endmodule
