`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:50:21 08/05/2015 
// Design Name: 
// Module Name:    display7seg 
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
module sevenseg(
 input CLK_clk_i, RST_rst_i,
 input [6:0] in0_i, in3_i,  //salidas de los 7 segmentos a utilizar
 output a_o, b_o, c_o, d_o, e_o, f_o, g_o, dp_o, //catodos de cada 7 segmentos
 output [3:0] an_o   // enable o anodos de cada 7 segmentos
 );
 
localparam N = 18;
 
reg [N-1:0]count; //contador de 18 bits
 
always @ (posedge CLK_clk_i or posedge RST_rst_i)
	begin
 
		if (RST_rst_i)
			begin
				count <= 0;
				
			end
	
		else
			count <= count + 1'b1;
	end
 
reg [6:0]sseg; //registro para los catodos internamente
reg [3:0]an_temp; //registro para los anodos internamente
 
always @ (*)
	begin
		case(count[N-1:N-2]) // cuenta usando los 2 MSB's del contador
    
		2'b00 :  //cuando los 2 MSB's son 00 activar el cuarto display
			begin
				sseg = in0_i;
				an_temp = 4'b1110;
			end
    
		2'b01:  //cuando los 2 MSB's son 01 activar el tercer display
			begin
				sseg = 7'b0111111;
				an_temp = 4'b1101;
			end
    
		2'b10:  //cuando los 2 MSB's son 10 activar el segundo display
			begin
				sseg = 7'b0111111;
				an_temp = 4'b1011;
			end
     
		2'b11:  //cuando los 2 MSB's son 11 activar el primer display
			begin
				sseg = in3_i;
				an_temp = 4'b0111;
			end
		endcase
	end
	
assign an_o = an_temp;
 
 

assign {g_o, f_o, e_o, d_o, c_o, b_o, a_o } = sseg; // se concadenan las salidas al registro

 
assign dp_o = 1'b1; //nunca se utiliza el punto decimal por lo que se mantiene apagado
 
 
endmodule
//http://simplefpga.blogspot.com/2012/07/seven-segment-led-multiplexing-circuit.html


