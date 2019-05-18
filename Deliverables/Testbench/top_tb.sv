//////////////////////////////////////////////////////////////////////////
// 	CSM_tb.sv
//	ECE 593 - Fundamentals of Pressilicon Validation
//	Alex Olson
//	Nurettin Can Orbegi
//	Matty Baba Allos
//	Final Project - Deterministic Testbench Design
// 	----------------------------------------------------
// 	Description: Deterministic testbench design to show DUV is working
//////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
`include "../rtl/mips_16_defs.v"
`include "generator.sv"
module top_tb;
	import MIPS_pkg::*;
	
	parameter CLK_PERIOD = 10;
    bit clk_en = 0;
	
    // Instantiate the interface for the design
    mipsIF mif();

    // Drive the clock if it's enabled
    always #(CLK_PERIOD/2)
        mif.clk = clk_en ?  ~mif.clk : mif.clk;
		
	
	// Enables clock generator
    task enable_clock();
        clk_en = 1;
    endtask : enable_clock

    // Instantiate the DUV
    mips_16_core_top duv (
        .clk(mif.clk),
        .rst(mif.rst),
        .pc(mif.pc)
    );

	// Task fills the instruction memory of processor
    task fill_inst_mem();
        $readmemb("instructions.txt", duv.IF_stage_inst.imem.rom);
    endtask : fill_inst_mem

    // task fill_data_mem();
        // $readmemb("data.txt", duv.MEM_stage_inst.dmem.ram);
    // endtask : fill_data_mem

	// Task fills registers with random numbers
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
		generator	generator_i; 		// Create generator object
		generator_i =  new();
		generator_i.generateTestFile(); // Generate instruction file
		fill_inst_mem();				// Fill the memory with that file
		enable_clock(); 				// after writing instructions into the instruction memory, enable the clock generator
		mif.reset();					// Reset the processor
		// loadRandomRegisterValues();
	end

endmodule