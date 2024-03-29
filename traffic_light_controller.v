`timescale 1ns/1ps
//  will add delay, by repeat loop. 
`define delay_yellow_to_red 3 
`define delay_red_to_green 2

module traffic_sx(clk, rst, highway, country_road, x);
input wire clk, rst;
input wire x; 

output reg [1:0] highway,country_road;

parameter red=2'b00, yellow=2'b01, green=2'b10; //for lights
parameter   s0=3'd0, //highway_green      country_road_red
            s1=3'd1, //highway_yellow     country_road_red
            s2=3'd2, //highway_red        country_road_red
            s3=3'd3, //highway_red        country_road_yellow
            s4=3'd4; //highway_red        country_road_green

reg [2:0] state;
reg [2:0] next_state;

always@(posedge clk)
if (rst) state<=0;
else state<=next_state;

always@(state) begin //defining states
    case (state)
    s0: begin 
    highway=green;  
    country_road=red;    
    end
    
    s1: begin 
    highway=yellow; 
    country_road=red;    
    end
    s2: begin 
    highway=red;    
    country_road=red;    
    end
    s3: begin 
    highway=red;    
    country_road=green;  
    end
    s4: begin 
    highway=red;    
    country_road=yellow; 
    end
    endcase
    end //end state

always@(state, x) begin //fsm
    case (state)
    s0: begin 
    if(x) 
    next_state=s1; 
    else 
    next_state=s0; 
    end
    s1: begin 
    repeat(`delay_yellow_to_red) @(posedge clk) 
    next_state=s1; 
    next_state=s2; 
    end
    s2: begin 
    repeat(`delay_red_to_green) @(posedge clk)  
    next_state=s2;
    next_state=s3; 
    end
    s3: begin
    if (x) 
    next_state=s3; 
    else next_state=s4; 
    end
    s4: begin repeat(`delay_yellow_to_red) @(posedge clk) 
    next_state=s4; 
    next_state=s0; 
    end
    default: next_state=s0;
    endcase
    end//fsm end
endmodule
