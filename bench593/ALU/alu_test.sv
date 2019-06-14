
`include "alu_env.sv"
`include "alu_intf.sv"
`include "transaction.sv"
`timescale 1ps/1ps


program automatic test(alu_intf intf);

    environment env;
    alu_txn txn;
    initial begin
        env = new(intf);

        env.build();
        env.run();
        repeat(5) begin
            $display("===============================\n");
            txn = new;
            txn.randomize();
            env.generator_to_driver.put(txn);
            wait(env.driver_to_generator_event.triggered);
            #1;
        end
        env.finish();
    end

endprogram
