// CSEE 4840 Lab 1: Run and Display Collatz Conjecture Iteration Counts
//
// Spring 2023
//
// By: <your name here>
// Uni: <your uni here>
module lab1( input logic        CLOCK_50,  // 50 MHz Clock input
             
             input logic [3:0]  KEY, // Pushbuttons; KEY[0] is rightmost

             input logic [9:0]  SW, // Switches; SW[0] is rightmost

             // 7-segment LED displays; HEX0 is rightmost
             output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,

             output logic [9:0] LEDR // LEDs above the switches; LED[0] on right
             );

   logic           clk, go, done;   
   logic [31:0]    start;
   logic [15:0]    count;

   logic [11:0]    n;
   
   assign clk = CLOCK_50;
   assign go = KEY[3]; // Fixed assign syntax

   logic [11:0] displayed_n;
   logic [21:0] slow_counter;

   always_ff @(posedge clk) begin
        slow_counter <= slow_counter + 1;
   end

   always_ff @ (posedge clk) begin
        if (~KEY[2]) begin
            displayed_n <= n;
        end else begin
            if (~KEY[0] && slow_counter == 0) displayed_n <= displayed_n + 1; // Increment
            if (~KEY[1] && slow_counter == 0) displayed_n <= displayed_n - 1; // Decrement
        end
   end

   assign n = {2'b00, SW};  // 10-bit switch input mapped to 12-bit n
   assign start = {20'b0, displayed_n}; // Start range from n

   range #(256, 8) r (.*); // Only one instance of the range module
   logic [15:0] cc;
   assign cc = count - 1;

   hex7seg h5(displayed_n[11:8], HEX5);
   hex7seg h4(displayed_n[7:4], HEX4);
   hex7seg h3(displayed_n[3:0], HEX3);
   hex7seg h2(cc[11:8], HEX2);
   hex7seg h1(cc[7:4], HEX1);
   hex7seg h0(cc[3:0], HEX0);

   assign LEDR = 10'b1110000111;
  
endmodule
