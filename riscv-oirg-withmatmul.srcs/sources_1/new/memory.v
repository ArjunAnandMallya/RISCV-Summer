`timescale 1ns / 1ps


module memory (
    	input               	clk_i,
    	input               	reset_i,
    	output reg          	accept,
    	output reg          	acknowledge,
    	input   [31:0]   daddr_i,
    	input   [31:0]   dwdata_i,
    	output reg [31:0]   drdata_o,
    	input               	drd_i,
    	input   [3:0]   dbe_w

);

    	localparam ADDR_BITS = 10;
    	reg [31:0]  data_mem [0:(2**ADDR_BITS)-1];
    	wire [ADDR_BITS-1:0] word_address = daddr_i[ADDR_BITS+1:2];


    	wire write_request = |dbe_w;
    	always @(posedge clk_i) begin

    	if (write_request) begin
            	if (dbe_w[0]) data_mem[word_address][7:0]   <= dwdata_i[7:0];
            	if (dbe_w[1]) data_mem[word_address][15:8]  <= dwdata_i[15:8];
            	if (dbe_w[2]) data_mem[word_address][23:16] <= dwdata_i[23:16];
            	if (dbe_w[3]) data_mem[word_address][31:24] <= dwdata_i[31:24];
            	$display("[%t] Writ to 0x%h, data 0x%h, mask 0b%b", $time, daddr_i, dwdata_i, dbe_w);
    	end
    	if (drd_i) begin
            	drdata_o <= data_mem[word_address];
    	end
    end


    	reg request_pending_q;

    	always @(posedge clk_i) begin
    	if (reset_i) begin
            	accept <= 1'b1;                       	 
            	acknowledge <= 1'b0;
            	request_pending_q <= 1'b0;
    	end else begin
            	acknowledge <= 1'b0;

            	if (request_pending_q) begin
            	acknowledge <= 1'b1;
            	request_pending_q <= 1'b0;
            	accept <= 1'b1;
            	end else if (accept && (drd_i || write_request)) begin
            	request_pending_q <= 1'b1;
            	accept <= 1'b0;
            	end
    	end
    end

endmodule




 
