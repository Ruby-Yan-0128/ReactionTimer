`timescale 1ns / 1ns


module random_number_generator(
    input logic clk,
    input logic rst, // Active high, resets LFSR to a non-zero seed
    input logic generate_num, // When high, generate the next number
    output logic [7:0] random_number

    );
    
    logic feedback;
    assign feedback = random_number[7] ^ random_number[5] ^ random_number[4] ^ random_number[3];
    always_ff @(posedge clk) begin
        if (rst) begin 
            random_number <= 1; 
        end else 
        if (generate_num) begin
            // random_number <= random_number << 1;
            // random_number[0] <= feedback;
            random_number <= {random_number[6:0], feedback};    // cleaner code
        end
   end
   
endmodule
