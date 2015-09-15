`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:45:43 08/05/2015 
// Design Name: 
// Module Name:    maqEst 
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
module maq_Digitales(Sensor_Temp_i,Sensor_Humo_i, CLK_clk_i, RST_rst_i, variablealerta_o, variableestado_o, Led1_o, Led2_o, Led3_o);

   input Sensor_Temp_i,Sensor_Humo_i,CLK_clk_i,RST_rst_i; // entradas y salidas de la maquina de estados	 
	output reg [6:0] variablealerta_o, variableestado_o;
	output reg Led1_o, Led2_o, Led3_o; 
	 
	 
	 
	reg [1:0] est_act;
	reg [1:0] est_prox; 
	parameter E0=2'b00, E1=2'b01, E2=2'b10, E3=2'b11; // estados y su numeracion correspondiente
		
	always @ (posedge CLK_clk_i ) 
		begin
			if (RST_rst_i) 
				est_act <= E0;
				
					
			else 
				est_act <= est_prox;
		end
			
			
			
		// las transiciones

	always @ (*) 
		begin
			est_prox <= est_act;
			
			case (est_act) // instrucciones a realizarse en cada uno de los estados
		
				E0:
					begin
				
						if (Sensor_Temp_i && ~Sensor_Humo_i)
							est_prox <= E1;
						
						else if (~Sensor_Temp_i && Sensor_Humo_i)
							est_prox <= E2;
					
						else if (Sensor_Temp_i && Sensor_Humo_i)
							est_prox <= E3;
						
						else 
							est_prox <= E0;
							begin
								variablealerta_o <= 7'b1000000;
								variableestado_o <= 7'b1000000;
								// variables de leds
								Led1_o <= 1'b0;  
								Led2_o <= 1'b0;
								Led3_o <= 1'b0;
							end						
						
					end
				
				E1:
					begin
				
						if (~Sensor_Temp_i && ~Sensor_Humo_i)
							est_prox <= E0;
						
						else if (~Sensor_Temp_i && Sensor_Humo_i)
							est_prox <= E2;
					
						else if (Sensor_Temp_i && Sensor_Humo_i)
							est_prox <= E3;
						
						else 
							est_prox <= E1;
							begin
								variablealerta_o <= 7'b0000111;
								variableestado_o <= 7'b1111001;
								Led1_o <= 1'b1;  
								Led2_o <= 1'b0;
								Led3_o <= 1'b0;
							end
						
					end
				
				E2:
					begin
				
						if (~Sensor_Temp_i && ~Sensor_Humo_i)
							est_prox <= E0;
						
						else if (Sensor_Temp_i && ~Sensor_Humo_i)
							est_prox <= E1;
					
						else if (Sensor_Temp_i && Sensor_Humo_i)
							est_prox <= E3;
						
						else 
							est_prox <= E2;
							begin
								variablealerta_o <= 7'b0001011;
								variableestado_o <= 7'b0100100;
								Led1_o <= 1'b0;  
								Led2_o <= 1'b1;
								Led3_o <= 1'b0;
							end
						
					end
				
				E3:
					begin
				
						if (Sensor_Temp_i && ~Sensor_Humo_i)
							est_prox <= E1;
							
						else if (~Sensor_Temp_i && Sensor_Humo_i)
							est_prox <= E2;
						
						else if (~Sensor_Temp_i && ~Sensor_Humo_i)
							est_prox <= E0;
							
						else 
							est_prox <= E3;
							begin
								variablealerta_o <= 7'b0001000;
								variableestado_o <= 7'b0110000;
								Led1_o <= 1'b0;  
								Led2_o <= 1'b0;
								Led3_o <= 1'b1;
							end
					
					end
											
			endcase
			
		end
		
endmodule
