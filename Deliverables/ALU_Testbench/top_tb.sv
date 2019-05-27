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
module top_tb;
	import MIPS_pkg::*;

	parameter CLK_PERIOD = 10;
    bit clk_en = 0;

    // Instantiate the interface for the design
    bfm 	bfm_h();
	tester 	tester_h();

    // Instantiate the DUV
    alu duv(
    .a(bfm.src1),      // src1
    .b(bfm.src1),      // src2
    .cmd(bfm.cmd),    // function sel
    .r(bfm.result)       // result
);


	initial
	begin
		
		$finish;

	end

endmodule
