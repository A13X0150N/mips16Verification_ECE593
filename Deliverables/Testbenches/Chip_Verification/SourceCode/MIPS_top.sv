//////////////////////////////////////////////////////////////////////////
// 	MIPS_top.sv
//	ECE 593 - Fundamentals of Pressilicon Validation
//	Alex Olson
//	Nurettin Can Orbegi
//	Matty Baba Allos
//	Final Project - Top module of the testbench
// 	----------------------------------------------------
// 	Description: Top module of testbench other classes are instantiated in this module
//////////////////////////////////////////////////////////////////////////


`include "MIPS_generator.sv"
`include "MIPS_reference.sv"
`include "MIPS_coverage.sv"

`timescale 1ns/1ps
module top_tb;
    import MIPS_pkg::*;

    parameter CLK_PERIOD = 10;
    bit clk_en = 0;

    // Instantiate the interface for the design
    mipsIF mif();
	
	// Coverage
	MIPS_coverage	coverage_i;
    // Generator
    MIPS_generator	generator_i;
    // Reference Model
    MIPS_reference	reference_i;
	// Scoreboard + Checker
	// MIPS_scoreboard_checker scb_chk_i;

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
    
    assign mif.duv_registers[0] = duv.register_file_inst.reg_array[0];
	assign mif.duv_registers[1] = duv.register_file_inst.reg_array[1];
	assign mif.duv_registers[2] = duv.register_file_inst.reg_array[2];
	assign mif.duv_registers[3] = duv.register_file_inst.reg_array[3];
	assign mif.duv_registers[4] = duv.register_file_inst.reg_array[4];
	assign mif.duv_registers[5] = duv.register_file_inst.reg_array[5];
	assign mif.duv_registers[6] = duv.register_file_inst.reg_array[6];
	assign mif.duv_registers[7] = duv.register_file_inst.reg_array[7];

    initial
    begin
		coverage_i = new(mif);
		generator_i = new();
		reference_i = new(mif);
		
		repeat(1000) begin : loop
			generator_i.generateTestFile();
			fill_inst_mem();
			clk_en = 1;
			mif.reset();
			reference_i.execute();
		end : loop
		$display("Generated instructions in the instruction.txt file");
		$display("Scoreboard in the scoreboard.txt file");
		$stop;
    end

endmodule