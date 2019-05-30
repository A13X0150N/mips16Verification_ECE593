// Reference design 

import MIPS_pkg::*;

class MIPSRef; // Instruction memory depth can be parameter

logic   [15:0]  InstructionMemory   [255:0];    // Instruction memory 
logic   [15:0]  DataRegister  [7:0];            // Only 8 register
logic   [7:0]   PC;     // Program counter
logic   [15:0]  IF_o;   // output of instruction fetch satege
logic   [70:0]  ID_o;   // output of instruction decode stage
logic   [34:0]  EX_o;   // Output of execution stage
logic   [34:0]  MEM_o;   // Output of execution stage
function new();
    this.PC = 0; // When new object is created, resets the PC
endfunction

// Loads Instruction Memory with pre-defined instructions
function loadInstructionMemory();
    $readmemb("instructions.txt", this.InstructionMemory);
endfunction

function logic [15:0] readRegister(logic [15:0] addr);
    return DataRegister[addr];
endfunction

function logic writeToRegister(logic [15:0] addr, int data);
    DataRegister[addr] = data; 
endfunction

// Instruction fetch stage
function IF();
    bit [15:0]  CurrentIns;
    CurrentIns = this.InstructionMemory[this.PC];
    this.PC = this.PC + 1; // If changes on PC is needed after ID decrease by 1 to get actual value
endfunction

// Instruction Decode
function ID();
    bit     [15:0]  CurrentIns;
    opcode_t        opcode;	// Opcodes
	bit     [2:0]   rd;		// Destination register
	bit     [2:0]   rs1;	// Source register 1
    bit     [2:0]   rs2;  	// Source register 2
    int     rs1_val,
            rs2_val;    // Actual register values

    CurrentIns = this.IF_o;
    opcode = CurrentIns[15:12];
    // !!!!!!!!!!!!! CURRENTLY NOT WORKING FOR I TYPE AND J TYPE INS.
    // Cases that we need to read register values
    if(opcode == NOP || opcode == ADD || opcode == SUB || opcode == AND || opcode == OR || opcode == XOR || opcode == SL || opcode == SR || opcode == SRU)
    begin
        rs1_val = readRegister(rs1)    
        rs2_val = readRegister(rs2)
    end
    else
    begin
        //rs1_val =
        //rs2_val =
    end
    this.ID_o  = {opcode,rd,rs1_val,rs2_val} // 4 bit + 3 bit + 32 bit + 32 bit = 71 bits
endfunction


function EX();
    opcode_t        opcode;	// Opcodes
	bit     [2:0]   rd;		// Destination register
	bit     [2:0]   rs1;	// Source register 1
    bit     [2:0]   rs2;  	// Source register 2
    {opcode,rd,rs1_val,rs2_val} = this.ID_o

    case(opcode)
    NOP: // do nothing;
    ADD: result = rs1_val + rs2_val;
    SUB: result = rs1_val - rs2_val;
    AND: result = rs1_val & rs2_val;
    OR: result = rs1_val | rs2_val;
    XOR: result = rs1_val ^ rs2_val;
    SL: result = rs1_val << rs2_val;
    SR: result = rs1_val >>> rs2_val;  // !! CHECK IF sign extended
    SRU: result = rs1_val >> rs2_val; // is this rotate not clear in document?
    endcase
    this.EX_o = {opcode,rd,result}; // 3 bit + 32 bit
endfunction


function MEM();

    opcode_t        opcode;	// Opcodes
	bit     [2:0]   rd;		// Destination register
    int             result;

    {opcode,rd,result} = this.EX_o;

    if(opcode==LD || opcode == ST)
    begin
        // Do mem operation
    end
    else
    begin
        MEM_o = EX_o;
    end

endfunction


function WB();
    opcode_t        opcode;	// Opcodes
	bit     [2:0]   rd;		// Destination register
    int             result;
    {opcode,rd,result} = this.EX_o;
   
    if(opcode == NOP || opcode == ADD || opcode == SUB || opcode == AND || opcode == OR || opcode == XOR || opcode == SL || opcode == SR || opcode == SRU ||  opcode == ADDI || opcode == LD)
    begin
        // Do write back
        writeToRegister(rd,result);
    end
endfunction

function execute();
    this.loadInstructionMemory(); // We need to know the lenght of program

    forever begin
        this.IF();
        this.ID();
        this.EX();
        this.MEM();
        this.WB(); 
    end

endfunction

endclass