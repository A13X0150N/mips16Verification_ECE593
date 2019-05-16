module generator(mipsIF mif);

	import MIPS_pkg::*;

	// bit [2:0] op_code;
	bit [2:0] rd;
	bit [2:0] rs1;
	bit [2:0] rs2;
	bit [2:0] zeros;

	function REG_gnrt();
		bit [2:0] reg_addr;
		reg_addr = $random;
		return reg_addr;
	endfunction:REG_gnrt
	
	function IMM_gnrt();
		bit [2:0] imm_value;
		imm_value = $random;
		return imm_value;
	endfunction

	// R-Type Instructions
	function NOP_gnrt();
		mif.opcode = NOP;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = REG_gnrt();
		mif.zeros = 3'b000;
	endfunction :NOP_gnrt

	function ADD_gnrt();
		mif.opcode = ADD;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = REG_gnrt();
		mif.zeros = 3'b000;
	endfunction :ADD_gnrt

	function SUB_gnrt();
		mif.opcode = SUB;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = REG_gnrt();
		mif.zeros = 3'b000;
	endfunction:SUB_gnrt

	function AND_gnrt();
		mif.opcode = AND;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = REG_gnrt();
		mif.zeros = 3'b000;
	endfunction:AND_gnrt

	function OR_gnrt();
		mif.opcode = OR;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = REG_gnrt();
		mif.zeros = 3'b000;
	endfunction:OR_gnrt

	function XOR_gnrt();
		mif.opcode = XOR;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = REG_gnrt();
		mif.zeros = 3'b000;
	endfunction:XOR_gnrt

	function SL_gnrt();
		mif.opcode = SL;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = REG_gnrt();
		mif.zeros = 3'b000;
	endfunction:SL_gnrt

	function SR_gnrt();
		mif.opcode = SR;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = REG_gnrt();
		mif.zeros = 3'b000;
	endfunction:SR_gnrt

	function SRU_gnrt();
		mif.opcode = SRU;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = REG_gnrt();
		mif.zeros = 3'b000;
	endfunction:SRU_gnrt

	// I-Type Instructions
	function ADDI_gnrt();
		mif.opcode = ADDI;
		mif.rd = REG_gnrt();
		mif.rs1 = REG_gnrt();
		mif.rs2 = IMM_gnrt();
		mif.zeros = 3'b000;
	endfunction : ADDI_gnrt
	
	function LD_gnrt();
		mif.opcode = LD;
		mif.rd = REG_gnrt();	
		mif.rs1 = IMM_gnrt(); // Base address
		mif.rs2 = IMM_gnrt(); // Offset
		mif.zeros = 3'b000;	
	endfunction : LD_gnrt
	
	function ST_gnrt();
		mif.opcode = ST;
		mif.rd = REG_gnrt();	
		mif.rs1 = IMM_gnrt(); // Base address
		mif.rs2 = IMM_gnrt(); // Offset
		mif.zeros = 3'b000;	
	endfunction : ST_gnrt 
	
	function BZ_gnrt();
		mif.opcode = ST;
		mif.rd = 3'b000;
		mif.rs1 = REG_gnrt();
		mif.rs2 = IMM_gnrt(); // Offset
		mif.zeros = 3'b000;	
	endfunction : BZ_gnrt
	
	int f;
	int counter;
	
	initial begin
		f = $fopen("instructions.txt","w");
		
				$display("%d",counter);
				// R-Type
				// OR_gnrt();
				// always@(posedge mif.clk);
				// ADD_gnrt();
				// always@(posedge mif.clk);
				// SUB_gnrt();
				// always@(posedge mif.clk);
				// AND_gnrt();
				// always@(posedge mif.clk);
				// OR_gnrt();
				// #10;
				// XOR_gnrt();
				// #10;
				// SL_gnrt();
				// #10;
				// SR_gnrt();
				// #10;
				// SRU_gnrt();
				// I-Type
				// ADDI_gnrt();
				// #10;
				// LD_gnrt();
				// #10;
				// ST_gnrt();
				// #10;
				// BZ_gnrt();
				// #10;
				$fwrite(f,"%b",{mif.opcode,mif.rd,mif.rs1,mif.rs2,mif.zeros});
				
		$fclose(f);
	end

endmodule