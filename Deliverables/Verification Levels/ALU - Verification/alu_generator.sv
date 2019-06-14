`ifndef GENERATOR
`define GENERATOR


`include "transaction.sv"

class alu_generator;
	protected alu_txn  txn;

	mailbox generator_to_driver;
	event   driver_to_generator_event;

	function new(mailbox generator_to_driver, event driver_to_generator_event);
		this.generator_to_driver = generator_to_driver;
		this.driver_to_generator_event = driver_to_generator_event;
	endfunction : new


	task run();
		repeat(`NUM_TEST_TXN) begin
            $display("===============================\n");
            txn = new;						//create a new transaction
            assert (txn.randomize() with { //randomize the transactions
				a dist {  				   //let's set the distrbution of a
					0 := 20,			   //20% of the time we want 0
					'hFFFF:= 20,,		  //20% of the time we want ones
					[1 :  'hFFFE]:/ 60    //60$ of the time we anything in beween
				};
				b dist {				//let's set the distrbution of b
					0:= 20,				//20% of the time we want 0
					'hFFFF:= 20,		//20% of the time we want ones
					[1 :  'hFFFE]:/ 60  //60$ of the time we anything in beween
				};
			});
            generator_to_driver.put(txn);	//put the transaction in the mailbox
            wait(driver_to_generator_event.triggered); //wait for the driver to send the transaction
            #1;
        end
	endtask: run
endclass : alu_generator

`endif // GENERATOR