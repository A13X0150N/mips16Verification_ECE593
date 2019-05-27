//////////////////////////////////////////////////////////////////////////
// 	CSM_tb.sv
//	ECE 593 - Fundamentals of Pressilicon Validation
//	Alex Olson
//	Nurettin Can Orbegi
//	Matty Baba Allos
//	Final Project - Tester
// 	----------------------------------------------------
// 	Description: 
//////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
import MIPS_pkg::*;
	
class tester;
	virtual mips_bfm bfm;
	
	function new(virtual mips_bfm b);
		bfm = b;
	endfunction

	// Generates source
	function [15:0] src_gen();
		bit [15:0] src;
		bit [2:0] probablity;
		probablity = $random
		case(probablity)
		3'd0: src = 16'h0000;
		3'd1: src = 16'hFFFF;
		default: src = $random;
		return src;
	endfunction:src_gen
	
	// Selects random function
	// Needs to check single cycle ops, 
	// multicycle ops then single -> multi && Multi -> single
	function [2:0] func_sel();
		bit [2:0] cmd;
		cmd = $random;
		return cmd
	endfunction:func_sel
	
	task LoadSrcs();
		bfm.src1 = src_gen();
		bfm.src2 = src_gen();
		bfm.cmd = func_sel();
	endtask:loadSrcs
	
	task execute(int iterationLimit);
		repeat(iterationLimit) begin:repeatloop
			loadSrcs();
		end:repeatloop
	endtask:execute

endclass:tester