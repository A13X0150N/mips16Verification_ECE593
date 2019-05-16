////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "../rtl/mips_16_defs.v"
module top_tb;
	import MIPS_pkg::*;
    // Instantiate the interface for the design
    mipsIF 		mif();
	generator	generator_i	(mif);
	
	
    
    // Instantiate the DUV
    mips_16_core_top duv (
        .clk(mif.clk), 
        .rst(mif.rst), 
        .pc(mif.pc),
        .pipeline_stall_n(mif.pipeline_stall_n),
        .branch_offset_imm(mif.branch_offset_imm),
        .branch_taken(mif.branch_taken),
        .instruction(mif.instruction),
        .ID_pipeline_reg_out(mif.ID_pipeline_reg_out),
        .EX_pipeline_reg_out(mif.EX_pipeline_reg_out),
        .MEM_pipeline_reg_out(mif.MEM_pipeline_reg_out),
        .reg_read_addr_1(mif.reg_read_addr_1),
        .reg_read_addr_2(mif.reg_read_addr_2),
        .reg_read_data_1(mif.reg_read_data_1),
        .reg_read_data_2(mif.reg_read_data_2),
        .decoding_op_src1(mif.decoding_op_src1),
        .decoding_op_src2(mif.decoding_op_src2),
        .ex_op_dest(mif.ex_op_dest),
        .mem_op_dest(mif.mem_op_dest),
        .wb_op_dest(mif.wb_op_dest),
        .reg_write_en(mif.reg_write_en),
        .reg_write_dest(mif.reg_write_dest),
        .reg_write_data(mif.reg_write_data)
    );
    
   
endmodule

