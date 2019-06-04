
`include "alu_pkg.sv"
`include "alu_intf.sv"
`include "alu_scoreboard.sv"
`include "alu_driver.sv"
`include "alu_monitor.sv"
`include "transaction.sv"

class driver_scb_cbs extends alu_driver_cbs;
   scoreboard scb;

   function new(scoreboard scb);
      this.scb = scb;
   endfunction : new

	virtual task post_drive(input driver drv, alu_txn txn);
        scb.save_current_txn(txn);
	endtask : post_drive
endclass : scb_Driver_cbs


class driver_coverage_cbs extends alu_driver_cbs;
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
        scb.check_result(txn);
	endtask : post_monitor
endclass : scb_Monitor_cbs

class monitor_coverage_cbs extends alu_monitor_cbs;
   coverage cov;

    function new(coverage cov);
        this.cov = cov;
    endfunction : new

    virtual task post_monitor(alu_result_txn txn);
        cov.sample_alu_txn(txn);
	endtask : post_monitor
endclass : scb_Monitor_cbs


class environment;
    mailbox generator_to_driver;
    event   driver_to_generator_event;
    alu_driver driver;
    alu_monitor monitor;
    alu_scoreboard scoreboard;
    alu_coverage coverage;
    alu_intf_f intf;


    function new(alu_intf_f intf);
		this.intf  = intf;
    endfunction
    
    virtual function void build();
    	driver =  new(generator_to_driver, driver_to_generator_event, intf);
        alu_monitor =  new(intf);
        scoreboard = new();
        coverage = new();


        driver_scb_cbs = new (scoreboard);
        monitor_scb_cbs = new (scoreboard);
        driver_coverage_cbs = new (coverage);
        monitor_coverage_cbs = new (coverage);

        driver.cbs_list.pushback(driver_scb_cbs);
        driver.cbs_list.pushback(driver_coverage_cbs);
        mointor.cbs_list.pushback(monitor_scb_cbs);
        mointor.cbs_list.pushback(monitor_coverage_cbs);

    endfunction

    virtual task run();
        fork
            driver.run();
            mointor.run();
        join_none
        //Should wait for test generation
    endfunction

    virtual function void finish();
        $display("@%0t: End of simulation", $time);
        scoreboard.finish();
    endfunction

endclass : Environment

