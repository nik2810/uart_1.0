////////////////////////////////////////////////////////////////
//
// project  : uart
// file     : filter.v
// version  : 1.0
// function : interface rs232
// created  : 01.07.2012
// modifed  : 22.08.2019
////////////////////////////////////////////////////////////////

`timescale 1ns / 100ps
`default_nettype none

/*
filter
    filter_inst
    (
    .clk            (), //in,  u[ 1] clk
    .rst            (), //in,  u[ 1] rst
    .rxd_extern     (), //in,  u[ 1] external rxd
    .rxd_filtered   ()  //out, u[ 1] rxd filtered data
);
*/

module uart_filter_rx
(
    input   wire		clk,
    input   wire		rst,
    input   wire		rxd_extern,
    output  wire		rxd_filtered
);

(* keep="true" *)
reg     [ 1 : 0 ]   r_rxd_meta     = 0;
reg     [ 6 : 0 ]   r_filter_data  = 0;
//reg     [ 3 : 0 ]   r_sum          = 0;
reg     [ 2 : 0 ]   r_sum          = 0;
reg                 r_rxd_filtered = 0;

assign rxd_filtered = r_rxd_filtered;
 
always @(posedge clk)  
begin
    r_rxd_meta <= {r_rxd_meta[0],rxd_extern};

    r_filter_data <= {r_filter_data[5:0],r_rxd_meta[1]};

	if(rst)
		r_sum <= 'd0;
	else
		r_sum   <=( (r_filter_data[6]+r_filter_data[5])+(r_filter_data[4]+r_filter_data[3])) + ( (r_filter_data[2]+r_filter_data[1])+(r_rxd_meta[1]) );

    r_rxd_filtered <= r_sum[2];
end    
endmodule
