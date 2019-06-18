//////////////////////////////////////////////////////////////////////////
// 	MIPS_coverage.sv
//	ECE 593 - Fundamentals of Pressilicon Validation
//	Alex Olson
//	Nurettin Can Orbegi
//	Matty Baba Allos
//	Final Project - Coverage
// 	----------------------------------------------------
// 	Description: Operation, source registers and other signal coverages defined in this module
//////////////////////////////////////////////////////////////////////////
import MIPS_pkg::*;

class MIPS_coverage;

	virtual mipsIF mif;
	
	covergroup valid_ops @(posedge mif.clk);

	R_type : coverpoint mif.opcode {
			bins NOP = {NOP};
			bins ADD = {ADD};
			bins SUB = {SUB	};
			bins AND = {AND	};
			bins OR	 = {OR	};
			bins XOR = {XOR	};
			bins SL	 = {SL	};
			bins SR	 = {SR	};
			bins SRU = {SRU	};
			}

	I_type : coverpoint mif.opcode {
			bins ADDI	 = {ADDI};
			bins LD		 = {LD	};
			bins ST		 = {ST	};
			bins BZ	 	 = {BZ	};
			}

	endgroup


   covergroup registers @(posedge mif.clk);
	destination : coverpoint mif.rd 
				{
					bins zeros = {'b000};
					bins ones = {'b111};
					bins others = {['b001:'b110]};
				}

	source1		: coverpoint mif.rs1 
				{
					bins zeros = {'b000};
					bins ones = {'b111};
					bins others = {['b001:'b110]};
				}

	source2		: coverpoint mif.rs2 
				{
					bins zeros = {'b000};
					bins ones = {'b111};
					bins others = {['b001:'b110]};
				}

	offset_val	:  coverpoint mif.offset;
	
	reg_inputs	: cross destination, source1, source2;
	
	endgroup

	
	function new(virtual mipsIF mif_i);
		mif = mif_i;
		registers = new();
		valid_ops = new();
	endfunction : new
	
endclass