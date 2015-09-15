`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:17:20 09/07/2015 
// Design Name: 
// Module Name:    PS2 
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
module PS2(
	input wire CLK_clk_i, RST_rst_i,
	input wire ps2d_i, ps2c_i, rx_en_i,
	output reg rx_done_tick_o,
	output wire [7:0] dout_o,
	output wire lsb_o
 );
	
	//declaracion de los estados para la maquina de recepcion
	localparam [1:0]
	idle = 2 'b00,
	dps = 2'b01,
	load = 2'b10;
	
	//declaracion de señales
	reg [1:0] state_reg , state_next ;
	reg [7:0] filter_reg;
	wire [7:0] filter_next ;
	reg f_ps2c_i_reg ;
	wire f_ps2c_i_next ;
	reg [3:0] n_reg , n_next ;
	reg [10:0] b_reg, b_next;
	wire fall_edge ;
			
	
					
	//filtro y detector de caida del reloj para el ps2
	
	always @ (posedge CLK_clk_i , posedge RST_rst_i)
		if(RST_rst_i)
			begin
				filter_reg <= 0 ;
				f_ps2c_i_reg <= 0;
			end
		else
			begin
				filter_reg <= filter_next ;
				f_ps2c_i_reg <= f_ps2c_i_next ;
			end

		assign filter_next = {ps2c_i, filter_reg [7:1]};
		assign f_ps2c_i_next = (filter_reg==8'b11111111) ? 1'b1 :
									(filter_reg==8'b00000000) ? 1'b0 :
									f_ps2c_i_reg;
		assign fall_edge = f_ps2c_i_reg & ~f_ps2c_i_next;
			
		//maquina de estados y registros de datos
		
		always @(posedge CLK_clk_i , posedge RST_rst_i )
			if (RST_rst_i)
				begin
					state_reg <= idle;
					n_reg <= 0;
					b_reg <= 0;
				end
			else
				begin
					state_reg <= state_next ;
					n_reg <= n_next;
					b_reg <= b_next;
				end
		
		//FSMD next-state logic
		always @*
		begin
			state_next <= state_reg;
			rx_done_tick_o <= 1'b0;
			n_next <= n_reg;
			b_next <= b_reg;
		case(state_reg)
			idle:
				if(fall_edge & rx_en_i)
					begin
					// shift al bit de inicio
						b_next <= {ps2d_i, b_reg [10:1]};
						n_next <= 4'b1001;
						state_next <= dps;
					end
			dps: //paquete de 8 bits, bit de paridad y de parada
				if(fall_edge)
					begin
						b_next <= {ps2d_i, b_reg [10:1]};
					if(n_reg==0)
						state_next <= load;
					else
						n_next <= n_reg - 1'b1;
					end
			load: // 1 reloj extra para el ultimo desplazamiento
				begin
					state_next <= idle;
					rx_done_tick_o <= 1'b1;
				end
		endcase
		end
	// salida
	assign dout_o = b_reg[8:1]; // bits de datos
	assign lsb_o = b_reg[0];
		
endmodule 
