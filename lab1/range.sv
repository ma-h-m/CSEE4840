module range
   #(parameter
     RAM_WORDS = 16,            // Number of counts to store in RAM
     RAM_ADDR_BITS = 4)         // Number of RAM address bits
   (input logic         clk,    // Clock
    input logic 	go,     // Read start and start testing
    input logic [31:0] 	start,  // Number to start from or count to read
    output logic 	done,   // True once memory is filled
    output logic [15:0] count); // Iteration count once finished

   logic 		cgo;    // "go" for the Collatz iterator
   logic                cdone;  // "done" from the Collatz iterator
   logic [31:0] 	n;      // number to start the Collatz iterator

// verilator lint_off PINCONNECTEMPTY
   
   // Instantiate the Collatz iterator
   collatz c1(.clk(clk),
	      .go(cgo),
	      .n(n),
	      .done(cdone),
	      .dout());

   logic [RAM_ADDR_BITS - 1:0] 	 num;         // The RAM address to write
   logic 			 running = 0; // True during the iterations

   /* Replace this comment and the code below with your solution,
      which should generate running, done, cgo, n, num, we, and din */
    logic [15:0] cnt; 
    logic [15:0] cc;
   always_ff @(posedge clk) begin
      if (go) begin
         running <= 1;
         n <= start;
         num <= 0;
         din <= 0;
         cgo <= 1;
         cnt <= 0;
         we <= 0;
         cc <= 0;
      end else if (running) begin
         cgo <= 0;

        //  we <= 0;
         if (cdone) begin
            din <= cnt - 1;
            cdone <= 0;
            // we <= 1;
            // cnt <= 0;
            if (cc == RAM_WORDS) begin
            // if (cc == 3) begin
            // if (cc == RAM_ADDR_BITS'(RAM_WORDS - 1)) begin
               running <= 0;
               done <= 1;
               we <= 0;
            end else begin
               we <= 1; 
               
               n <= start + { {16{1'b0}}, cc } + 1;
               cc <= cc + 1;
               num <= cc[RAM_ADDR_BITS - 1:0];
               cgo <= 1;
               cnt <= 0;
            end
         end else begin
            cnt <= cnt + 1;
         end
      end else begin
         we <= 0;
         done <= 0;
      end
   end



   /* Replace this comment and the code above with your solution */

   logic 			 we;                    // Write din to addr
   logic [15:0] 		 din;                   // Data to write
   logic [15:0] 		 mem[RAM_WORDS - 1:0];  // The RAM itself
   logic [RAM_ADDR_BITS - 1:0] 	 addr;                  // Address to read/write

   assign addr = we ? num: start[RAM_ADDR_BITS-1:0];
   
   always_ff @(posedge clk) begin
      if (we) mem[addr] <= din;
      count <= mem[addr];      
   end

endmodule
	     
