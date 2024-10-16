/*


*/
module SPM_tb;
	localparam SIZE = 32;
	reg clk;
	reg rst;
	reg load;
	reg[SIZE-1:0] x;
	reg[SIZE-1:0] y;
	reg[SIZE*2-1:0] p;
	wire p_msb;
	
	SPM dut(
		.clk(clk),
		.rst(rst),
		.y(y[0]),
		.X(x),
		.p(p_msb)
	);


	always @(posedge clk, posedge rst)
		if(rst) p <= 0;
		else p<={p_msb,p[SIZE*2-1:1]};
	
	always @(posedge clk, posedge rst)
		if(rst) y <= 0;
		else y <= {1'b0, y[31:1]};
		
	always #10 clk = ~clk;

	reg [SIZE*2-1:0] expected;

	initial begin
		$dumpvars(0, SPM_tb);
		clk = 0;
		rst = 1;
		load = 0;
		#78;
		@(posedge clk);
		rst = 0;
		
		for (integer i = 0; i < 20; i = i + 1) begin
			@(negedge clk);
			x = $random & 'h7FFF_FFFF;
			y = $random & 'h7FFF_FFFF;
			expected = x * y;//$signed(x) * $signed(y);
			$display("%h * %h", x, y);
			@(posedge clk);
			load = 1;
			@(posedge clk);
			load = 0;
			#(SIZE * 20 * 2); // 2 * bits * clock cycle duration
			
			$display("expected %h_%h, got %h_%h (%s)", expected[63:32], expected[31:0], p[63:32], p[31:0], expected==p ? "ok " : "err");
		end
		$finish;
	end
endmodule

