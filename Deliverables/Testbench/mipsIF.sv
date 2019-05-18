//////////////////////////////////////////////////////////////////////////
// 	CSM_tb.sv
//	ECE 593 - Fundamentals of Pressilicon Validation
//	Alex Olson
//	Nurettin Can Orbegi
//	Matty Baba Allos
//	Final Project - Interface for testbench
// 	----------------------------------------------------
// 	Description: Required interface to drive DUV
//////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "../rtl/mips_16_defs.v"
interface mipsIF();
	import MIPS_pkg::*;
    parameter CLK_PERIOD = 10;

    bit                          clk=0;
    bit                          rst=0;
    logic  [`PC_WIDTH-1:0]       pc;

    // Added internal signals to port list for interface attachment for verification
                                                         // output_signal --> input_signal
    // logic                        pipeline_stall_n;       // hazard_detection --> IF_stage, ID_stage
    // logic    [5:0]               branch_offset_imm;      // ID_stage --> IF_stage
    // logic                        branch_taken;           // ID_stage --> IF_stage
    // logic    [15:0]              instruction;            // IF_stage --> ID_stage
    // logic    [56:0]              ID_pipeline_reg_out;    // ID_stage --> EX_stage
    // logic    [37:0]              EX_pipeline_reg_out;    // EX_stage --> MEM_stage
    // logic    [36:0]              MEM_pipeline_reg_out;   // MEM_stage --> WB_stage
    
    // logic    [2:0]               reg_read_addr_1;        // ID_stage --> register_file
    // logic    [2:0]               reg_read_addr_2;        // ID_stage --> register_file
    // logic    [15:0]              reg_read_data_1;        // register_file --> ID_stage
    // logic    [15:0]              reg_read_data_2;        // register_file --> ID_stage
    // logic    [2:0]               decoding_op_src1;       // ID_stage --> hazard_detection
    // logic    [2:0]               decoding_op_src2;       // ID_stage --> hazard_detection
    // logic    [2:0]               ex_op_dest;             // EX_stage --> hazard_detection
    // logic    [2:0]               mem_op_dest;            // MEM_stage --> hazard_detection
    // logic    [2:0]               wb_op_dest;             // WB_stage --> hazard_detection
    // logic                        reg_write_en;           // WB_stage --> register_file
    // logic    [2:0]               reg_write_dest;         // WB_stage --> register_file
    // logic    [15:0]              reg_write_data;         // WB_stage --> register_file

	opcode_t opcode;	// opcodes
	bit [2:0] rd;		// Destination register
	bit [2:0] rs1;		// Source register 1
	bit [2:0] rs2;		// Source register 2
	bit [2:0] zeros;	// Zero offset  

	// Reset operation
    task reset();
        rst = 0;
        repeat (10) @(posedge clk);
        rst = 1;
        repeat (10) @(posedge clk);
        rst = 0;
    endtask
   

endinterface : mipsIF