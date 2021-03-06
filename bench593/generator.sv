import MIPS_pkg::*;
	
class generator;
	
	function new();
		
	endfunction
	

	opcode_t opcode;
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
	task NOP_gnrt();
		 opcode = NOP;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = REG_gnrt();
		 zeros = 3'b000;
	endtask :NOP_gnrt

	task ADD_gnrt();
		 opcode = ADD;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = REG_gnrt();
		 zeros = 3'b000;
	endtask :ADD_gnrt

	task SUB_gnrt();
		 opcode = SUB;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = REG_gnrt();
		 zeros = 3'b000;
	endtask:SUB_gnrt

	task AND_gnrt();
		 opcode = AND;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = REG_gnrt();
		 zeros = 3'b000;
	endtask:AND_gnrt

	task OR_gnrt();
		 opcode = OR;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = REG_gnrt();
		 zeros = 3'b000;
	endtask:OR_gnrt

	task XOR_gnrt();
		 opcode = XOR;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = REG_gnrt();
		 zeros = 3'b000;
	endtask:XOR_gnrt

	task SL_gnrt();
		 opcode = SL;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = REG_gnrt();
		 zeros = 3'b000;
	endtask:SL_gnrt

	task SR_gnrt();
		 opcode = SR;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = REG_gnrt();
		 zeros = 3'b000;
	endtask:SR_gnrt

	task SRU_gnrt();
		 opcode = SRU;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = REG_gnrt();
		 zeros = 3'b000;
	endtask:SRU_gnrt

	// I-Type Instructions
	task ADDI_gnrt();
		 opcode = ADDI;
		 rd = REG_gnrt();
		 rs1 = REG_gnrt();
		 rs2 = IMM_gnrt();
		 zeros = 3'b000;
	endtask : ADDI_gnrt
	
	task LD_gnrt();
		 opcode = LD;
		 rd = REG_gnrt();	
		 rs1 = IMM_gnrt(); // Base address
		 rs2 = IMM_gnrt(); // Offset
		 zeros = 3'b000;	
	endtask : LD_gnrt
	
	task ST_gnrt();
		 opcode = ST;
		 rd = REG_gnrt();	
		 rs1 = IMM_gnrt(); // Base address
		 rs2 = IMM_gnrt(); // Offset
		 zeros = 3'b000;	
	endtask : ST_gnrt 
	
	task BZ_gnrt();
		 opcode = ST;
		 rd = 3'b000;
		 rs1 = REG_gnrt();
		 rs2 = IMM_gnrt(); // Offset
		 zeros = 3'b000;	
	endtask : BZ_gnrt
	
	int f;
	
	task generateTestFile();
		$display("into the display");
		f = $fopen("N:/instructions.txt","w");
		// f = $fopen("\\khensu\Home03\orbegi\Desktop\Final\mips16Verification_ECE593\instructions.txt","w");
		repeat(1000)
		begin
			// R-Type
			OR_gnrt();
			// @(posedge  clk);
			ADD_gnrt();
			// @(posedge  clk);
			SUB_gnrt();
			// @(posedge  clk);
			AND_gnrt();
			// @(posedge  clk);
			OR_gnrt();
			// @(posedge  clk);
			XOR_gnrt();
			// @(posedge  clk);
			SL_gnrt();
			// @(posedge  clk);
			SR_gnrt();
			// @(posedge  clk);
			SRU_gnrt();
			// @(posedge  clk);
			// I-Type
			ADDI_gnrt();
			// @(posedge  clk);
			LD_gnrt();
			// @(posedge  clk);
			ST_gnrt();
			// @(posedge  clk);
			BZ_gnrt();
			// @(posedge  clk);
			$fwrite(f,"%b\n",{ opcode, rd, rs1, rs2, zeros});
		end	
		$fclose(f);
	endtask

endclass