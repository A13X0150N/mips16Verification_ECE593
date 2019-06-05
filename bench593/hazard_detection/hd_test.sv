`include "environment.sv"


program automatic test

    hd_intf_f intf;
    environment env;

    initial begin
        env = new(intf);

        env.build();
        env.run();
        env.finish();
    end

endprogram
