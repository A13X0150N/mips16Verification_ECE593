

interface alu_if;

	logic [alu_if -1 : 0] a, b;
	logic [2:0] cmd;
	logic [alu_if -1 : 0] result;


	modport test (output a, b, cmd, input result)

endinterface //alu_if