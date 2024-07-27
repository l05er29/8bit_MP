`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.07.2024 16:53:00
// Design Name: 
// Module Name: three_x_one_mux
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


module three_x_one_mux(a,b,c,
                       d,
                       s,o);
input [1:0] s; input [7:0] a,b,c;
input [7:0] d;
output reg [7:0] o;
always @ *
begin
 case (s)
  2'b00: o=a;
  2'b01: o=b;
  2'b10: o=c;
  2'b11: o=d;
 endcase
end
endmodule
