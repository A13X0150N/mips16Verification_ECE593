module generator(mipsIF mif);

	import MIPS_pkg::*;

	bit [2:0] op_code;
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
	
	initial begin
		repeat(100)
		begin
			for(int counter=0;counter<16;counter=counter+1)
			begin
				case(counter)
				// R-Type
				4'd0: NOP_gnrt();
				4'd1: ADD_gnrt();
				4'd2: SUB_gnrt();
				4'd3: AND_gnrt();
				4'd4: OR_gnrt();
				4'd5: XOR_gnrt();
				4'd6: SL_gnrt();
				4'd7: SR_gnrt();
				4'd8: SRU_gnrt();
				// I-Type
				4'd9: ADDI_gnrt();
				4'd10: LD_gnrt();
				4'd11:ST_gnrt();
				4'd12:BZ_gnrt();
				default:NOP_gnrt();
				endcase
			end
		end
	end

endmodule