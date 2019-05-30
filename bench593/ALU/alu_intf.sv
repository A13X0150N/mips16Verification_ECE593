
`include "alu_pkg.sv"

interface alu_intf;

	logic [`ALU_WIDTH -1 : 0] a, b;
	logic [`ALU_CMD_WIDTH -1 :0] cmd;
	logic [`ALU_WIDTH -1 : 0] result;


	modport test (output a, b, cmd, input result);

endinterface //alu_intf


typedef virtual alu_intf.test alu_intf_f;