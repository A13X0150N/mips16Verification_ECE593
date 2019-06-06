
program automatic test;

    alu_intf_f intf;
    environment env;

    initial begin
        env = new(intf);

        env.build();
        env.run();
        env.finish();
    end

endprogram
