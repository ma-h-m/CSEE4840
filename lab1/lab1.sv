// CSEE 4840 Lab 1: Run and Display Collatz Conjecture Iteration Counts
//
// Spring 2023
//
// By: <your name here>
// Uni: <your uni here>

module lab1( input logic        CLOCK_50,  // 50 MHz Clock input
	     
	     input logic [3:0] 	KEY, // Pushbuttons; KEY[0] is rightmost

	     input logic [9:0] 	SW, // Switches; SW[0] is rightmost

	     // 7-segment LED displays; HEX0 is rightmost
	     output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,

	     output logic [9:0] LEDR // LEDs above the switches; LED[0] on right
	     );

   logic 			clk, go, done;   
   logic [31:0] 		start;
   logic [15:0] 		count;

   logic [11:0] 		n;
   
   assign clk = CLOCK_50;
 
   range #(256, 8) // RAM_WORDS = 256, RAM_ADDR_BITS = 8)
         r ( .* ); // Connect everything with matching names

   // Replace this comment and the code below it with your own code;
   // The code below is merely to suppress Verilator lint warnings
   logck [11:0] displayed_n;
   assgin go = KEY[3];
   logic [21:0] slow_counter;
   always_ff @(posedge clk) begin
        slow_counter <= slow_counter + 1;
   end

   always_ff @ (posedge clk) begin
        if (KEY[2]) begin
            displayed_n <= n;
        end else begin
         if (~KEY[0] && slow_counter == 0) displayed_n <= displayed_n + 1; // Increment
         if (~KEY[1] && slow_counter == 0) displayed_n <= displayed_n - 1; // Decrement
      end
   end
   assign n = {2'b00, SW};  // 10-bit switch input mapped to 12-bit n
   assign start = {20'b0, n}; // Start range from n

   range #(256, 8) r (.*); // Instantiate range module

   hex7seg h5(displayed_n[11:8], HEX5);
   hex7seg h4(displayed_n[7:4], HEX4);
   hex7seg h3(displayed_n[3:0], HEX3);
   hex7seg h2(count[11:8], HEX2);
   hex7seg h1(count[7:4], HEX1);
   hex7seg h0(count[3:0], HEX0);

   assign LEDR = 10'b1110000111;
//    assign HEX0 = {KEY[2:0], KEY[3:0]};
//    assign HEX1 = SW[6:0];
//    assign HEX2 = {(n == 12'b0), (count == 16'b0) ^ KEY[1],
// 		  go, done ^ KEY[0], SW[9:7]};
//    assign HEX3 = HEX0;
//    assign HEX4 = HEX1;
//    assign HEX5 = HEX2;
//    assign LEDR = SW;
//    assign go = KEY[0];
//    assign start = {SW[1:0], SW, SW, SW};
//    assign n = {SW[1:0], SW};
   
   
  
endmodule
