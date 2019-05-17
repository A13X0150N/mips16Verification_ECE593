////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "../rtl/mips_16_defs.v"
`include "generator.sv"
module top_tb;
	import MIPS_pkg::*;
    // Instantiate the interface for the design
    mipsIF mif();

    parameter CLK_PERIOD = 10;
    bit clk_en = 0;

    // Drive the clock
    always #(CLK_PERIOD/2)
        mif.clk = clk_en ?  ~mif.clk : mif.clk;

    // Instantiate the DUV
    mips_16_core_top duv (
        .clk(mif.clk),
        .rst(mif.rst),
        .pc(mif.pc)
    );

    task fill_inst_mem();
        $readmemb("N:/instructions.txt", duv.IF_stage_inst.imem.rom);
    endtask : fill_inst_mem

    // task fill_data_mem();
        // $readmemb("data.txt", duv.MEM_stage_inst.dmem.ram);
    // endtask : fill_data_mem

    task enable_clock();
        clk_en = 1;
    endtask : enable_clock

    task loadRandomRegisterValues();
		duv.register_file_inst.reg_array[0] = $random;
		duv.register_file_inst.reg_array[1] = $random;
		duv.register_file_inst.reg_array[2] = $random;
		duv.register_file_inst.reg_array[3] = $random;
		duv.register_file_inst.reg_array[4] = $random;
		duv.register_file_inst.reg_array[5] = $random;
		duv.register_file_inst.reg_array[6] = $random;
		duv.register_file_inst.reg_array[7] = $random;
	endtask
	
	initial
	begin
		// disable_clock();
		generator	generator_i;
		generator_i =  new();
		generator_i.generateTestFile();
		fill_inst_mem();
		enable_clock();
		mif.reset();
		// loadRandomRegisterValues();
	end

endmodule