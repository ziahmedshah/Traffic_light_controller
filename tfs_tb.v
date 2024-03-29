`timescale 1ns/1ps
module tb_traffic_sx();

reg clk, rst, x;
wire [1:0] h, c;

// Instantiate the module
traffic_sx uut (
    .clk(clk),
    .rst(rst),
    .highway(h),
    .country_road(c),
    .x(x)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Reset generation
initial begin
    rst = 1;
    #10;
    rst = 0;
end

// Stimulus for x
initial begin
    x = 0;
    #20 x = 1;  // x high for 20ns
    #30 x = 0;  // x low for 30ns
    #30 x = 1;  // x high for 30ns
    #20 x = 0;  // x low for 20ns
    #50 $finish;  // end simulation
end

// Monitor outputs
always @(h, c) begin
    $display("Time = %0t, h = %b, c = %b", $time, h, c);
end

endmodule

