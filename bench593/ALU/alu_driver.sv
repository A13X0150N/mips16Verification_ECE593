
typedef class driver;


class alu_driver_cbs;
	virtual task pre_drive(input driver drv, inout bit drop);
	endtask : pre_tx

	virtual task post_drive(input driver drv);
	endtask : post_tx
endclass //alu_driver_cbs


class driver;
	protected alu_txn  txn;
	protected bit drop = 0;

	mailbox generator_to_driver;
	event   driver_to_generator_event;
	alu_if alu_if;
	alu_driver_cbs cbs_list[$];

	function new(input mailbox generator_to_driver, input event driver_to_generator_event, input alu_if);
		this.generator_to_driver = generator_to_driver;
		this.driver_to_generator_event = driver_to_generator_event;
		this.alu_if  = alu_if;
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
		alu_if.a = tnx.a;
		alu_if.b = tnx.b;
		alu_if.cmd = tnx.cmd;

		//Wait for data to propgate out
		#4;
		tnx.result = alu.result;
	endtask

	protected task pre_drive();
	    gen2drv.peek(txn);
		foreach (cbs_list[i]) begin
			cbs_list[i].pre_drive(this, drop);
        end

	endtask

	protected task pre_drive();
		foreach (cbs_list[i])
			cbs_list[i].post_tx(this, txn);
		end
		gen2drv.get(txn);
		->drv2gen;
	endtask



endclass : Driver