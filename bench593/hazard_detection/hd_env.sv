

`include "transaction.sv"
`include "mips_16_defs.v"
`include "hd_scoreboard.sv"
`include "hd_driver.sv"
`include "hd_monitor.sv"
`include "hd_coverage.sv"
`include "hd_generator.sv"

class driver_scb_cbs extends hd_driver_cbs;
   hd_scoreboard scb;

   function new(hd_scoreboard scb);
      this.scb = scb;
   endfunction : new

	virtual task post_drive(input hd_driver drv, hd_txn txn);
        scb.save_current_txn(txn);
	endtask : post_drive
endclass : driver_scb_cbs


class driver_coverage_cbs extends hd_driver_cbs;
   hd_coverage cov;

   function new(hd_coverage cov);
      this.cov = cov;
   endfunction : new

	virtual task post_drive(input hd_driver drv, hd_txn txn);
        cov.sample_hd_txn(txn);
	endtask : post_drive
endclass : driver_coverage_cbs


class monitor_scb_cbs extends hd_monitor_cbs;
   hd_scoreboard scb;

   function new(hd_scoreboard scb);
      this.scb = scb;
   endfunction : new

	virtual task post_monitor(hd_result_txn txn);
        scb.check_result(txn);
	endtask : post_monitor
endclass : monitor_scb_cbs

class monitor_coverage_cbs extends hd_monitor_cbs;
   hd_coverage cov;

    function new(hd_coverage cov);
        this.cov = cov;
    endfunction : new

    virtual task post_monitor(hd_result_txn txn);
        cov.sample_hd_result(txn);
	endtask : post_monitor
endclass : monitor_coverage_cbs


class environment;
    mailbox generator_to_driver;
    event   driver_to_generator_event;
    hd_driver driver;
    hd_monitor monitor;
    hd_scoreboard scoreboard;
    hd_coverage coverage;
    hd_generator generator;
    virtual hd_intf intf;


    driver_scb_cbs driver_to_scb_cbs;
    monitor_scb_cbs monitor_to_scb_cbs;
    driver_coverage_cbs driver_to_coverage_cbs;
    monitor_coverage_cbs monitor_to_coverage_cbs;

    function new(virtual hd_intf intf);
		this.intf  = intf;
    endfunction

    virtual function void build();
        generator_to_driver = new;
    	driver =  new(generator_to_driver, driver_to_generator_event, intf);
        generator = new(generator_to_driver, driver_to_generator_event);
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
            generator.run();
    endtask

    virtual function void finish();
        $display("@%0t: End of simulation", $time);
        scoreboard.finish();
    endfunction

endclass : environment

