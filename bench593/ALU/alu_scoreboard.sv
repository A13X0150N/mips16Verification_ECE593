
`include "mips_16_defs.sv"
`include "transaction.sv"

class scoreboard;

	alu_txn current_txn;
	function new();
		current_txn = null;
	endfunction

	function void save_current_txn(alu_txn txn);
		current_txn = txn;
		txn.display($sformatf("@%0t: ALU Scoreboard save: ", $time));
	endfunction

	function void check_result(alu_result_txn result_txn);

		if(!result_txn.compare(predict_result(current_txn)))
			$display("@%0t: ALU Scoreboard ERROR: miss match between prediteced result and actual result", $time);
		else
			$display("@%0t: ALU Scoreboard: match prediteced result and actual result", $time);

		current_txn.display("ALU Scoreboard");
		current_txn = null;

	endfunction

	function void finish();
		if(current_txn != null)
			$display("@%0t: ALU Scoreboard ERROR: current ALU transaction has not been checked", $time);
		else
			$display("@%0t: ALU Scoreboard: Finished correctly", $time);
	endfunction

	protected function alu_result_txn predict_result(alu_txn current_txn);
		alu_result_txn predicted_txn;
		predicted_txn = new();

		case (current_txn.cmd)
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

endclass : scoreboard