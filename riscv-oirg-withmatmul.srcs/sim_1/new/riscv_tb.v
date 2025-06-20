`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 07.12.2023 15:59:39
// Design Name:
// Module Name: riscv_tb
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module riscv_tb;


`define clockPeriod 1;

  // Define parameters (replace with actual values)
  localparam SUPPORT_MULDIV = 1;
  localparam SUPPORT_SUPER = 0;
  localparam SUPPORT_MMU = 0;
  localparam SUPPORT_LOAD_BYPASS = 1;
  localparam SUPPORT_MUL_BYPASS = 1;
  localparam SUPPORT_REGFILE_XILINX = 0;
  localparam EXTRA_DECODE_STAGE = 0;
  localparam MEM_CACHE_ADDR_MIN = 32'h80000000;
  localparam MEM_CACHE_ADDR_MAX = 32'h8fffffff;

  // Inputs
  reg clk;
  reg rst;
  wire [31:0] mem_d_data_rd_i;
  wire mem_d_accept_i;
  wire mem_d_ack_i;
  //reg mem_d_error_i;
  //reg [10:0] mem_d_resp_tag_i;
  wire mem_i_accept_i;
//  wire mem_i_valid_i;
  //reg mem_i_error_i;
  wire [31:0] mem_i_inst_i;
  //wire intr_i;
 // wire [31:0] reset_vector_i;
  //wire [31:0] cpu_id_i;

  // Outputs
  wire [31:0] mem_d_addr_o;
  wire [31:0] mem_d_data_wr_o;
  wire mem_d_rd_o;
  wire [3:0] mem_d_wr_o;
  wire mem_d_cacheable_o;
  wire [10:0] mem_d_req_tag_o;
  wire mem_d_invalidate_o;
  wire mem_d_writeback_o;
  wire mem_d_flush_o;
  wire mem_i_rd_o;
  wire mem_i_flush_o;
  wire mem_i_invalidate_o;
  wire [31:0] mem_i_pc_o;

  // Instantiate the module under test
  riscv_core uut (
	.clk_i(clk), 
  .rst_i(rst), 
  .mem_d_data_rd_i(mem_d_data_rd_i),
  .mem_d_accept_i(mem_d_accept_i),
  .mem_d_ack_i(mem_d_ack_i),
  .mem_d_error_i(1'b0),            
  .mem_d_resp_tag_i(11'd0),         
  .mem_i_accept_i(mem_i_accept_i),
  .mem_i_valid_i(1'b1),          
  .mem_i_error_i(1'b0),            
  .mem_i_inst_i(mem_i_inst_i),
  .intr_i(1'b0),                   
  .reset_vector_i(32'h00000000), 
  .cpu_id_i(32'h00000000), 

    .mem_d_addr_o(mem_d_addr_o), //mem access data address
    .mem_d_data_wr_o(mem_d_data_wr_o), //address mem data write
    .mem_d_rd_o(mem_d_rd_o), //read from memory
    .mem_d_wr_o(mem_d_wr_o), //write to memory
    .mem_d_cacheable_o(mem_d_cacheable_o),
    .mem_d_req_tag_o(mem_d_req_tag_o), //not used tag
    .mem_d_invalidate_o(mem_d_invalidate_o), //not used
    .mem_d_writeback_o(mem_d_writeback_o),//not used
    .mem_d_flush_o(mem_d_flush_o), //not used
    .mem_i_rd_o(mem_i_rd_o),
    .mem_i_flush_o(mem_i_flush_o),//not used
    .mem_i_invalidate_o(mem_i_invalidate_o),//not used
    .mem_i_pc_o(mem_i_pc_o)
  );


 
 
  instruction_memory instructions(
      .clk_i(clk),
      .reset_i(rst),
      .accept(mem_i_accept_i),
      .iaddr_i(mem_i_pc_o),
      .ird_i(mem_i_rd_o),
      .irdata_o(mem_i_inst_i)
  );
 
memory data_memory(
  	.clk_i(clk),
  	.reset_i(rst),
  	.accept(mem_d_accept_i),
  	.acknowledge(mem_d_ack_i),
  	.daddr_i(mem_d_addr_o),
  	.dwdata_i(mem_d_data_wr_o),
  	.drdata_o(mem_d_data_rd_i),
  	.drd_i(mem_d_rd_o),
  	.dbe_w(mem_d_wr_o) 

  );

 
      initial begin
 		 clk = 0;
 		 rst  = 1;
 		 #  `clockPeriod ;
 		 #  `clockPeriod  ;
 		 rst  = 0;
		 
 		 $display("Displaying Data Written to memory");

    		 
		 
      end


    initial begin
   	 forever begin
   	 # `clockPeriod;
   	 clk = ~clk ;
   	 end
    end

endmodule
