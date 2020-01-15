////////////////////////////////////////////////////////////////
//
// project  : uart
// file     : transmitter.v
// function : interface rs232
// created  : 01.07.2012
// modifed  : 22.08.2019
// 
////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps

/*
uart_tx 
#(
	.base_freq 		(base_freq		),
	.uart_speed 	(uart_speed		),
	.word_width		(word_width 	)
)
	uart_tx_inst
(
    .clk            (clk			), // in,  u[1],
    .rst            (rst			), // in,  u[1],
    .tx_byte		(tx_byte		), // in,  u[1],
    .load           (tx_start		), // in,  u[1],
    .txd            (tx				),	
    .tx_done		(tx_done		) 	
);
*/

module uart_tx
#(
	parameter base_freq 	= 100_000_000,
	parameter uart_speed 	= 10_000_000,
	parameter word_width 	= 8
)
( 
    input   wire               	 			clk,
    input   wire               	 			rst,
    input   wire    [ word_width-1 : 0 ]	tx_byte,
    input   wire                			load,
    output  wire                			txd,
    output  wire                			tx_done
);

function integer clogb2 (input integer bit_depth);              
begin                                                           
for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
  bit_depth = bit_depth >> 1;                                 
end                                                           
endfunction  

localparam 	start_bit 	= 1;
localparam 	stop_bit 	= 1;
localparam	takt		=   base_freq/uart_speed;
localparam	lg_takt		=	clogb2(takt);
localparam	lg_wd		=	clogb2(word_width+start_bit+stop_bit);

reg     [ word_width 	: 0 ]   r_shift = {(word_width+1){1'b1}};
reg     [ word_width-1 	: 0 ]   r_byte	= 'd0;
reg     [ lg_takt-1 	: 0 ]   r_count	= 'd0;
reg                 			r_load	= 'd0;
reg 	[lg_wd-1:0] 			r_cnt_bits = word_width+start_bit+stop_bit;

assign txd 		= r_shift[0];
assign tx_done 	= r_count == takt && r_cnt_bits == word_width+start_bit+stop_bit-1;

//cnt transmitted bits
always @ (posedge clk)
begin
	
	 if(rst)
		r_cnt_bits <= word_width+start_bit+stop_bit;
	 else
	 if(r_load) 
		r_cnt_bits <= 'd0;
	else
	if(r_cnt_bits == word_width+start_bit+stop_bit)
		r_cnt_bits <= r_cnt_bits;
	else
	if(r_count == takt)
		r_cnt_bits <= r_cnt_bits + 1'b1;
	
	
end

always @ (posedge clk)
begin

    if (rst || r_count == takt || r_load) 
		r_count<=1'b0;  //сброс счетчика по достижении takt_1 
    else 
		r_count<=r_count+1'b1;								  				
    
    r_byte	<=	tx_byte;
    r_load	<=	load;

//=============================transmitter=======================================================
	if(rst) 
		r_shift <= {(word_width+1){1'b1}};
	else
    if (r_load==1'b1) 
		r_shift<={r_byte,1'b0};
    else 
	if (r_load==1'b0 & r_count==(takt)) 
		r_shift<={1'b1,r_shift[8:1]};
//===============================================================================================

end	

endmodule
