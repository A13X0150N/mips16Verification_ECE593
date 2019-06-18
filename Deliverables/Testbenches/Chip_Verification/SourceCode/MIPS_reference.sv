//////////////////////////////////////////////////////////////////////////
// 	MIPS_reference.sv
//	ECE 593 - Fundamentals of Pressilicon Validation
//	Alex Olson
//	Nurettin Can Orbegi
//	Matty Baba Allos
//	Final Project - Reference Design
// 	----------------------------------------------------
// 	Description: Reference design for 16-bit MIPS processor  
//////////////////////////////////////////////////////////////////////////
// Reference design 
`include "MIPS_scoreboard_checker.sv"

import MIPS_pkg::*;

class MIPS_reference; // Instruction memory depth can be parameter

logic   [15:0]  InstructionMemory   [255:0];    // Instruction memory 
logic   [15:0]  DataRegister  [7:0];            // Only 8 register

logic	[15:0] dataMemory [255:0] ;

logic   [7:0]   PC;     // Program counter
logic   [15:0]  IF_o;   // output of instruction fetch satege
logic   [70:0]  ID_o;   // output of instruction decode stage
logic   [38:0]  EX_o;   // Output of execution stage
logic   [38:0]  MEM_o;   // Output of execution stage
logic	[2:0]	id_rs1;
logic	[2:0]	id_rs2;
logic	[15:0]	IF_o_stall;
logic	[2:0] 	EX_rd;
logic	[2:0] 	MEM_rd;
logic	[2:0] 	WB_rd;
logic 			isStall = 0;
// Instantiate the interface for the design
virtual mipsIF mif;
MIPS_scoreboard_checker scb_chk_i;
// MIPS_coverage coverage_i;

function new(virtual mipsIF mif_i);
    this.PC = 0; // When new object is created, resets the PC
	this.mif = mif_i;
	// this.scb_chk_i = scb_chk_h;
endfunction : new

// Loads Instruction Memory with pre-defined instructions
function void loadInstructionMemory();
    $readmemb("instructions.txt", this.InstructionMemory);
endfunction : loadInstructionMemory

function logic [15:0] readRegister(logic [15:0] addr);
    return DataRegister[addr];
endfunction : readRegister

function void writeToRegister(logic [15:0] addr, int data);
    DataRegister[addr] = data; 
endfunction : writeToRegister

// Instruction fetch stage
task IF();
	
	bit [15:0]  CurrentIns;
	
	@ (posedge this.mif.clk);
	
	if(!this.isStall)
	begin
		
		CurrentIns = this.InstructionMemory[this.PC];
		// $display("PC: %d \nInstruction: %b", this.PC,CurrentIns);
		this.PC = this.PC + 1; // If changes on PC is needed after ID decrease by 1 to get actual value
		this.IF_o = CurrentIns;
	end
	else
	begin
		this.IF_o  = this.IF_o;
	end
	
endtask : IF

// Instruction Decode
task ID();
	bit     [15:0]  CurrentIns;
	opcode_t        opcode;	// Opcodes
	bit     [2:0]   rd;		// Destination register
	bit     [2:0]   rs1;	// Source register 1
	bit     [2:0]   rs2;  	// Source register 2
	int     rs1_val,
			rs2_val;    // Actual register values

	@ (posedge this.mif.clk);
	
	// Stall control logic
	if(!isStall)
	begin
		CurrentIns = this.IF_o;
	end
	else
	begin
		CurrentIns = this.IF_o_stall;
	end
	
	if(1'b1)
	begin
		rs1 = CurrentIns[8:6];
		rs2 = CurrentIns[5:3];
		this.id_rs1 = rs1;
		this.id_rs2 = rs2;
		$cast(opcode,CurrentIns[15:12]);
		this.mif.opcode = opcode; // set interface signal
		
		// Stall logic
		if( (opcode == ADD || opcode == SUB || opcode == AND || opcode == OR || opcode == XOR || opcode == SL || opcode == SR || opcode == SRU)	&& ((rs1 != 0 && (rs1 == this.EX_rd || rs1 == this.MEM_rd || rs1 == this.WB_rd)) || (rs2 != 0 && (rs2 == this.EX_rd || rs2 == this.MEM_rd || rs2 == this.WB_rd))) )
		begin
			this.isStall = 1;
			this.ID_o = 0;
			this.IF_o_stall = this.IF_o;
		end
		else if( (opcode == ADDI )&& (rs1 != 0 && (rs1 == this.EX_rd || rs1 == this.MEM_rd || rs1 == this.WB_rd)) )
		begin
			this.isStall = 1;
			this.ID_o = 0;
			this.IF_o_stall = this.IF_o;
		end
		else if( (opcode == ST) && (rd != 0 && (rd == this.EX_rd || rd == this.MEM_rd || rd == this.WB_rd) ) )
		begin
			this.isStall = 1;
			this.ID_o = 0;
			this.IF_o_stall = this.IF_o;
		end
		else // If not stall
		begin
			this.isStall = 0;
			
			// $display("PC: %d, Opcode: %0s, rd: %d,  rs1: %d, rs2: %d, offset: %d", this.PC, opcode, CurrentIns[11:9],rs1,rs2,CurrentIns[2:0]);

			// Cases that we need to read register values
			if(opcode == NOP || opcode == ADD || opcode == SUB || opcode == AND || opcode == OR || opcode == XOR || opcode == SL || opcode == SR || opcode == SRU)
			begin
				rs1_val = readRegister(rs1);    
				rs2_val = readRegister(rs2);
				rd = CurrentIns[11:9];
				
				// set interface signals
				this.mif.rd = rd;
				this.mif.rs1 = rs1;
				this.mif.rs2 = rs2;
			end
			else if(opcode== ADDI)
			begin
				rs1_val = readRegister(rs1);
				rs2_val = {{10{CurrentIns[5]}},CurrentIns[5:0]};
				rd = CurrentIns[11:9];
				
				// set interface signals
				this.mif.rd = rd;
				this.mif.rs1 = rs1;
				this.mif.offset = CurrentIns[5:0];
			end
			else if(opcode == LD || opcode == ST)
			begin
				rd = CurrentIns[11:9];
				rs1_val = rs1; // Base address
				rs2_val = CurrentIns[5:0];
			end
			else if(opcode == BZ)
			begin
				rd = 0;
				rs1_val = readRegister(rs1);
				rs2_val = CurrentIns[5:0];
				
				// set interface signals
				this.mif.rd = rd;
				this.mif.rs1 = rs1;
				this.mif.offset = CurrentIns[5:0];
			end
			else
			begin
				//rs1_val =
				//rs2_val =
			end
			this.ID_o  = {opcode,rd,rs1_val,rs2_val}; // 4 bit + 3 bit + 32 bit + 32 bit = 71 bits
			end
	end
endtask : ID



task EX();

	opcode_t        opcode;	// Opcodes
	bit 	[3:0]	opcode_bin;
    // bit     [2:0]   rd;		// Destination register
    int     	    rs1_val;	// Source register 1
    int     	    rs2_val;  	// Source register 2
    int	            result;
	
	@ (posedge this.mif.clk);
    {opcode_bin,this.EX_rd,rs1_val,rs2_val} = this.ID_o;
	
	$cast(opcode, opcode_bin);
	
    case(opcode)
    NOP: ;// do nothing;
    ADD: result = rs1_val + rs2_val;
    SUB: result = rs1_val - rs2_val;
    AND: result = rs1_val & rs2_val;
    OR:  result = rs1_val | rs2_val;
    XOR: result = rs1_val ^ rs2_val;
    SL:  result = rs1_val << rs2_val;
    SR:  result = rs1_val >>> rs2_val;  // !! CHECK IF sign extended
    SRU: result = rs1_val >> rs2_val; // is this rotate not clear in document?
	ADDI: result = rs1_val + rs2_val;
	LD: result = rs1_val + rs2_val;
    endcase
	// $display("Opcode: %0s, dest: %b, val1: %b, val2: %b, result: %b", opcode,this.EX_rd,rs1_val,rs2_val,result);
	// $display("ID: %b",this.ID_o);
    this.EX_o = {opcode,this.EX_rd,result}; // 4bit + 3 bit + 32 bit

endtask : EX

task MEM();

    opcode_t        opcode;	// Opcodes
	bit 	[3:0]	opcode_bin;
    // bit     [2:0]   rd;		// Destination register
    int             result;

	@ (posedge this.mif.clk);
    {opcode_bin,this.MEM_rd,result} = this.EX_o;
	$cast(opcode, opcode_bin);
    if(opcode==LD || opcode == ST)
    begin
        // Do mem operation
		case(opcode)
		LD: result = this.dataMemory[result]; //this.writeToRegister(this.MEM_rd,this.dataMemory[result]);
		ST: this.dataMemory[result] = this.readRegister(this.MEM_rd);// Takes 2 cycle
		endcase
		this.MEM_o = {opcode,this.MEM_rd,result};
    end
    else
    begin
        this.MEM_o = EX_o;
    end

endtask : MEM

task WB();
    opcode_t        opcode;	// Opcodes
	bit 	[3:0]	opcode_bin;
    int             result;
	
	@ (posedge this.mif.clk);
    
	{opcode_bin,this.WB_rd,result} = this.MEM_o; // Changed to MEM_o
	$cast(opcode, opcode_bin);
	
    if(opcode == NOP || opcode == ADD || opcode == SUB || opcode == AND || opcode == OR || opcode == XOR || opcode == SL || opcode == SR || opcode == SRU ||  opcode == ADDI || opcode == LD)
    begin
        // Do write back
        this.writeToRegister(this.WB_rd,result);
		// $display("Saved to register Opcode: %b, rd = %b, result= %b , %h (HEX)", opcode_bin,this.WB_rd,result,result );
    end
	// $display("%s", {30{"-"}});
endtask : WB

task execute();
    this.loadInstructionMemory(); // We need to know the lenght of program
	this.scb_chk_i = new(this.mif);
	
	while (this.PC != 255)
	begin
		// @(posedge this.mif.clk);
		fork
		this.IF();
		@(posedge this.mif.clk);
        this.ID();
        @(posedge this.mif.clk);
		this.EX();
        @(posedge this.mif.clk);
		this.MEM();
        @(posedge this.mif.clk);
		this.WB();
		@(posedge this.mif.clk);
		this.mif.PC = this.PC;
		this.mif.InstructionMemory_rm = this.InstructionMemory; // Updates signals to observe
		this.mif.DataRegister_rm = this.DataRegister;			// Updates to observe
		this.scb_chk_i.checking(); // Feeds checker
		this.scb_chk_i.scoreboard(); // Writes to file
		join
	end
	$display("Generated instructions in the instruction.txt file");
	$display("Scoreboard in the scoreboard.txt file");
	$stop;
endtask : execute

endclass