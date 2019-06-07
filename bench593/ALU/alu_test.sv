
`include "alu_env.sv"
`include "alu_intf.sv"
`include "transaction.sv"


program automatic test(alu_intf intf);

    environment env;
    alu_txn txn; 
    initial begin
        env = new(intf);

        env.build();
        env.run();
        repeat(19) begin
            txn = new;
            env.generator_to_driver.put(txn);
        end
        env.finish();
    end

endprogram
