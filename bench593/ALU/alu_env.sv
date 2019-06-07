

`include "transaction.sv"
`include "mips_16_defs.v"
`include "alu_scoreboard.sv"
`include "alu_driver.sv"
`include "alu_monitor.sv"
`include "alu_coverage.sv"

class driver_scb_cbs extends alu_driver_cbs;
   alu_scoreboard scb;

   function new(alu_scoreboard scb);
      this.scb = scb;
   endfunction : new

	virtual task post_drive(input alu_driver drv, alu_txn txn);
        scb.save_current_txn(txn);
	endtask : post_drive
endclass : driver_scb_cbs


class driver_coverage_cbs extends alu_driver_cbs;
   alu_coverage cov;

   function new(alu_coverage cov);
      this.cov = cov;
   endfunction : new

	virtual task post_drive(input alu_driver drv, alu_txn txn);
        cov.sample_alu_txn(txn);
	endtask : post_drive
endclass : driver_coverage_cbs


class monitor_scb_cbs extends alu_monitor_cbs;
   alu_scoreboard scb;

   function new(alu_scoreboard scb);
      this.scb = scb;
   endfunction : new

	virtual task post_monitor(alu_result_txn txn);
        scb.check_result(txn);
	endtask : post_monitor
endclass : monitor_scb_cbs

class monitor_coverage_cbs extends alu_monitor_cbs;
   alu_coverage cov;

    function new(alu_coverage cov);
        this.cov = cov;
    endfunction : new

    virtual task post_monitor(alu_result_txn txn);
        cov.sample_alu_result(txn);
	endtask : post_monitor
endclass : monitor_coverage_cbs


class environment;
    mailbox generator_to_driver;
    event   driver_to_generator_event;
    alu_driver driver;
    alu_monitor monitor;
    alu_scoreboard scoreboard;
    alu_coverage coverage;
    virtual alu_intf intf;

    driver_scb_cbs driver_to_scb_cbs;
    monitor_scb_cbs monitor_to_scb_cbs;
    driver_coverage_cbs driver_to_coverage_cbs;
    monitor_coverage_cbs monitor_to_coverage_cbs;

    function new(virtual alu_intf intf);
		this.intf  = intf;
    endfunction

    virtual function void build();
        generator_to_driver = new;
    	driver =  new(generator_to_driver, driver_to_generator_event, intf);
        monitor =  new(intf);
        scoreboard = new;
        coverage = new;


        driver_to_scb_cbs = new (scoreboard);
        monitor_to_scb_cbs = new (scoreboard);
        driver_to_coverage_cbs = new (coverage);
        monitor_to_coverage_cbs = new (coverage);

        driver.cbs_list.push_back(driver_to_scb_cbs);
        driver.cbs_list.push_back(driver_to_coverage_cbs);
        monitor.cbs_list.push_back(monitor_to_scb_cbs);
        monitor.cbs_list.push_back(monitor_to_coverage_cbs);

    endfunction

    virtual task run();
        fork
            driver.run();
            monitor.run();
        join_none
        //Should wait for test generation
    endtask

    virtual function void finish();
        $display("@%0t: End of simulation", $time);
        scoreboard.finish();
    endfunction

endclass : environment

