
`include "hd_env.sv"
`include "hd_intf.sv"
`include "transaction.sv"
`timescale 1ps/1ps


program automatic test(hd_intf intf);

    environment env;
    hd_txn txn;
    initial begin
        env = new(intf);

        env.build();
        env.run();
        env.finish();
    end

endprogram
