//////////////////////////////////////////////////////////////////////////
// 	MIPS_if.sv
//	ECE 593 - Fundamentals of Pressilicon Validation
//	Alex Olson
//	Nurettin Can Orbegi
//	Matty Baba Allos
//	Final Project - Interface for testbench
// 	----------------------------------------------------
// 	Description: Required interface to drive DUV
//////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "../../../DUV/mips_16_defs.v"
interface mipsIF();
	import MIPS_pkg::*;
    parameter CLK_PERIOD = 10;

    bit                          clk=0;
    bit                          rst=0;
    logic  [`PC_WIDTH-1:0]       pc;

	opcode_t opcode;	// opcodes
	bit [2:0] rd;		// Destination register
	bit [2:0] rs1;		// Source register 1
	bit [2:0] rs2;		// Source register 2
	bit [2:0] zeros;	// Zero offset
	bit	[5:0] offset;
	
	reg [15:0]  duv_registers [7:0];
	
	// Reference model signals _rm
	
	logic 	[15:0] 	InstructionMemory_rm	[255:0];
	logic   [15:0]  DataRegister_rm		  	[7:0]; 
	logic	[7:0]	PC;
	
	// Reset operation
    task reset();
        rst = 0;
        repeat (10) @(posedge clk);
        rst = 1;
        repeat (10) @(posedge clk);
        rst = 0;
    endtask


endinterface : mipsIF

