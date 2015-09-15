`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:36:20 09/07/2015 
// Design Name: 
// Module Name:    filtradofinal 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module filtradofinal(dout_o, CLK_clk_i, RST_rst_i, Sensor_Temp_o, Sensor_Humo_o
    );
	 
	input wire [7:0] dout_o;
	output reg Sensor_Temp_o, Sensor_Humo_o;
	input CLK_clk_i, RST_rst_i;
	
always @(posedge CLK_clk_i)
	if (RST_rst_i)
				begin
					Sensor_Temp_o <= 0;
					Sensor_Humo_o <= 0;
				end
	else
		begin
			case (dout_o) 
	
				8'h2c:begin
					Sensor_Temp_o <= 1;
					Sensor_Humo_o <= 0;end
				8'h33:begin
					Sensor_Temp_o <= 0;
					Sensor_Humo_o <= 1;end
				8'h1c:begin
					Sensor_Temp_o <= 1;
					Sensor_Humo_o <= 1;end
				default:begin
					Sensor_Temp_o <= 0;
					Sensor_Humo_o <= 0;end
			endcase
		end
		
endmodule
