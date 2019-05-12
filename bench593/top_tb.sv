////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
`include "../rtl/mips_16_defs.v"
module mips_16_core_top_tb_0_v;

    // Inputs
    reg clk;
    reg rst;

    // Outputs
    wire [`PC_WIDTH-1:0] pc;
    
    parameter CLK_PERIOD = 10;
    always #(CLK_PERIOD/2) 
        clk =~clk;

    
    // Instantiate the Unit Under Test (UUT)
    mips_16_core_top uut (
        .clk(clk), 
        .rst(rst), 
        .pc(pc)
    );
    
   
endmodule

