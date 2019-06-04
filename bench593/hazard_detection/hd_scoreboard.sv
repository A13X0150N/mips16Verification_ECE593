
`include "mips_16_defs.sv"
`include "transaction.sv"

class hd_scoreboard;

	hd_txn current_txn;
	function new();
		current_txn = null;
	endfunction

	function void save_current_txn(hd_txn txn);
		current_txn = txn;
		txn.display($sformatf("@%0t: hd Scoreboard save: ", $time));
	endfunction

	function void check_result(hd_result_txn result_txn);

		if(!result_txn.compare(predict_result(current_txn)))
			$display("@%0t: hd Scoreboard ERROR: miss match between prediteced result and actual result", $time);
		else
			$display("@%0t: hd Scoreboard: match prediteced result and actual result", $time);

		current_txn.display("hd Scoreboard");
		current_txn = null;

	endfunction

	function void finish();
		if(current_txn != null)
			$display("@%0t: hd Scoreboard ERROR: current hd transaction has not been checked", $time);
		else
			$display("@%0t: hd Scoreboard: Finished correctly", $time);
	endfunction

	protected function hd_result_txn predict_result(hd_txn current_txn);
		hd_result_txn predicted_txn;
		predicted_txn = new();

        if(current_txn.source_reg1 == current_txn.ex_reg ||  current_txn.source_reg1 == current_txn.mem || current_txn.source_reg1 == current_txn.wb_reg)
            return predicted_txn.stall = 0;

        if(current_txn.source_reg2 == current_txn.ex_reg ||  current_txn.source_reg2 == current_txn.mem || current_txn.source_reg12== current_txn.wb_reg)
            return predicted_txn.stall = 0;

           return predicted_txn.stall = 1 ;

	endfunction : predict_result

endclass : scoreboard