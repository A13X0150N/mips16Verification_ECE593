
`ifndef MONITOR
`define MONITOR


	`include "transaction.sv"


typedef class alu_monitor;

class alu_monitor_cbs;
	virtual task post_monitor(alu_result_txn txn);
	endtask : post_monitor
endclass //alu_driver_cbs

class alu_monitor;

	virtual alu_intf intf;
	alu_monitor_cbs cbs_list[$];
	alu_result_txn txn;


	function new(virtual alu_intf intf);
		this.intf = intf;
	endfunction : new

	task run();
		forever begin
    		mointor_alu();
			foreach (cbs_list[i])
				cbs_list[i].post_monitor(txn); 	 // Post-receive callback
		end
	endtask : run

	task mointor_alu();
		@(intf.result);
		txn = new();
		txn.result = intf.result;
		txn.display($sformatf("@%0t: mointor: ", $time));
	endtask: mointor_alu

endclass : alu_monitor

`endif // MONITOR
