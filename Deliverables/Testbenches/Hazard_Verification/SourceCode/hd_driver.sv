`ifndef DRIVER
`define DRIVER


`include "transaction.sv"

typedef class hd_driver;

class hd_driver_cbs;
	virtual task pre_drive(input hd_driver drv, inout bit drop);
	endtask : pre_drive

	virtual task post_drive(input hd_driver drv, hd_txn txn);
	endtask : post_drive
endclass //hd_driver_cbs


class hd_driver;
	protected hd_txn  txn;
	protected bit drop = 0;

	mailbox generator_to_driver;
	event   driver_to_generator_event;
	virtual hd_intf intf;
	hd_driver_cbs cbs_list[$];

	function new(mailbox generator_to_driver, event driver_to_generator_event, virtual hd_intf intf);
		this.generator_to_driver = generator_to_driver;
		this.driver_to_generator_event = driver_to_generator_event;
		this.intf  = intf;
	endfunction : new


	task run();
		forever begin
			pre_drive();
			if(!drop) begin
				drive();
				post_drive();
			end
		end
	endtask: run

	task drive ();
		txn.display("Driver: sending hd txn");
		//Send data
		intf.reg1 = txn.source_reg1;
		intf.reg2 = txn.source_reg2;
		intf.ex = txn.ex_reg;
		intf.mem = txn.mem_reg;
		intf.wb = txn.wb_reg;
	endtask

	protected task pre_drive();
	    generator_to_driver.peek(txn);
		foreach (cbs_list[i]) begin
			cbs_list[i].pre_drive(this, drop);
        end
	endtask

	protected task post_drive();
		foreach (cbs_list[i])
			cbs_list[i].post_drive(this, txn);

		generator_to_driver.get(txn);
		->driver_to_generator_event;
	endtask

endclass : hd_driver

`endif // DRIVER