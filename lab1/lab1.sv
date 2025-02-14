// CSEE 4840 Lab 1: Run and Display Collatz Conjecture Iteration Counts
//
// Spring 2023
//
// By: Haoming Ma, Roshan Prakash
// Uni: hm3070,rp3187
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
   assign go = ~KEY[3]; 

   logic [11:0] displayed_n;
   logic [21:0] slow_counter;
logic [15:0] cc;
   always_ff @(posedge clk) begin
        slow_counter <= slow_counter + 1;
   end
   logic [2:0] cumulate_counter = 0;
//    always_ff @ (posedge ~KEY[0]) begin
//      if (slow_counter == 0) displayed_n <= displayed_n + 1;
//    end
//    always_ff @ (posedge ~KEY[1]) begin
//      if (slow_counter == 0) displayed_n <= displayed_n - 1;
//    end
   logic [31:0] inputt;
   logic [7:0] addr;
//    assign start = done ?   {4'b0, addr} :  inputt[11:0];
   assign cc = count;
   assign displayed_n = inputt[11:0] + {4'b0, addr};
   always_ff @ (posedge clk) begin
        if(done) 
            start <= {4'b0, addr};
        else
            start <= inputt[11:0];
        
        if (~KEY[2] || go) begin
            inputt <= n;
            addr <= 0;
            // displayed_n <= n;
        end else begin
            if (KEY[0] && KEY[1] ) cumulate_counter <= 0;

	    if( (~KEY[0] || ~KEY[1]) && slow_counter == 0 && cumulate_counter != 3) cumulate_counter <= cumulate_counter + 1;
            if (~KEY[0] && slow_counter == 0 && cumulate_counter == 0 && addr != 255) addr <= addr + 1;
            if (~KEY[1] && slow_counter == 0 && cumulate_counter == 0 && addr != 0) addr <= addr - 1; // Decrement
            
            if (~KEY[0] && slow_counter == 0 && cumulate_counter == 3 && addr != 255) addr <= addr + 1; // Increment
            if (~KEY[1] && slow_counter == 0 && cumulate_counter == 3 && addr != 0) addr <= addr - 1; // Decrement
        end
   end

//    always_ff @ (posedge clk) begin
//     cc <= count;
//     // start <= {20'b0, displayed_n};
//    end


   assign n =  SW[9:0];  // 10-bit switch input mapped to 12-bit n
   //assign start = {20'b0, displayed_n}; // Start range from n

   range #(256, 8) r (.*); // Only one instance of the range module
   
   //assign cc = count - 1;

   hex7seg h5(displayed_n[11:8], HEX5);
   hex7seg h4(displayed_n[7:4], HEX4);
   hex7seg h3(displayed_n[3:0], HEX3);
   hex7seg h2(cc[11:8], HEX2);
   hex7seg h1(cc[7:4], HEX1);
   hex7seg h0(cc[3:0], HEX0);

   assign LEDR = 10'b1110000111;
  
endmodule
