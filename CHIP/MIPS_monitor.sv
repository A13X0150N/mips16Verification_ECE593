typedef class monitor;

class alu_monitor_cbs;
	virtual task post_monitor(alu_txn txn);
	endtask : post_monitor
endclass //alu_driver_cbs



class monitor;

	alu_intf alu_intf;
	alu_monitor_cbs cbs_list[$];
	alu_txn txn;


	function new(alu_intf intf);
		this.alu_intf = intf;
	endfunction : new

	task run();
		forever begin
    		mointor_alu();
			foreach (cbs_list[i])
				cbs_list[i].post_monitor(txn); 	 // Post-receive callback
		end
	endtask : run

	task mointor_alu();
		@(alu_intf.result);
		txn = new();
		tnx.result = alu.result;
		txn.display($sformatf("@%0t: mointor: ", $time))
	endtask: mointor_alu

endclass : monitor