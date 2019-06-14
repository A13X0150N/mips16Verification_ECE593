
`ifndef TXN
`define TXN

	`include "alu_defs.sv"

virtual class transaction;
  static int count;
  int id;

  function new();
  	id = count++;
  endfunction

  pure virtual function bit compare(transaction to);
  pure virtual function transaction copy(transaction to=null);
  pure virtual function void display(string prefix="");
endclass : transaction

class alu_txn extends transaction;

	rand logic [`ALU_WIDTH -1 : 0] a;
	rand logic [`ALU_WIDTH -1 : 0] b;
	rand logic [`ALU_CMD_WIDTH -1 : 0] cmd;
	function new();
		super.new();

	endfunction

	virtual function bit compare(transaction to);
		alu_txn compare_to;

		if(to == null)
			return 0;
		`ASSERT_COND($cast(compare_to, to),"cast failed");
		if (this.a != compare_to.a || this.b != compare_to.b || this.cmd != compare_to.cmd)
			return 0;
		else
			return 1;
	endfunction : compare

	virtual function transaction copy(transaction to=null);
		alu_txn new_copy;
		if(to != null)
			new_copy = new();
		else
			$cast(new_copy,to);

		new_copy.a = this.a;
		new_copy.b = this.b;
		new_copy.cmd = this.cmd;
		return new_copy;
	endfunction

	virtual function void display(string prefix="");
		$display("%s id:%0d a=%x, b=%x, cmd=%b",
	    prefix, id, a, b, cmd);
	endfunction

endclass

class alu_result_txn extends transaction;

	logic [`ALU_WIDTH -1 : 0] result;

	function new();
		super.new();
	endfunction

	virtual function bit compare(transaction to);
		alu_result_txn compare_to;
		if(to == null)
			return 0;
		`ASSERT_COND($cast(compare_to, to),"cast failed");
		if (this.result != compare_to.result)
			return 0;
		else
			return 1;
	endfunction : compare

	virtual function transaction copy(transaction to=null);
		alu_result_txn new_copy;
		if(to != null)
			new_copy = new();
		else
			$cast(new_copy,to);
		new_copy.result = this.result;
		return new_copy;
	endfunction

	virtual function void display(string prefix="");
		$display("%s id:%0d result=%x",	prefix, id, result);
	endfunction

endclass

`endif // TXN
