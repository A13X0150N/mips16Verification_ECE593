
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

	rand logic [alu_width -1 : 0] a;
	rand logic [alu_width -1 : 0] b;
	rand logic [alu_cmd_width -1 : 0] cmd;
	logic [alu_width -1 : 0] result;

	function new();
		super.new();

	endfunction

	virtual function bit compare(transaction to);
		if(to == null)
			return 0;
		alu_txn compare_to;
		assert_cond($cast(compare_to, to),"cast failed");
		if (this.a != compare_to.a || this.b != compare_to.b || this.cmd != compare_to.cmd || this.result != compare_to.result)
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
		new_copy.result = this.result;
		return new_copy;
	endfunction

	virtual function void display(string prefix="");
		$display("%s id:%0d a=%x, b=%x, cmd=%b, result=%x",
	    prefix, id, a, b, cmd, result);
	endfunction

endclass