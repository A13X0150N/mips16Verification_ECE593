
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
        env.finish();
    end

endprogram
