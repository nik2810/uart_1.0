////////////////////////////////////////////////////////////////
//
// project  : uart
// file     : receiver.v
// function : interface rs232
// created  : 01.07.2012
// modifed  : 22.08.2019
// 
////////////////////////////////////////////////////////////////

/*
uart_rx 
#(
	.base_freq 		(base_freq		),
	.spi_speed 		(spi_speed		),
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
*/

module uart_rx
#(
	parameter base_freq 	= 100_000_000,
	parameter uart_speed 	= 10_000_000,
	parameter word_width 	= 8
)
(
    input   wire                			clk,
    input   wire                			rst,
    input   wire                			rxd,
    output  wire    [ word_width-1 : 0 ]	rx_byte,
    output  wire                			byte_valid
);

function integer clogb2 (input integer bit_depth);              
begin                                                           
for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
  bit_depth = bit_depth >> 1;                                 
end                                                           
endfunction  

localparam 	start_bit 	= 1;
localparam 	stop_bit 	= 1;
localparam	takt		= base_freq/uart_speed;
localparam	takt_half	= takt/2;
localparam 	lg_takt		= clogb2(takt);
localparam 	lg_wrd_wdth	= clogb2(word_width+start_bit+stop_bit);

reg 	[1:0]					r_byte_val_ff	= 2'b0;
reg 							r_byte_val_pos	= 1'b0;

reg     [ lg_takt-1 	: 0 ]   r_rxd_freq_cnt  = 0;      
reg     [ word_width-1 	: 0 ]   r_receive_data  = 'b0;  //временный регистр для хранения данных
reg     [ word_width-1 	: 0 ]   r_data          = 'b0;  //регистр для хранения данных
reg     [ lg_wrd_wdth-1 : 0 ]   r_count_bit     = 'b0;	//счетчик количества битов
reg                 			r_byte_valid    = 0;	//сигнал приема данных 
reg                 			r_neg           = 0;	//отрицательный фронт сигнала на rxd2	//отрицательный фронт сигнала на rxd2
reg                 			r_receive       = 0;	//сигнал начала приема
reg                 			r_mid           = 0;	//импульс для подсчета битов на 3/4 бита
reg     [ 1 : 0 ]   			r_rxd_neg_front = 0;

always @ (posedge clk)
begin

	r_byte_val_ff 	<= {r_byte_val_ff[0],r_byte_valid};
	r_byte_val_pos 	<= !r_byte_val_ff[1] && r_byte_val_ff[0];

end

always @ (posedge clk)
begin

    if ( rst || r_rxd_freq_cnt==takt || ( r_neg==1'b1 && !r_receive) ) 
        r_rxd_freq_cnt <= 10'b0;												//сброс счетчика по достижении takt_1 
    else 							
	if (r_receive) 							
		r_rxd_freq_cnt <= r_rxd_freq_cnt + 1'b1;								//либо по отриц. фронту сигнала
 
    r_rxd_neg_front <= {r_rxd_neg_front[0],rxd};
    r_neg <= ( ~r_rxd_neg_front[0] && r_rxd_neg_front[1] );						//отрицательный фронт сигнала
      	  
    if ((r_rxd_freq_cnt==(takt_half) && r_receive==1'b1))  
        r_mid <= 1'b1;				                                            //импульс для подсчета битов 
    else 
        r_mid <= 1'b0;

//================================start_bit===================================	

	if(rst) begin
		r_byte_valid 	<= 1'b0;                                        
		r_data 			<= 'd0;                                        
		r_receive		<= 1'b0;
	end
	else
    if (r_neg) 
        r_receive <= 1'b1;														//начало приема по спаду					
    else 
        if( (r_count_bit==4'b0) && (r_rxd_neg_front[1]==1'b1) && (r_mid==1'b1) ) 
            r_receive<=1'b0;                                                    //rxd = 1 - ошибка в старт бите
    else 
        if ( (r_count_bit==4'd9) && (r_rxd_neg_front[1]==1'b1) && (r_mid==1'b1) ) 											 
            begin
                r_byte_valid <=1'b1;                                             //сигнал приема данных
                r_data <= r_receive_data;                                        //загрузка данных в память
                r_receive <= 1'b0;
            end 
    else
        if (r_count_bit==1'b0)
            r_byte_valid <= 1'b0;
		  								                 
//================================information================================

	if(rst) begin
		r_count_bit		 	<= 'd0;        													
		r_receive_data[7] 	<= 'd0;
		r_receive_data[6:0] <= 'd0;                     
	end
	else
    if (r_receive==1'b0) 
        r_count_bit <= 1'b0;                                                    //счетчик для подсчета битов
    else 
	if (r_mid) begin
		r_count_bit		 	<= r_count_bit+1'b1;          													
		r_receive_data[7] 	<= r_rxd_neg_front[1];
		r_receive_data[6:0] <= r_receive_data[7:1];                      //загрузка во временный регистр
	end	
										
end

assign byte_valid   =   r_byte_val_pos;	
assign rx_byte		=   r_data;

endmodule
