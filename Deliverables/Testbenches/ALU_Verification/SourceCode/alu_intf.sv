
`include "alu_defs.sv"

interface alu_intf;

	logic [`ALU_WIDTH -1 : 0] a, b;
	logic [`ALU_CMD_WIDTH -1 :0] cmd;
	logic [`ALU_WIDTH -1 : 0] result;

endinterface //alu_intf


typedef virtual alu_intf alu_intf_f;