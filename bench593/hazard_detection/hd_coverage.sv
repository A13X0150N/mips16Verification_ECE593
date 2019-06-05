
`include "transaction.sv"

class hd_coverage;

	hd_txn txn;
	hd_result_txn result_txn;


 	covergroup hd_txn_cov;

      coverpoint txn;

	endgroup

	function new();
		hd_txn_cov = new;
	endfunction : new

	function void sample_hd_txn(hd_txn txn);
	   this.txn = txn;
	   txn.display($sformatf("@%0t: Coverage: ", $time));
	   hd_txn_cov.sample();
	endfunction : sample_hd_txn

	function void sample_hd_result(hd_result_txn txn);
	   this.result_txn = txn;
	   txn.display($sformatf("@%0t: Coverage: ", $time));
	   hd_txn_cov.sample();
	endfunction : sample_hd_result

endclass : coverage