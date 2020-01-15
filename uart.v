`timescale 1 ns / 1 ps
`default_nettype wire

/* 
uart #
(
	.base_freq (base_freq	),
	.uart_speed (uart_speed	),
	.word_width(word_width 	)
)
uart_inst
(
	.rx			(rx			),
	.tx			(tx			),
	.byte_rx	(byte_rx	),
	.rx_done	(rx_done	),
	.byte_tx	(byte_tx	),
	.start_tx	(start_tx	)
	
);
 */
module uart #(
	parameter base_freq 	= 100_000_000,
	parameter uart_speed 	= 115200,
	parameter word_width 	= 8,
	parameter use_tx	 	= 0,
	parameter use_debug	 	= 0
)
(
	input 	wire						clk,
	input 	wire						rst,
				
	input 	wire						rx,
	output 	wire 						tx,
	
	output 	wire	[word_width-1:0] 	rx_byte,	
	output 	wire						rx_done,	
	output 	wire						tx_done,	
	input 	wire	[word_width-1:0] 	tx_byte,	
	input 	wire						tx_start,

	output 	wire						out_1_val,		
	output 	wire						out_2_val,		
	output 	wire						out_3_val		

);

wire w_rxd_filtered;

uart_filter_rx
    uart_filter_rx_inst
    (
    .clk            (clk			), //in,  u[ 1] clk
    .rst            (rst			), //in,  u[ 1] clk
    .rxd_extern     (rx				), //in,  u[ 1] external rxd
    .rxd_filtered   (w_rxd_filtered	)  //out, u[ 1] rxd filtered data
);

uart_rx 
#(
	.base_freq 		(base_freq		),
	.uart_speed 	(uart_speed		),
	.word_width		(word_width 	)
)
	uart_rx_inst
(	 
    .clk            (clk			), 	// in,  u[1],
    .rst            (rst			), 	// in,  u[1],
    .rxd            (w_rxd_filtered	), 	// in,  u[1], 
    .rx_byte		(rx_byte		), 	// in,  u[1],
    .byte_valid     (rx_done		) 	// in,  u[1],
);

if(use_tx) begin
uart_tx 
#(
	.base_freq 		(base_freq		),
	.uart_speed 	(uart_speed		),
	.word_width		(word_width 	)
)
	uart_tx_inst
(
    .clk            (clk			), 	// in,  u[1],
    .rst            (rst			), 	// in,  u[1],
    .tx_byte		(tx_byte		), 	// in,  u[1],
    .load           (tx_start		), 	// in,  u[1],
    .txd            (tx				),	
    .tx_done		(tx_done		) 	
);
end
else begin
assign tx 		= 1'b1;
assign tx_done 	= 1'b0;
end

if(use_debug) begin
assign out_1_val = (rx_byte == 8'd1 && rx_done) ? 1'b1 : 1'b0;
assign out_2_val = (rx_byte == 8'd2 && rx_done) ? 1'b1 : 1'b0;
assign out_3_val = (rx_byte == 8'd3 && rx_done) ? 1'b1 : 1'b0;
end
else begin
assign out_1_val = 1'b0;
assign out_2_val = 1'b0;
assign out_3_val = 1'b0;
end

endmodule
