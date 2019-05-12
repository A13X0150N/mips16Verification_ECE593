////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "../rtl/mips_16_defs.v"
interface mipsIF();

    parameter CLK_PERIOD = 10;

    bit                          clk=0;
    bit                          rst=0;
    logic  [`PC_WIDTH-1:0]       pc;

    // Added internal signals to port list for interface attachment for verification
    logic                        pipeline_stall_n;
    logic    [5:0]               branch_offset_imm;
    logic                        branch_taken;
    logic    [15:0]              instruction;
    logic    [56:0]              ID_pipeline_reg_out;
    logic    [37:0]              EX_pipeline_reg_out;
    logic    [36:0]              MEM_pipeline_reg_out;
    
    logic    [2:0]               reg_read_addr_1;        // register file read port 1 address
    logic    [2:0]               reg_read_addr_2;        // register file read port 2 address
    logic    [15:0]              reg_read_data_1;        // register file read port 1 data
    logic    [15:0]              reg_read_data_2;        // register file read port 2 data
    logic    [2:0]               decoding_op_src1;       // source_1 register number
    logic    [2:0]               decoding_op_src2;       // source_2 register number
    logic    [2:0]               ex_op_dest;             // EX stage destinaton register number
    logic    [2:0]               mem_op_dest;            // MEM stage destinaton register number
    logic    [2:0]               wb_op_dest;             // WB stage destinaton register number
    logic                        reg_write_en;
    logic    [2:0]               reg_write_dest;
    logic    [15:0]              reg_write_data;

    // Drive the clock
    always #(CLK_PERIOD/2) 
        clk =~clk; 
   

endinterface : mipsIF