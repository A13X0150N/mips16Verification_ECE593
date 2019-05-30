

interface alu_intf;

	logic [alu_width -1 : 0] a, b;
	logic [alu_cmd_width -1 :0] cmd;
	logic [alu_width -1 : 0] result;


	modport test (output a, b, cmd, input result)

endinterface //alu_intf