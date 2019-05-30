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

`include "generator.sv"
`timescale 1ns/1ps
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

    
    assign mif.registers = duv.register_file_inst.reg_array;
    tb.fill_ins_mem(duv.IF_stage_inst.imem.rom)
    

endmodule
