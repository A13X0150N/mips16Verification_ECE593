
typedef class driver;


class alu_driver_cbs;
	virtual task pre_drive(input driver drv, inout bit drop);
	endtask : pre_drive

	virtual task post_drive(input driver drv);
	endtask : post_drive
endclass //alu_driver_cbs


class driver;
	protected alu_txn  txn;
	protected bit drop = 0;

	mailbox generator_to_driver;
	event   driver_to_generator_event;
	alu_intf alu_intf;
	alu_driver_cbs cbs_list[$];

	function new(mailbox generator_to_driver, event driver_to_generator_event, alu_intf intf);
		this.generator_to_driver = generator_to_driver;
		this.driver_to_generator_event = driver_to_generator_event;
		this.alu_intf  = intf;
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

	task send (alu_txn txn);

		txn.display("sending ALU txn: ");
		//Send data
		alu_intf.a = tnx.a;
		alu_intf.b = tnx.b;
		alu_intf.cmd = tnx.cmd;

		//Wait for data to propgate out
		#4;
		tnx.result = alu.result;
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
		end
		generator_to_driver.get(txn);
		->driver_to_generator_event;
	endtask



endclass : Driver