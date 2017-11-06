`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2017 13:49:10
// Design Name: 
// Module Name: digital_clock
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module digital_clock(
  input clock,
    input reset,
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g,
    output dp,
    output [7:0]an
    );
  
reg [3:0]first; //register for the first digit     ( millisecond's values (unit's place) )
reg [3:0]second; //register for the second digit   ( millisecond's values (10's place) )
reg [3:0]third; //register for the third digit     ( second's values (unit's place) )
reg [3:0]fourth; //register for the fourth digit   ( second's values (10's place) )
reg [3:0]fifth; //register for the fifth digit     ( minutes values (unit's place) )
reg [3:0]sixth; //register for the sixth digit     ( minutes values (10's place) )
reg [3:0]seventh; //register for the seventh digit ( hours values (unit's place) )
reg [3:0]eighth; //register for the eighth digit   ( hours values (10's place) )

reg [21:0] delay; //register to produce delay
wire test;
//reg [26:0] delay1 = 27'h5F5E100;


always @ (posedge clock or posedge reset)
 begin
  if (reset)
   delay <= 0;
  else
   delay <= delay + 1;
 end
 
assign test = delay[19]; //stores the delay part


always @ (posedge test or posedge reset)
 begin
  if (reset) begin
   first <= 0;
   second <= 0;
   third <= 0;
   fourth <= 0;
   fifth <= 4'd8;       //load the minutes values (unit's place) (0-9)
   sixth <= 4'd4;       //load the minutes values (10's place) (0-5)
   seventh <= 4'd5;     //load the hours values (unit's place) (0-9)
   eighth <= 4'd1;      //load the hours values (10's place) (0-2)
  end
   else if (first==4'd9) begin  
    first <= 0;
     if (second == 4'd9) begin 
      second <= 0;
       if (third == 4'd9) begin 
        third <= 0;
        if (fourth == 4'd5 ) begin
          fourth <= 0;
          if (fifth == 4'd9) begin
            fifth <= 0;
            if (sixth == 4'd5) begin
            sixth <= 0;
              if (seventh == 4'd3) begin
                seventh <= 0;
                if (eighth == 4'd2)
                eighth <= 0; 
      else
       eighth <= eighth + 1; 
       end 
       else
       seventh <= seventh + 1;
       end
       else
       sixth <= sixth + 1;
       end 
      else
       fifth <= fifth + 1;
       end 
       else
       fourth <= fourth + 1;
       end 
       else
       third <= third + 1;
       end 
       else
       second <= second + 1;
       end 
   else
    first <= first + 1;
  end
  
//Multiplexing circuit below

localparam N = 18;

reg [N-1:0]count;

always @ (posedge clock or posedge reset)
 begin
  if (reset)
   count <= 0;
  else
   count <= count + 1;
 end

reg [6:0]sseg;
reg [7:0]an_temp;
always @ (*)
 begin
  case(count[N-1:N-3])
   
   3'b000 : 
    begin
     sseg = first;
     an_temp = 8'b11111110;
    end
   
   3'b001:
    begin
     sseg = second;
     an_temp = 8'b11111101;
    end
   
   3'b010:
    begin
     sseg = third; 
     an_temp = 8'b11111011;
    end
    
   3'b011:
    begin
     sseg = fourth; 
     an_temp = 8'b11110111;
    end

    3'b100:
    begin
     sseg = fifth; 
     an_temp = 8'b11101111;
    end

    3'b101:
    begin
     sseg = sixth; 
     an_temp = 8'b11011111;
    end

    3'b110:
    begin
     sseg = seventh; 
     an_temp = 8'b10111111;
    end

    3'b111:
    begin
     sseg = eighth; 
     an_temp = 8'b01111111;
    end
  endcase
 end
assign an = an_temp;

reg [6:0] sseg_temp; 
always @ (*)
 begin
  case(sseg)
   4'd0 : sseg_temp = 7'b1000000; //0
   4'd1 : sseg_temp = 7'b1111001; //1
   4'd2 : sseg_temp = 7'b0100100; //2
   4'd3 : sseg_temp = 7'b0110000; //3
   4'd4 : sseg_temp = 7'b0011001; //4
   4'd5 : sseg_temp = 7'b0010010; //5
   4'd6 : sseg_temp = 7'b0000010; //6
   4'd7 : sseg_temp = 7'b1111000; //7
   4'd8 : sseg_temp = 7'b0000000; //8
   4'd9 : sseg_temp = 7'b0010000; //9
   default : sseg_temp = 7'b0111111; //dash
  endcase
 end
assign {g, f, e, d, c, b, a} = sseg_temp; 
assign dp = 1'b1; //we dont need the decimal here so turn all of them off

endmodule