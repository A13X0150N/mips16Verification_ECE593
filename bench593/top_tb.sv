////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "../rtl/mips_16_defs.v"
module top_tb;
	import MIPS_pkg::*;
    // Instantiate the interface for the design
    mipsIF mif();

    parameter CLK_PERIOD = 10;
    bit clk_en = 1;

    // Drive the clock
    always #(CLK_PERIOD/2)
        mif.clk = clk_en ?  ~mif.clk : mif.clk;

    // mipsIF 		mif();
	generator	generator_i	(mif);	

    // Instantiate the DUV
    mips_16_core_top duv (
        .clk(mif.clk),
        .rst(mif.rst),
        .pc(mif.pc)
    );

    task fill_inst_mem();
        $readmemh("instructions.txt", duv.IF_stage_inst.imem.rom);
    endtask : fill_inst_mem

    task fill_data_mem();
        $readmemh("data.txt", duv.MEM_stage_inst.dmem.ram);
    endtask : fill_data_mem

    task enable_clock();
        clk_en = 1;
    endtask : enable_clock

    task disable_clock();
        clk_en = 0;
    endtask : disable_clock

endmodule