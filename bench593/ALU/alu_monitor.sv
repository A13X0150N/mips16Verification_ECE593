

`include "alu_pkg.sv"
`include "alu_intf.sv"
`include "transaction.sv"


typedef class monitor;

class alu_monitor_cbs;
	virtual task post_monitor(alu_result_txn txn);
	endtask : post_monitor
endclass //alu_driver_cbs

class monitor;

	alu_intf_f intf;
	alu_monitor_cbs cbs_list[$];
	alu_result_txn txn;


	function new(alu_intf_f intf);
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
		tnx.result = intf.result;
		txn.display($sformatf("@%0t: mointor: ", $time));
	endtask: mointor_alu

endclass : monitor