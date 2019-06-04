
`include "alu_pkg.sv"

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

class hd_txn extends transaction;

	rand logic [`REG_WIDTH -1 : 0] source_reg1;
	rand logic [`REG_WIDTH -1 : 0] source_reg2;

	rand logic [`REG_WIDTH -1 : 0] ex_reg;
	rand logic [`REG_WIDTH -1 : 0] mem_reg;
	rand logic [`REG_WIDTH -1 : 0] wb_reg;


	function new();
		super.new();
	endfunction

	virtual function bit compare(transaction to);
		hd_txn compare_to;

		if(to == null)
			return 0;
		`ASSERT_COND($cast(compare_to, to),"cast failed");
		if (this.source_reg1 != compare_to.source_reg1 ||
            this.source_reg2 != compare_to.source_reg2 ||
            this.ex_reg != compare_to.ex_reg ||
            this.mem_reg != compare_to.mem_reg || 
            this.wb_reg != compare_to.wb_reg)
			return 0;
		else
			return 1;
	endfunction : compare

	virtual function transaction copy(transaction to=null);
		hd_txn new_copy;
		if(to != null)
			new_copy = new();
		else
			$cast(new_copy,to);

		new_copy.source_reg1 = this.source_reg1;
		new_copy.source_reg2 = this.source_reg2;
		new_copy.ex_reg = this.ex_reg;
		new_copy.mem_reg = this.mem_reg;
		new_copy.wb_reg = this.wb_reg;

		return new_copy;
	endfunction

	virtual function void display(string prefix="");
		$display("%s id:%0d Source Reg 1=%x, Source Reg 2=%x, Ex Reg=%b, Mem Reg=%b, WB Reg=%b",
	    prefix, id, source_reg1, source_reg2, ex_reg, mem_reg, wb_reg);
	endfunction

endclass

class hd_result_txn extends transaction;

	logic [`REG_WIDTH -1 : 0] stall;

	function new();
		super.new();
	endfunction

	virtual function bit compare(transaction to);
		hd_result_txn compare_to;
		if(to == null)
			return 0;
		`ASSERT_COND($cast(compare_to, to),"cast failed");
		if (this.stall != compare_to.stall)
			return 0;
		else
			return 1;
	endfunction : compare

	virtual function transaction copy(transaction to=null);
		hd_result_txn new_copy;
		if(to != null)
			new_copy = new();
		else
			$cast(new_copy,to);
		new_copy.stall = this.stall;
		return new_copy;
	endfunction

	virtual function void display(string prefix="");
		$display("%s id:%0d stall=%x",	prefix, id, stall);
	endfunction

endclass