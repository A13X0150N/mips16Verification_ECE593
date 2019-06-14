
`ifndef MONITOR
`define MONITOR


	`include "transaction.sv"


typedef class hd_monitor;

class hd_monitor_cbs;
	virtual task post_monitor(hd_result_txn txn);
	endtask : post_monitor
endclass //hd_driver_cbs

class hd_monitor;

	virtual hd_intf intf;
	hd_monitor_cbs cbs_list[$];
	hd_result_txn txn;


	function new(virtual hd_intf intf);
		this.intf = intf;
	endfunction : new

	task run();
		forever begin
			@(intf.stall);
    		mointor_hd();
			foreach (cbs_list[i])
				cbs_list[i].post_monitor(txn); 	 // Post-receive callback
		end
	endtask : run

	task mointor_hd();
		txn = new();
		txn.stall = intf.stall;
		txn.display($sformatf("@%0t: Mointor: ", $time));
	endtask: mointor_hd

endclass : hd_monitor

`endif // MONITOR
