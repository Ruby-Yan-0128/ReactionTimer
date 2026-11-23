`timescale 1ns / 1ns

module reactiontimer_top(
    input logic clk,
    input logic rst,
    input logic start_stop_btn,
    output logic led,
    output logic [3:0] an,
    output logic [6:0] seg

    );
    
    // state encodings
    typedef enum logic [1:0]{
    RESET = 2'b00, 
    SET = 2'b01, 
    GO = 2'b10, 
    SCORE = 2'b11
    } state_t; 
    state_t state, next_state;
    
    // state registers
    always_ff @(posedge clk) begin
        if (rst) 
            state <= RESET;
        else 
            state <= next_state;
    end
    
    logic btn_sync0, btn_sync1;     // setup and hold time
    logic btn_pressed, btn_prev;
    always_ff @(posedge clk) begin 
        btn_sync0 <= start_stop_btn; 
        btn_sync1 <= btn_sync0; 
        btn_prev <= btn_sync1;
    end
    assign btn_pressed = btn_sync1 & ~btn_prev;
    
    logic generate_num;
    logic [7:0] random_number;
    random_number_generator LFSR(.clk(clk), .rst(rst), .generate_num(generate_num), .random_number(random_number));
    
    logic [31:0] delay_count;
    logic delay_done;
    assign delay_done = (delay_count >= 32'd100_000_000 + {random_number, 20'd0});
    
    always_ff @(posedge clk) begin
        if (rst || state != SET) 
            delay_count <= 0;
        else 
            delay_count <= delay_count + 1;
    end
    
    // Next state logic
    always_comb begin
        next_state = state;
        case (state)
            RESET: if (btn_pressed) next_state = SET;
            SET: if (delay_done) next_state = GO;
            GO: if (btn_pressed) next_state = SCORE;
            SCORE: next_state = SCORE;
        endcase
    end
    
    // Output logic: Moore machine
    logic start_watch;
    always_comb begin
        generate_num = (state == RESET);
        start_watch = (state == GO);
        led = (state == GO);
    end
           
    logic [$clog2(10000)-1:0] reaction_time;
    logic [6:0] display_bits [3:0];
    
    stopwatch timer(.clk(clk), .rst(rst), .start_watch(state == GO), .elapsed_time(reaction_time));
    binary_to_ssd encoder(.binary_in(reaction_time),.display_out(display_bits));
    basys_ssd displayDrive (.clk(clk), .rst(rst),.ssd_in(display_bits),.an(an), .seg(seg));
    

endmodule
