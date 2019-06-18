
`ifndef SCOREBOARD
`define SCOREBOARD

`include "../../../DUV/mips_16_defs.v"
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

		current_txn.display("hd Scoreboard check ");
		if(!result_txn.compare(predict_result(current_txn)))
			$display("@%0t: hd Scoreboard ERROR: miss match between prediteced result and actual result", $time);
		else
			$display("@%0t: hd Scoreboard: match prediteced result and actual result", $time);

		current_txn = null;

	endfunction

	function void finish();
		if(current_txn != null)
			$display("@%0t: hd Scoreboard ERROR: current hd transaction has not been checked", $time);
		else
			$display("@%0t: hd Scoreboard: Finished correctly", $time);
	endfunction

	protected function hd_result_txn predict_result(hd_txn txn);
		hd_result_txn predicted_txn;
		predicted_txn = new();

        if(txn.source_reg1 == txn.ex_reg ||  txn.source_reg1 == txn.mem_reg || txn.source_reg1 == txn.wb_reg) begin
            predicted_txn.stall = 0;
            return predicted_txn;

		end

		if(txn.source_reg2 == txn.ex_reg ||  txn.source_reg2 == txn.mem_reg || txn.source_reg2== txn.wb_reg) begin
            predicted_txn.stall = 0;
            return predicted_txn;
		end

		    predicted_txn.stall = 1;
            return predicted_txn;

	endfunction : predict_result

endclass : hd_scoreboard

`endif // SCOREBOARD
