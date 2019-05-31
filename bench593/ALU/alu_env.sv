
`include "alu_pkg.sv"
`include "alu_intf.sv"
`include "alu_scoreboard.sv"
`include "alu_driver.sv"
`include "alu_monitor.sv"
`include "transaction.sv"

class scb_driver_cbs extends alu_driver_cbs;
   scoreboard scb;

   function new(scoreboard scb);
      this.scb = scb;
   endfunction : new

	virtual task post_drive(input driver drv, alu_txn txn);
        scb.save_current_txn(txn);
	endtask : post_drive
endclass : scb_Driver_cbs


class scb_coverage_cbs extends alu_driver_cbs;
   coverage cov;

   function new(coverage cov);
      this.cov = cov;
   endfunction : new

	virtual task post_drive(input driver drv, alu_txn txn);
        cov.sample_alu_txn(txn);
	endtask : post_drive
endclass : scb_Driver_cbs


class monitor_scb_cbs extends alu_monitor_cbs;
   scoreboard scb;

   function new(scoreboard scb);
      this.scb = scb;
   endfunction : new

	virtual task post_monitor(alu_result_txn txn);
        scb.predict_result(txn);
	endtask : post_monitor
endclass : scb_Monitor_cbs

class monitor_cov_cbs extends alu_monitor_cbs;
   coverage cov;

    function new(coverage cov);
        this.cov = cov;
    endfunction : new

    virtual task post_monitor(alu_result_txn txn);
        cov.sample_alu_txn(txn);
	endtask : post_monitor
endclass : scb_Monitor_cbs

