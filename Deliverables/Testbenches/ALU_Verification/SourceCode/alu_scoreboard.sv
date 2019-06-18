
`ifndef SCOREBOARD
`define SCOREBOARD

`include "../../../DUV/mips_16_defs.v"
`include "transaction.sv"

class alu_scoreboard;

	alu_txn current_txn;
	function new();
		current_txn = null;
	endfunction

	function void save_current_txn(alu_txn txn);
		current_txn = txn;
		txn.display($sformatf("@%0t: ALU Scoreboard save: ", $time));
	endfunction

	function void check_result(alu_result_txn result_txn);

		current_txn.display("ALU Scoreboard check ");
		if(!result_txn.compare(predict_result(current_txn)))
			$display("@%0t: ALU Scoreboard ERROR: miss match between prediteced result and actual result", $time);
		else
			$display("@%0t: ALU Scoreboard: match prediteced result and actual result", $time);

		current_txn = null;

	endfunction

	function void finish();
		if(current_txn != null)
			$display("@%0t: ALU Scoreboard ERROR: current ALU transaction has not been checked", $time);
		else
			$display("@%0t: ALU Scoreboard: Finished correctly", $time);
	endfunction

	protected function alu_result_txn predict_result(alu_txn txn);
		alu_result_txn predicted_txn;
		predicted_txn = new();

		case (txn.cmd)
			`ALU_NC : 	predicted_txn.result = txn.a + txn.b;
			`ALU_ADD :	predicted_txn.result = txn.a + txn.b;
			`ALU_SUB :	predicted_txn.result = txn.a - txn.b;
			`ALU_AND :	predicted_txn.result = txn.a & txn.b;
			`ALU_OR :	predicted_txn.result = txn.a | txn.b;
			`ALU_XOR :	predicted_txn.result = txn.a ^ txn.b;
			`ALU_SL :	predicted_txn.result = txn.a << txn.b;
			`ALU_SR :	predicted_txn.result = txn.a >>> txn.b;
			`ALU_SRU :	predicted_txn.result = txn.a >> txn.b;
		endcase

   		return predicted_txn;

	endfunction : predict_result

endclass : alu_scoreboard

`endif // SCOREBOARD