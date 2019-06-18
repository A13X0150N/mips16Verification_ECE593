//////////////////////////////////////////////////////////////////////////
// 	MIPS_pkg.sv
//	ECE 593 - Fundamentals of Pressilicon Validation
//	Alex Olson
//	Nurettin Can Orbegi
//	Matty Baba Allos
//	Final Project - packages
// 	----------------------------------------------------
// 	Description: Package has opcodes
//////////////////////////////////////////////////////////////////////////
package MIPS_pkg;
					
	typedef enum logic[3:0]{
		NOP = 4'b0000,
		ADD = 4'b0001,
		SUB = 4'b0010,
		AND = 4'b0011,
		OR  = 4'b0100,
		XOR = 4'b0101,
		SL	= 4'b0110,
		SR	= 4'b0111,
		SRU	= 4'b1000,
		
		ADDI = 4'b1001,
		LD 	= 4'b1010,
		ST	= 4'b1011,
		BZ	= 4'b1100
	} opcode_t;
					
	// typedef struct bit[3:0] {
					// I_type_t I_type,
					// R_type_t R_type
					// } op_code_t;
					
endpackage : MIPS_pkg



