`timescale 1ns / 1ps

module binary_to_ssd(
    input logic [$clog2(10000)-1:0] binary_in, // up to 9999
    output logic [6:0] display_out [3:0] // encodes 4 arrays of 7 bits

    );
    
    logic [3:0] digits [3:0];
    always_comb begin 
         digits[0] = (binary_in / 1) % 10; 
         digits[1] = (binary_in / 10) % 10; 
         digits[2] = (binary_in / 100) % 10; 
         digits[3] = (binary_in / 1000) % 10;
    end 
    
    sevenSegDigit ones(.digit(digits[0]), .displayBits(display_out[0]));
    sevenSegDigit tens(.digit(digits[1]), .displayBits(display_out[1])); 
    sevenSegDigit hundreds(.digit(digits[2]), .displayBits(display_out[2])); 
    sevenSegDigit thousands(.digit(digits[3]), .displayBits(display_out[3])); 
    
endmodule
