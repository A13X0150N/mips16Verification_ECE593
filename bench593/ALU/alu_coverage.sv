


class coverage;

	alu_txn txn;
	alu_result_txn result_txn;


 	covergroup alu_txn_cov;

      a: coverpoint txn.a {
         bins zeros = {'h0000};
         bins others= {['h1:'hFFFE]};
         bins ones  = {'hFFFF};
      }

      b: coverpoint txn.b {
         bins zeros = {'h0000};
         bins others= {['h1:'hFFFE]};
         bins ones  = {'hFFFF};
      }

	  cmd: coverpoint txn.cmd;
      }
	endgroup


	covergroup alu_result_cov;

      results: coverpoint result_txn.results {
         bins zeros = {'h0000};
         bins others= {['h1:'hFFFE]};
         bins ones  = {'hFFFF};
      }

	endgroup

	function new();
		alu_txn_cov = new;
		alu_result_cov = new;
	endfunction : new

	function void sample_alu_txn(alu_txn txn)
	   this.txn = txn;
	   txn.display($sformatf("@%0t: Coverage: ", $time))
	   alu_txn_cov.sample();
	endfunction : sample_alu_txn

	function void sample_alu_result(result_txn txn)
	   $display("@%0t: Coverage: src=%d. FWD=%b", $time, src, fwd);
	   this.result_txn = txn;
	   alu_txn_cov.sample();
	endfunction : sample_alu_txn

endclass : coverage