
`include "hd_pkg.sv"
`include "hd_intf.sv"
`include "transaction.sv"


typedef class monitor;

class hd_monitor_cbs;
	virtual task post_monitor(hd_result_txn txn);
	endtask : post_monitor
endclass //hd_driver_cbs

class hd_monitor;

	hd_intf_f intf;
	hd_monitor_cbs cbs_list[$];
	hd_result_txn txn;


	function new(hd_intf_f intf);
		this.intf = intf;
	endfunction : new

	task run();
		forever begin
    		mointor_hd();
			foreach (cbs_list[i])
				cbs_list[i].post_monitor(txn); 	 // Post-receive callback
		end
	endtask : run

	task mointor_hd();
		txn = new();
		tnx.stall = intf.stall;
		txn.display($sformatf("@%0t: mointor: ", $time));
	endtask: mointor_hd

endclass : monitor