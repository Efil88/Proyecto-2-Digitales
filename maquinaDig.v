`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ITCR
// Engineer: Alejandro Ugarte, Juan Carlos Montero
// 
// Create Date:    21:41:25 08/05/2015 
// Design Name:    
// Module Name:    maquinaDig 
// Project Name: 
// Target Devices: nexys 3
// Tool versions: 
// Description: programa que modela una maquina de estados en lenguaje de alto nivel
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module maquinaDig(
		
		input cristal_i, RST_rst_i,
		input wire ps2d_i, ps2c_i,
		output wire [3:0] an_o,
		output wire Led1_o, Led2_o, Led3_o,
		output wire a_o, b_o, c_o, d_o, e_o, f_o, g_o, dp_o,
		output wire rx_done_tick_o,
		output wire [7:0] dout_o,
		output wire lsb_o
		 
);
 
		wire [6:0] variablealerta_o, variableestado_o;
		//wire CLK_clk_o;
		wire Sensor_Temp_o,Sensor_Humo_o;		

/*/ Instanciacion del CLOCK        Se cambio el reloj utilizado para el sistema en este proyecto
CLK_clk_o100 CLK_clk_o100 (
    .cristal_i(cristal_i), 
    .RST_rst_i(RST_rst_i), 
    .CLK_clk_o(CLK_clk_o)
);*/

// Instanciacion de la maquina de estados
maq_Digitales maq_Digitales (
    .Sensor_Temp_i(Sensor_Temp_o), 
    .Sensor_Humo_i(Sensor_Humo_o), 
    .CLK_clk_i(cristal_i), 
    .RST_rst_i(RST_rst_i), 
	 .variablealerta_o(variablealerta_o), 
    .variableestado_o(variableestado_o), 
    .Led1_o(Led1_o), 
    .Led2_o(Led2_o), 
    .Led3_o(Led3_o)
);
 
// Instanciacion del 7 segmentos
sevenseg sevenseg (
    .CLK_clk_i(cristal_i), 
    .RST_rst_i(RST_rst_i), 
    .in0_i(variableestado_o),  
    .in3_i(variablealerta_o), 
    .a_o(a_o), 
    .b_o(b_o), 
    .c_o(c_o), 
    .d_o(d_o), 
    .e_o(e_o), 
    .f_o(f_o), 
    .g_o(g_o), 
    .dp_o(dp_o), 
    .an_o(an_o)
);

// Instanciacion del modulo de recepcion
PS2 PS2 (
    .CLK_clk_i(cristal_i), 
    .RST_rst_i(RST_rst_i), 
    .ps2d_i(ps2d_i), 
    .ps2c_i(ps2c_i), 
    .rx_en_i(1'b1), 
    .rx_done_tick_o(rx_done_tick_o), 
    .dout_o(dout_o),
	 .lsb_o(lsb_o)
    );
	 
// Instanciacion del modulo de filtrado
filtradofinal filtradofinal (
    .dout_o(dout_o), 
    .CLK_clk_i(cristal_i), 
    .RST_rst_i(RST_rst_i), 
    .Sensor_Temp_o(Sensor_Temp_o), 
    .Sensor_Humo_o(Sensor_Humo_o)
    );

	 
endmodule 