
`ifndef COVERAGE
`define COVERAGE


`include "transaction.sv"


class hd_coverage;

	hd_txn txn;
	hd_result_txn result_txn;


	covergroup hd_txn_cov;

	  source_reg1: coverpoint txn.source_reg1;
	  source_reg2: coverpoint txn.source_reg2;
	  ex_reg: coverpoint txn.ex_reg;
	  mem_reg: coverpoint txn.mem_reg;
	  wb_reg: coverpoint txn.wb_reg;

	endgroup

	covergroup hd_result_cov;

	  txn_result: coverpoint result_txn.stall;

	endgroup

	function new();
		hd_txn_cov = new;
		hd_result_cov = new;
	endfunction : new

	function void sample_hd_txn(hd_txn txn);
	   this.txn = txn;
	   txn.display($sformatf("@%0t: Coverage sampled hd txn: ", $time));
	   hd_txn_cov.sample();
	endfunction : sample_hd_txn

	function void sample_hd_result(hd_result_txn txn);
	   this.result_txn = txn;
	   txn.display($sformatf("@%0t: Coverage sampled hd result: ", $time));
	   hd_result_cov.sample();
	endfunction : sample_hd_result

endclass : hd_coverage

`endif // COVERAGE
